const int trigPin = 2;
const int echoPin = 3;
const int greenLedPin = 8;
const int redLedPin = 9;
const int buzzerPin = 10;
const float occupiedThresholdCm = 20.0;
const unsigned long echoTimeoutUs = 30000UL;

void setup()
{
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  pinMode(greenLedPin, OUTPUT);
  pinMode(redLedPin, OUTPUT);
  pinMode(buzzerPin, OUTPUT);
  Serial.begin(9600);
}

void loop()
{
  unsigned long echoTime;
  float distanceCm;

  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);

  echoTime = pulseIn(echoPin, HIGH, echoTimeoutUs);

  if (echoTime == 0) {
    distanceCm = -1.0;
    digitalWrite(greenLedPin, HIGH);
    digitalWrite(redLedPin, LOW);
    noTone(buzzerPin);
    Serial.println("No echo. Space shown as available.");
  } else {
    distanceCm = echoTime * 0.0343 / 2.0;
    Serial.print("Distance: ");
    Serial.print(distanceCm, 1);
    Serial.println(" cm");

    if (distanceCm <= occupiedThresholdCm) {
      digitalWrite(greenLedPin, LOW);
      digitalWrite(redLedPin, HIGH);
      tone(buzzerPin, 1000);
    } else {
      digitalWrite(greenLedPin, HIGH);
      digitalWrite(redLedPin, LOW);
      noTone(buzzerPin);
    }
  }

  delay(200);
}
