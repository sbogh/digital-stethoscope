#include <Arduino.h>
#include <Firebase_ESP_Client.h>
#include <addons/TokenHelper.h>
#include <driver/i2s.h>
#include <WiFi.h>
//#include <esp_wpa2.h> // not needed unless using UCSD WiFi

/*
Pins for XIAO ESP32-S3
#define I2S_WS 6
#define I2S_SD 5
#define I2S_SCK 4
#define BUTTON_PIN 1

Internal LED
*/

/*
Don't forget to add back in these things when running code:

WiFi SSID
WiFi Password
API Key

Also, add in your authentication information:
- User Email
- User PW

If using UCSD WiFi:
- Uncomment include for esp_wpa2.h
- Uncomment WPA2 block
- Uncomment Enterprise WiFi initialization function (init_eduroam)
- Comment out code to initialize normal WiFi in setup
- Uncomment line to initialize Enterprise WiFi in setup
*/

// ------- Definitions and Constants -------

// ------- Pin Definitions -------
#define I2S_WS 6
#define I2S_SD 5
#define I2S_SCK 4
#define BUTTON_PIN 2
#define RED 9
#define GREEN 8

// ------- I2S Definitions and Constants -------
#define I2S_PORT I2S_NUM_0
#define BUFFER_LEN 512
#define RECORD_TIME 30
const uint32_t SAMPLE_RATE = 44100;
const uint16_t BITS_PER_SAMPLE = 16;
const uint16_t CHANNELS = 1;
const uint16_t WAV_HEADER_BYTES = 44;

const uint32_t AUDIO_BYTES = SAMPLE_RATE * RECORD_TIME * (BITS_PER_SAMPLE / 8);
const uint32_t TOTAL_BYTES = WAV_HEADER_BYTES + AUDIO_BYTES;

// ------- Deep Sleep Vars -------
unsigned long lastActiveTime = 0;
#define INACTIVITY_TIMEOUT (5 * 60 * 1000)  // 5 minutes in ms
#define WAKEUP_MASK 0X4 // GPIO Pin 2 so 2^2 in hex

// ------- WiFi Definitions -------

#define SSID "WIFI SSID"
#define wifiPW "PASSWORD"

/*
// not needed unless using UCSD WiFi (WPA2 Block)
#define EAP_IDENTITY "username@ucsd.edu"
#define EAP_USERNAME "username@ucsd.edu"
#define EAP_PASSWORD "YOUR PASSWORD HERE"
const char *ssid = "eduroam";
*/

// ------- Firebase Definitions and Initializations -------
#define API_KEY "API KEY HERE"
#define USER_EMAIL "stethy.mcscopeface@gmail.com"
#define USER_PW "scopeface237"
#define STORAGE_BUCKET "scopeface-10e9a.firebasestorage.app"

FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

// ------- Device Identifying Information
#define DEVICE_ID "s3asf017"

// ------- Global Variables -------
int16_t sBuffer[BUFFER_LEN];
uint8_t *wavBuffer = nullptr;
volatile bool startRecording = false;

// ------- Button Press Functionality -------
void IRAM_ATTR onButtonPress() {
  startRecording = true;
}

// ------- I2S Set Up Functions -------
/*
* This function installs the I2S protocol on the designated pins
*/
void i2s_install() {
  const i2s_config_t i2s_config = {
    .mode = (i2s_mode_t)(I2S_MODE_MASTER | I2S_MODE_RX),
    .sample_rate = SAMPLE_RATE,
    .bits_per_sample = I2S_BITS_PER_SAMPLE_16BIT,
    .channel_format = I2S_CHANNEL_FMT_ONLY_LEFT,
    .communication_format = I2S_COMM_FORMAT_STAND_I2S,
    .intr_alloc_flags = 0,
    .dma_buf_count = 8,
    .dma_buf_len = BUFFER_LEN,
    .use_apll = false,
    .tx_desc_auto_clear = false,
    .fixed_mclk = 0
  };
  i2s_driver_install(I2S_PORT, &i2s_config, 0, NULL);
}

/*
* This function sets the pins for the I2S protocol. This includes setting the serial clock (SCK), 
* word select (WS), and serial data (SD).
*/
void i2s_setpin() {
  const i2s_pin_config_t pin_config = {
    .bck_io_num = I2S_SCK,
    .ws_io_num = I2S_WS,
    .data_out_num = -1,
    .data_in_num = I2S_SD
  };
  i2s_set_pin(I2S_PORT, &pin_config);
}

/*
* This is the callable function that initializes the I2S protocol for the digital microphone.
*/
void init_i2s() {
  i2s_install();
  i2s_setpin();
  i2s_start(I2S_PORT);
}

// ------- Write WAV Header -------
/*
* This function writes the WAV header to the buffer. See WAV file documentation for WAV header standard.
*/
void writeWavHeader(uint8_t *buffer, uint32_t audioLen) {
  uint32_t byteRate = SAMPLE_RATE * CHANNELS * BITS_PER_SAMPLE / 8;
  uint32_t totalDataLen = audioLen + 36;

  memcpy(buffer, "RIFF", 4);
  memcpy(buffer + 4, &totalDataLen, 4);
  memcpy(buffer + 8, "WAVEfmt ", 8);

  uint32_t subchunk1Size = 16;
  uint16_t audioFormat = 1; // PCM
  uint16_t blockAlign = CHANNELS * BITS_PER_SAMPLE / 8;

  memcpy(buffer + 16, &subchunk1Size, 4);
  memcpy(buffer + 20, &audioFormat, 2);
  memcpy(buffer + 22, &CHANNELS, 2);
  memcpy(buffer + 24, &SAMPLE_RATE, 4);
  memcpy(buffer + 28, &byteRate, 4);
  memcpy(buffer + 32, &blockAlign, 2);
  memcpy(buffer + 34, &BITS_PER_SAMPLE, 2);
  memcpy(buffer + 36, "data", 4);
  memcpy(buffer + 40, &audioLen, 4);
}

// ------- Initialize Buttons and LED -------
/*
* This function initializes all peripheral components of the hardware. This includes the push button, 
* the RGB light, PSRAM (for buffer store), and the WAV file buffer.
*/
void init_peripherals() {
  // Initialize button and attach button press event to trigger flag
  pinMode(BUTTON_PIN, INPUT_PULLDOWN);
  attachInterrupt(BUTTON_PIN, onButtonPress, RISING);

  // Initialize RGB LED
  pinMode(RED, OUTPUT);
  pinMode(GREEN, OUTPUT);

  // Ensure RGB LED is OFF
  digitalWrite(RED, 0);
  digitalWrite(GREEN, 0);

  // Check for PSRAM initialization
  if (psramFound()) {
    Serial.println("PSRAM is available.");
    Serial.printf("Free PSRAM: %d bytes\n", ESP.getFreePsram());
  } else {
    Serial.println("PSRAM not detected.");
  }

  // Initialize WAV file buffer
  wavBuffer = (uint8_t*) ps_malloc(TOTAL_BYTES);
  if (!wavBuffer) {
    Serial.println("Failed to allocate PSRAM buffer.");
    while (true); // halt program
  }

  // Initialize the last active time
  lastActiveTime = millis();
}

// ------- Initialize WiFi -------
/*
* This function initializes WiFi connection.
*/
void init_WiFi() {
  WiFi.begin(SSID, wifiPW);

  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED) {
      Serial.print(".");
      delay(300);
  }

  Serial.println("\nWiFi connected. IP address: ");
  Serial.println(WiFi.localIP());
}

// ------- Timeout Check Function -------
/*
* This function checks how long the device has been inactive and puts the device into deep sleep
* if it has been more than the inactivity time time.
*/
void timeout_check() {
  // Check if the elapsed time since activity is longer than the timeout
  if ((millis() - lastActiveTime >= INACTIVITY_TIMEOUT) && !startRecording) {
    Serial.println("Inactivity timeout reached. Entering deep sleep...");

    // Configure EXT1 wakeup (wake on HIGH from GPIO 2)
    esp_sleep_enable_ext1_wakeup(WAKEUP_MASK, ESP_EXT1_WAKEUP_ANY_HIGH);

    // Properly close WiFi connection
    WiFi.disconnect();

    // Actually go to sleep
    esp_deep_sleep_start();
  }
}

/*
// not needed unless using UCSD WiFi
// This function is an alternative to init_WiFi() that initializes an authenticated WiFi connection (eduroam).
void init_Eduroam() {
  WiFi.mode(WIFI_STA);
  esp_wifi_sta_wpa2_ent_enable();

  esp_wifi_sta_wpa2_ent_set_identity((uint8_t *)EAP_IDENTITY, strlen(EAP_IDENTITY));
  esp_wifi_sta_wpa2_ent_set_username((uint8_t *)EAP_USERNAME, strlen(EAP_USERNAME));
  esp_wifi_sta_wpa2_ent_set_password((uint8_t *)EAP_PASSWORD, strlen(EAP_PASSWORD));

  WiFi.begin(ssid);

  Serial.print("Connecting to eduroam");
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.print(".");
  }

  Serial.println("\nWiFi connected. IP address: ");
  Serial.println(WiFi.localIP());
}
*/

// ------- Initialize Firebase -------
/*
* This function initializes and authenticates the Firebase Client connection. 
*/
void init_Firebase() {
  Serial.printf("Firebase Client v%s\n\n", FIREBASE_CLIENT_VERSION);
  Serial.println("Initializing app...");

  config.api_key = API_KEY;
  auth.user.email = USER_EMAIL;
  auth.user.password = USER_PW;

  config.token_status_callback = tokenStatusCallback;
  Firebase.reconnectNetwork(true);
  fbdo.setBSSLBufferSize(8192, 2048); // previously 4096, 1024
  Firebase.begin(&config, &auth);
}

// ------- Generate File Name Function
/*
* This function generates a filename for use on the Firebase Storage side. The identifier uses the format {device_id}_{random_num}.
*/
String generate_filename() {
  return "/" + String(DEVICE_ID) + "_" + String(random(100000)) + ".wav";
}

// ------- Audio Helpers -------
/*
* This is a callback function provided from the Firebase library that provides detailed information about errors, upload status, and completion messages.
*/
void fcsUploadCallback(FCS_UploadStatusInfo info)
{
    if (info.status == firebase_fcs_upload_status_init)
    {
        Serial.printf("Uploading file %s (%d) to %s\n", info.localFileName.c_str(), info.fileSize, info.remoteFileName.c_str());
    }
    else if (info.status == firebase_fcs_upload_status_upload)
    {
        Serial.printf("Uploaded %d%s, Elapsed time %d ms\n", (int)info.progress, "%", info.elapsedTime);
    }
    else if (info.status == firebase_fcs_upload_status_complete)
    {
        Serial.println("Upload completed\n");
        FileMetaInfo meta = fbdo.metaData();
        Serial.printf("Name: %s\n", meta.name.c_str());
        Serial.printf("Bucket: %s\n", meta.bucket.c_str());
        Serial.printf("Size: %d\n", meta.size);
        Serial.printf("Download URL: %s\n\n", fbdo.downloadURL().c_str());
    }
    else if (info.status == firebase_fcs_upload_status_error)
    {
        Serial.printf("Upload failed, %s\n", info.errorMsg.c_str());
    }
}

// ------- Record Audio Task
/*
* This is the main function to record and transmit audio from the microphone.
*/
void record_and_transmit() {
  // Check if buffer has been initialized
  if (!wavBuffer) {return;}

  // Write the WAV header to buffer
  writeWavHeader(wavBuffer, AUDIO_BYTES);

  // Turn RGB RED
  digitalWrite(RED, 255);

  // Record audio
  Serial.println("Recording audio...");
  unsigned long starttime = millis(); // get start time
  uint32_t offset = 44;

  // record for specified record time (seconds) or until buffer is full
  while (millis() - starttime < RECORD_TIME * 1000 && offset + BUFFER_LEN * sizeof(int16_t) <= TOTAL_BYTES) {
    size_t bytesRead;
    if(i2s_read(I2S_PORT, sBuffer, sizeof(sBuffer), &bytesRead, portMAX_DELAY) == ESP_OK && bytesRead > 0) {
      memcpy(wavBuffer + offset, sBuffer, bytesRead);
      offset += bytesRead;
    } else {
      Serial.println("I2S read error or buffer overflow.");
      free(wavBuffer);
      return;
    }
  }

  Serial.println("Recording complete. Uploading...");

  // Turn RGB GREEN
  digitalWrite(RED, 0);
  digitalWrite(GREEN, 255);

  // Get filename
  String path = generate_filename();

  // If the Firebase connection fails return
  if (!Firebase.ready()) {return;}

  // If the Firebase upload fails print the error message and return
  if (!Firebase.Storage.upload(
    &fbdo,
    STORAGE_BUCKET,
    wavBuffer,
    offset,
    path,
    "audio/wav",
    fcsUploadCallback)) {

    Serial.println("Firebase Upload Failed: " + fbdo.errorReason());
  }

  // Turn off RGB
  digitalWrite(GREEN, 0);

  return;
}

// ------- Record Audio Task -------
/*
* Main code that runs full audio pipeline. Task is pinned to core and waits for flag to be triggered to begin pipeline.
*/
void main_audio(void *parameter) {
  while (true) {
    // Wait for button press
    if (startRecording) {
      // Reset inactivity time to ensure deep sleep doesn't happen mid recording
      lastActiveTime = millis();

      // Record and transmit task
      record_and_transmit();

      // Reset inactivity time to after recording and upload finish
      lastActiveTime = millis();

      // Turn off recording flag
      startRecording = false;
    }

    // Add a delay
    vTaskDelay(100 / portTICK_PERIOD_MS);
  }
}

void setup() {
  Serial.begin(115200);

  init_i2s();

  init_WiFi();
  //init_Eduroam(); // not needed unless using UCSD WiFi

  init_Firebase();

  init_peripherals();

  // Pin the audio pipeline task to core 1 and provide with specified stack size (expanded)
  xTaskCreatePinnedToCore(main_audio, "AudioPipeline", 8192, NULL, 1, NULL, 1);
}

void loop() {
  // Make sure the async Firebase connection stays alive
  Firebase.ready();
  delay(100);

  // Check for timeout at every loop iteration
  timeout_check();
}