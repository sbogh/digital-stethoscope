#define BUTTON_PIN_BITMASK 0x4  // 2^2 in hex (GPIO Pin 2)

void setup() {
  Serial.begin(115200);

  delay(1000);

  Serial.println("Going into deep sleep.");

  delay(1000);

  esp_sleep_enable_ext1_wakeup(BUTTON_PIN_BITMASK, ESP_EXT1_WAKEUP_ANY_HIGH);
  delay(1000);

  esp_deep_sleep_start();
}

void loop() {

}