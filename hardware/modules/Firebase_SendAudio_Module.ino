#include <Arduino.h>
#include <FS.h>
#include <SD.h>
#include <SPI.h>
#include <Firebase_ESP_Client.h>
#include <addons/TokenHelper.h>
#include <addons/SDHelper.h>
#include <WiFi.h>

// ------- Definitions and Constants -------

volatile bool sentOnce = true;

// ------- Pin Definitions -------
#define I2S_WS 6
#define I2S_SD 5
#define I2S_SCK 4
#define SD_CS 10

// ------- WiFi Definitions -------
#define SSID "WIFI SSID"
#define wifiPW "WIFI PW"

// ------- Firebase Definitions and Initializations -------
#define API_KEY "API KEY"
#define USER_EMAIL "USER"
#define USER_PW "USER PW"
#define STORAGE_BUCKET "bucket"

FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

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
    // Only send once
    if (sentOnce) {

      // send file record.wav from SD card
      transmit_audio("record.wav");

      // Turn off flag (sent)
      sentOnce = false;
    }

    // Add a delay
    vTaskDelay(100 / portTICK_PERIOD_MS);
  }
}

void setup() {
  Serial.begin(115200);

  init_WiFi();

  init_Firebase();

  init_SD();

  xTaskCreatePinnedToCore(main_audio, "SendAudio", 8192, NULL, 1, NULL, 1);
}

void loop() {
  Firebase.ready();
  delay(100);
}