#include <Arduino.h>
#include <FS.h>
#include <SD.h>
#include <SPI.h>
#include <Firebase_ESP_Client.h>
#include <addons/TokenHelper.h>
#include <addons/SDHelper.h>
#include <driver/i2s.h>
#include <WiFi.h>

// ------- Definitions and Constants -------

// ------- Pin Definitions -------
#define I2S_WS 6
#define I2S_SD 5
#define I2S_SCK 4
#define BUTTON_PIN 21
#define INTERNAL_LED 48
#define SD_CS 10

// ------- I2S Definitions and Constants -------
#define I2S_PORT I2S_NUM_0
#define BUFFER_LEN 512
#define RECORD_TIME 30
const uint32_t SAMPLE_RATE = 44100;
const uint16_t BITS_PER_SAMPLE = 16;
const uint16_t CHANNELS = 1;

// ------- WiFi Definitions -------
#define SSID "SpectrumSetup-53"
#define wifiPW "desertmarble967"

// ------- Firebase Definitions and Initializations -------
#define API_KEY "AIzaSyC37GeX4Ag0h5THhOddu_a9h2ncl87UKzM"
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
volatile bool startRecording = false;

// ------- Button Press Functionality -------
void IRAM_ATTR onButtonPress() {
  startRecording = true;
}

// ------- I2S Set Up Functions -------
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

void i2s_setpin() {
  const i2s_pin_config_t pin_config = {
    .bck_io_num = I2S_SCK,
    .ws_io_num = I2S_WS,
    .data_out_num = -1,
    .data_in_num = I2S_SD
  };
  i2s_set_pin(I2S_PORT, &pin_config);
}

void init_i2s() {
  i2s_install();
  i2s_setpin();
  i2s_start(I2S_PORT);
}

// ------- Write WAV Header -------
void writeWavHeader(File &file, uint32_t totalAudioLen) {
  uint32_t byteRate = SAMPLE_RATE * CHANNELS * BITS_PER_SAMPLE / 8;
  uint32_t totalDataLen = totalAudioLen + 36;

  byte header[44];

  memcpy(header, "RIFF", 4);
  memcpy(header + 4, &totalDataLen, 4);
  memcpy(header + 8, "WAVE", 4);
  memcpy(header + 12, "fmt ", 4);

  uint32_t subchunk1Size = 16;
  uint16_t audioFormat = 1; // PCM
  memcpy(header + 16, &subchunk1Size, 4);
  memcpy(header + 20, &audioFormat, 2);
  memcpy(header + 22, &CHANNELS, 2);
  memcpy(header + 24, &SAMPLE_RATE, 4);
  memcpy(header + 28, &byteRate, 4);
  uint16_t blockAlign = CHANNELS * BITS_PER_SAMPLE / 8;
  memcpy(header + 32, &blockAlign, 2);
  memcpy(header + 34, &BITS_PER_SAMPLE, 2);
  memcpy(header + 36, "data", 4);
  memcpy(header + 40, &totalAudioLen, 4);

  file.write(header, 44);
}

// ------- Initialize Buttons and LED -------
void init_buttons() {
  pinMode(BUTTON_PIN, INPUT_PULLDOWN);
  pinMode(INTERNAL_LED, OUTPUT);
  attachInterrupt(BUTTON_PIN, onButtonPress, RISING);
}

// ------- Initialize WiFi -------
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

// ------- Initialize Firebase -------
void init_Firebase() {
  Serial.printf("Firebase Client v%s\n\n", FIREBASE_CLIENT_VERSION);
  Serial.println("Initializing app...");

  config.api_key = API_KEY;
  auth.user.email = USER_EMAIL;
  auth.user.password = USER_PW;

  config.token_status_callback = tokenStatusCallback;
  Firebase.reconnectNetwork(true);
  fbdo.setBSSLBufferSize(4096, 1024);
  Firebase.begin(&config, &auth);
}

// ------- Initialize SD
void init_SD() {
  if (!SD.begin(SD_CS)) {
    Serial.println("SD card initialization failed!");
    while (1);
  }
  Serial.println("SD card initialized.");
}

// ------- Generate File Name Function
String generate_filename() {
  return "/" + String(DEVICE_ID) + "_" + String(random(100000)) + ".wav";
}

// ------- Record and Save Audio Task
bool record_audio(String filename) {
  // Open (create) file in SD card
  File file = SD.open(filename, FILE_WRITE);
  if (!file) {
    Serial.println("Failed to open file for writing");
    return false;
  }

  // Skip past WAV header location
  file.seek(44);

  // Record and write data to file
  uint32_t bytesWritten = 0;
  unsigned long starttime = millis(); // get start time

  // record for 30 seconds
  while (millis() - starttime < RECORD_TIME * 1000) {
    size_t bytesRead = 0;
    esp_err_t result = i2s_read(I2S_PORT, sBuffer, sizeof(sBuffer), &bytesRead, portMAX_DELAY);

    // Check if valid result and then write
    if (result == ESP_OK && bytesRead > 0) {
      file.write((byte *)sBuffer, bytesRead);
      bytesWritten += bytesRead;
    } else {
      file.close();
      return false;
    }
  }

  // Go back to start of file and write the WAV header
  file.seek(0);
  writeWavHeader(file, bytesWritten);

  // Close file
  file.close();

  return true;
}

// ------- Send Audio Function and Helpers -------
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

void transmit_audio(String filename) {
  if (!Firebase.ready()) {return;}

  if (!Firebase.Storage.upload(
    &fbdo,
    STORAGE_BUCKET,
    filename,
    mem_storage_type_sd,
    filename,
    "audio/wav",
    fcsUploadCallback)) {

    Serial.println("Firebase Upload Failed: " + fbdo.errorReason());
  }
}

// ------- Record Audio Task -------
void main_audio(void *parameter) {
  while (true) {
    // Wait for button press
    if (startRecording) {
      Serial.println("Recording started...");

      // Turn on LED
      digitalWrite(INTERNAL_LED, HIGH);

      // Get filename
      String filename = generate_filename();

      if (record_audio(filename)) {
        Serial.println("Recording saved to SD as " + filename + "\n");
        transmit_audio(filename);
      }

      // Turn off LED
      digitalWrite(INTERNAL_LED, LOW);

      // Turn off recording flag
      startRecording = false;
    }

    // Add a delay
    vTaskDelay(100 / portTICK_PERIOD_MS);
  }
}

void setup() {
  Serial.begin(115200);

  init_buttons();

  init_i2s();

  init_WiFi();

  init_Firebase();

  init_SD();

  xTaskCreatePinnedToCore(main_audio, "AudioPipeline", 8192, NULL, 1, NULL, 1);
}

void loop() {
  Firebase.ready();
  delay(100);
}