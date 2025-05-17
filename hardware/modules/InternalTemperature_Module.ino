void setup() {
  Serial.begin(115200);
}

void loop() {
  float temp = temperatureRead() * (9/5) + 32;

  Serial.print("Chip Temperature: ");
  Serial.print(temp);
  Serial.println("°F");

  delay(1000);
}