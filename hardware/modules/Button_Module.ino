#include <Arduino.h>

/*
* Attach GPIO Pin 21 to one lead of button and 3.3V to other lead (diagonal leads)
*/

#define BUTTON_PIN 21

void setup() {
  Serial.begin(115200);

  pinMode(BUTTON_PIN, INPUT_PULLDOWN);
}

void loop() {
  Serial.println(digitalRead(BUTTON_PIN));
}