#include <driver/i2s.h>

#define I2S_WS 6
#define I2S_SD 5
#define I2S_SCK 4
#define I2S_PORT I2S_NUM_0

#define BUTTON_PIN 2

#define RECORD_TIME 10

// Define input buffer length
#define bufferLen 512
int16_t sBuffer[bufferLen];

void i2s_install() {
  // Set up I2S Processor configuration
  const i2s_config_t i2s_config = {
    .mode = i2s_mode_t(I2S_MODE_MASTER | I2S_MODE_RX),
    .sample_rate = 44100,
    .bits_per_sample = i2s_bits_per_sample_t(16),
    .channel_format = I2S_CHANNEL_FMT_ONLY_LEFT,
    .communication_format = i2s_comm_format_t(I2S_COMM_FORMAT_STAND_I2S),
    .intr_alloc_flags = 0,
    .dma_buf_count = 8,
    .dma_buf_len = bufferLen,
    .use_apll = false
  };

  i2s_driver_install(I2S_PORT, &i2s_config, 0, NULL);
}

void i2s_setpin() {
  // Set I2S pin configuration
  const i2s_pin_config_t pin_config = {
    .bck_io_num = I2S_SCK,
    .ws_io_num = I2S_WS,
    .data_out_num = -1,
    .data_in_num = I2S_SD
  };

  i2s_set_pin(I2S_PORT, &pin_config);
}

void setup() {
  Serial.begin(115200);

  delay(1000);

  pinMode(BUTTON_PIN, INPUT_PULLDOWN);
  delay(100);
  pinMode(LED_BUILTIN, OUTPUT);

  delay(500);

  i2s_install();
  i2s_setpin();
  i2s_start(I2S_PORT);

  delay(100);
  digitalWrite(LED_BUILTIN, HIGH); // ensure LED is off in start state

  delay(500);
}

void loop() {
  Serial.println(digitalRead(BUTTON_PIN));

  if (digitalRead(BUTTON_PIN) == 1)
  {
    unsigned long starttime = millis();

    while (millis() - starttime <= RECORD_TIME * 1000)
    {
      // Enable LED (LOW == ON)
      digitalWrite(LED_BUILTIN, LOW);

      Serial.println(digitalRead(BUTTON_PIN));
      Serial.print(" ");
      Serial.print(-3000);
      Serial.print(" ");
      Serial.print(3000);
      Serial.print(" ");

      // Get I2S data and place in data buffer
      size_t bytesIn = 0;
      esp_err_t result = i2s_read(I2S_PORT, &sBuffer, bufferLen, &bytesIn, portMAX_DELAY);

      if (result == ESP_OK)
      {
        // Read I2S data buffer
        int16_t samples_read = bytesIn / 8;
        if (samples_read > 0) {
          float mean = 0;
          for (int16_t i = 0; i < samples_read; ++i) {
            mean += (sBuffer[i]);
          }

          // Average the data reading
          mean /= samples_read;

          // Print to serial plotter
          Serial.println(mean);
        }
      }
    }

    // Disable LED (HIGH == OFF)
    digitalWrite(LED_BUILTIN, HIGH);
  } 
  
  delay(1000);
}
