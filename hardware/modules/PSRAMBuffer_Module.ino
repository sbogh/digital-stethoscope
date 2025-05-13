#include <Arduino.h>
#include <Firebase_ESP_Client.h>
#include <addons/TokenHelper.h>
#include <driver/i2s.h>

// ------- Definitions and Constants -------

// ------- Pin Definitions -------
#define I2S_WS 6
#define I2S_SD 5
#define I2S_SCK 4
#define BUTTON_PIN 21

// ------- I2S Definitions and Constants -------
#define I2S_PORT I2S_NUM_0
#define BUFFER_LEN 512
#define RECORD_TIME 10
const uint32_t SAMPLE_RATE = 44100;
const uint16_t BITS_PER_SAMPLE = 16;
const uint16_t CHANNELS = 1;
const uint16_t WAV_HEADER_BYTES = 44;

const uint32_t AUDIO_BYTES = SAMPLE_RATE * RECORD_TIME * (BITS_PER_SAMPLE / 8);
const uint32_t TOTAL_BYTES = WAV_HEADER_BYTES + AUDIO_BYTES;

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

  // Initialize RGB light on board
  #ifdef RGB_BUILTIN
    pinMode(RGB_BUILTIN, OUTPUT);
    rgbLedWrite(RGB_BUILTIN, 0, 0, 0); // Ensure LED starts off
    Serial.println("RGB LED initialized");
  #else
    Serial.println("RGB_BUILTIN not defined for this board");
  #endif

  // Check for PSRAM initialization
  if (psramFound()) {
    Serial.println("PSRAM is available.");
    Serial.printf("Free PSRAM: %d bytes\n", ESP.getFreePsram());
  } else {
    Serial.println("PSRAM not detected.");
  }
}

// ------- Generate File Name Function
/*
* This function generates a filename for use on the Firebase Storage side. The identifier uses the format {device_id}_{random_num}.
*/
String generate_filename() {
  return "/" + String(DEVICE_ID) + "_" + String(random(100000)) + ".wav";
}

// ------- Record Audio Task
/*
* This is the main function to record and transmit audio from the microphone.
*/
void record_and_store() {
  // Initialize WAV file buffer
  wavBuffer = (uint8_t*) ps_malloc(TOTAL_BYTES);
  if (!wavBuffer) {
    Serial.println("Failed to allocate PSRAM buffer.");
    while (true); // halt program
  }

  // Write the WAV header to buffer
  writeWavHeader(wavBuffer, AUDIO_BYTES);

  // Turn on LED (red to show recording)
  rgbLedWrite(RGB_BUILTIN, RGB_BRIGHTNESS, 0, 0);

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

  Serial.println("Buffer stored successfully! Freeing...")

  free(wavBuffer);

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
      // Record and transmit task
      record_and_store();

      // Turn off recording flag
      startRecording = false;
    }

    // Add a delay
    vTaskDelay(100 / portTICK_PERIOD_MS);
  }
}

void setup() {
  Serial.begin(115200);

  init_peripherals();

  init_i2s();

  // Pin the audio pipeline task to core 1 and provide with specified stack size (expanded)
  xTaskCreatePinnedToCore(main_audio, "RecordAndStore", 8192, NULL, 1, NULL, 1);
}

void loop() {
  // Make sure the async Firebase connection stays alive
  Firebase.ready();
  delay(100);
}