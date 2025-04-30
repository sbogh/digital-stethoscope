#include <driver/i2s.h>

/*
ESP32-S3 Hardware Wiring:

WS -> GPIO 11
SD -> GPIO 10
SCK -> GPIO 9

LED -> GPIO 48 (Green Light on built-in RGB)

Button -> GPIO 21
*/

// Connections to I2S microphone
#define I2S_WS 11
#define I2S_SD 10
#define I2S_SCK 9

// Use I2S Processor 0
#define I2S_PORT I2S_NUM_0

// Internal LED
#define INTERNAL_LED 48

// Button GPIO
#define BUTTON_PIN 21

// Define input buffer length
#define bufferLen 64
int16_t sBuffer[bufferLen];

// I2S Configuration
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

// I2S Set Pins
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
  // Begin Serial data stream at baud rate of 115200
  Serial.begin(115200);
  Serial.println(" ");

  delay(1000);

  // Set GPIO attached to button as defaulting to 0 (using internal pulldown resistor)
  pinMode(BUTTON_PIN, INPUT_PULLDOWN);

  delay(500);

  // I2S Initialization
  i2s_install();
  i2s_setpin();
  i2s_start(I2S_PORT);

  delay(500);
}

void loop() {
  // Visual debugging to read current state of the button (default 0, when depressed 1)
  Serial.println(digitalRead(BUTTON_PIN));

  // Initialize the start and end times for the timed loop
  unsigned long starttime;
  unsigned long endtime;

  // If the button is depressed (button value = 1)
  if (digitalRead(BUTTON_PIN) == 1)
  {
    // record a start time and set the end time to the same value
    starttime = millis();
    endtime = starttime;

    // Loop until 30 seconds have passed
    while (endtime - starttime <= 30000)
    {
      // Enable internal LED (visual confirmation that device is recording)
      digitalWrite(INTERNAL_LED, HIGH);

      // Helpful data on serial plotter to view microphone data (provides bounds)
      int rangelimit = 3000;
      Serial.println(digitalRead(BUTTON_PIN));
      Serial.print(" ");
      Serial.print(rangelimit * -1);
      Serial.print(" ");
      Serial.print(rangelimit);
      Serial.print(" ");

      // Get I2S data and place in data buffer
      size_t bytesIn = 0;
      esp_err_t result = i2s_read(I2S_PORT, &sBuffer, bufferLen, &bytesIn, portMAX_DELAY);

      // If the returned data is valid
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

      // Update the end time value after each iteration of the loop
      endtime = millis();
    }

    // Disable internal LED
    digitalWrite(INTERNAL_LED, LOW);
  } 
  
  delay(1000);
}