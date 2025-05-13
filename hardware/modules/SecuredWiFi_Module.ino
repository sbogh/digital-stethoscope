#include <WiFi.h>
#include "esp_wpa2.h"

#define EAP_IDENTITY "youruser@ucsd.edu"
#define EAP_USERNAME "youruser@ucsd.edu"
#define EAP_PASSWORD "PW"

const char* ssid = "eduroam";

void setup() {
  Serial.begin(115200);

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

  Serial.println();
  Serial.print("Connected! IP address: ");
  Serial.println(WiFi.localIP());
}

void loop() {
}