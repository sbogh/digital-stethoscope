#define RED 9
#define GREEN 8
#define BLUE 7

void setup() {
  pinMode(redPin, OUTPUT);
  pinMode(greenPin, OUTPUT);
  pinMode(bluePin, OUTPUT);
}

void loop() {
  // RGB Red
  digitalWrite(redPin, 255);

  delay(1000);

  // RGB Off
  digitalWrite(redPin, 0);

  // RGB Green
  digitalWrite(greenPin, 255);

  delay(1000);

  // RGB Off
  digitalWrite(greenPin, 0);

  delay(1000);
}