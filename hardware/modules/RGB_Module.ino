#define RED 9
#define GREEN 8

void setup() {
  pinMode(RED, OUTPUT);
  pinMode(GREEN, OUTPUT);
}

void loop() {
  // RGB Red
  digitalWrite(RED, 255);

  delay(1000);

  // RGB Off
  digitalWrite(RED, 0);

  // RGB Green
  digitalWrite(GREEN, 255);

  delay(1000);

  // RGB Off
  digitalWrite(GREEN, 0);

  delay(1000);
}
