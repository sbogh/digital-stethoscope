#include <driver/i2s.h>
#include <SD.h>
#include <SPI.h>

// --- Pin Definitions ---
#define I2S_WS 6
#define I2S_SD 5
#define I2S_SCK 4
#define BUTTON_PIN 21
#define INTERNAL_LED 48
#define SD_CS 10

// --- I2S and Recording Settings ---
#define I2S_PORT I2S_NUM_0
const uint32_t SAMPLE_RATE = 44100;
const uint16_t BITS_PER_SAMPLE = 16;
const uint16_t CHANNELS = 1;
#define BUFFER_LEN 512  
#define RECORD_TIME 30

int16_t sBuffer[BUFFER_LEN];
volatile bool startRecording = false;

// --- ISR for Button Press ---
void IRAM_ATTR onButtonPress() {
  startRecording = true;
}

// --- I2S Setup ---
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

// --- Write WAV Header ---
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

// --- I2S Recording Task ---
void i2s_task(void *parameter) {
  while (true) {
    if (startRecording) {
      Serial.println("Recording started...");
      digitalWrite(INTERNAL_LED, HIGH);

      // Create WAV file
      String filename = "/record.wav";
      File file = SD.open(filename, FILE_WRITE);
      if (!file) {
        Serial.println("Failed to open file for writing");
        startRecording = false;
        continue;
      }

      // Reserve space for WAV header
      file.seek(44);

      uint32_t bytesWritten = 0;
      unsigned long starttime = millis();
      while (millis() - starttime < RECORD_TIME * 1000) {
        size_t bytesRead = 0;
        esp_err_t result = i2s_read(I2S_PORT, sBuffer, sizeof(sBuffer), &bytesRead, portMAX_DELAY);
        if (result == ESP_OK && bytesRead > 0) {
          file.write((byte *)sBuffer, bytesRead);
          bytesWritten += bytesRead;
        }
      }

      file.seek(0);
      writeWavHeader(file, bytesWritten);
      file.close();

      Serial.println("Recording saved to SD as /record.wav");
      digitalWrite(INTERNAL_LED, LOW);
      startRecording = false;
    }

    vTaskDelay(100 / portTICK_PERIOD_MS);
  }
}

void setup() {
  Serial.begin(115200);
  pinMode(BUTTON_PIN, INPUT_PULLDOWN);
  pinMode(INTERNAL_LED, OUTPUT);
  attachInterrupt(BUTTON_PIN, onButtonPress, RISING);

  // Start I2S
  i2s_install();
  i2s_setpin();
  i2s_start(I2S_PORT);

  // Start SD card
  if (!SD.begin(SD_CS)) {
    Serial.println("SD card initialization failed!");
    while (1);
  }
  Serial.println("SD card initialized.");

  // Start task
  xTaskCreatePinnedToCore(
    i2s_task, "I2S Recorder", 8192, NULL, 1, NULL, 1);
}

void loop() {
}