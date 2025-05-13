#include <Arduino.h>
#include <FS.h>
#include <SD.h>
#include <SPI.h>

#define SD_CS 10

// ------- Initialize SD
void init_SD() {
  if (!SD.begin(SD_CS)) {
    Serial.println("SD card initialization failed!");
    while (1);
  }
  Serial.println("SD card initialized.");
}

// ------- Record and Save Audio Task
void test_file(String filename) {
  // Open (create) file in SD card
  File file = SD.open(filename, FILE_WRITE);
  if (!file) {
    Serial.println("Failed to open file for writing");
    return;
  }

  delay(500);

  Serial.println("File created.");

  file.close();
}


void setup() {
  Serial.begin(115200);

  init_SD();

  test_file("test.txt");
}

void loop() {
}