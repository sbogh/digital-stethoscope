#include <WiFi.h>

#define SSID "WIFI SSID"
#define wifiPW "PASSWORD"

void setup() {
  Serial.begin(115200);
  
  WiFi.begin(SSID, wifiPW);

  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED) {
      Serial.print(".");
      delay(300);
  }

  Serial.println("\nWiFi connected. IP address: ");
  Serial.println(WiFi.localIP());
}

void loop() {
}
