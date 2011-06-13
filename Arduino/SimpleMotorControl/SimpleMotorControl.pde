#define DEBUG_OUT_TRUE 
#define DEBUG_SERIAL_SPEED 4800

#define PwmPinMotorA 5
#define PwmPinMotorB 6

#define DirectionPinMotorA 4
#define DirectionPinMotorB 7


int speed = 128;

void setup()
{

 pinMode(PwmPinMotorA, OUTPUT);
 pinMode(PwmPinMotorB, OUTPUT);

 pinMode(DirectionPinMotorA, OUTPUT);
 pinMode(DirectionPinMotorB, OUTPUT);

Serial.begin(DEBUG_SERIAL_SPEED);


}

void loop()
{ 

delay(5000);

// case '8j':
// case '8J':
Serial.println("8j");
   analogWrite(PwmPinMotorB, speed);
   digitalWrite(DirectionPinMotorB, LOW);
   analogWrite(PwmPinMotorA, speed);
   digitalWrite(DirectionPinMotorA, HIGH);

delay(5000);

// case '2j':
// case '2J':
Serial.println("2j");
   analogWrite(PwmPinMotorB, speed);
   digitalWrite(DirectionPinMotorB, HIGH);
   analogWrite(PwmPinMotorA, speed);
   digitalWrite(DirectionPinMotorA, LOW);

delay(5000);

// case '6j':
// case '6J':
Serial.println("6j");
   analogWrite(PwmPinMotorB, speed);
   digitalWrite(DirectionPinMotorB, HIGH);
   analogWrite(PwmPinMotorA, speed);
   digitalWrite(DirectionPinMotorA, HIGH);

delay(5000);

// case '4j':
// case '4J':
Serial.println("4j");
   analogWrite(PwmPinMotorB, speed);
   digitalWrite(DirectionPinMotorB, LOW);
   analogWrite(PwmPinMotorA, speed);
   digitalWrite(DirectionPinMotorA, LOW);


delay(5000);

// case '1j':
// case '1J':
Serial.println("1j");
   analogWrite(PwmPinMotorB, speed);
   digitalWrite(DirectionPinMotorB, HIGH);

delay(5000);  

// case '7j':
// case '7J':
Serial.println("7j");
   analogWrite(PwmPinMotorB, speed);
   digitalWrite(DirectionPinMotorB, LOW);

delay(5000);

// case '9j':
// case '9J':
Serial.println("9j");
   analogWrite(PwmPinMotorA, speed);
   digitalWrite(DirectionPinMotorA, HIGH);

delay(5000);

// case '3j':
// case '3J':
Serial.println("3j");
   analogWrite(PwmPinMotorA, speed);
   digitalWrite(DirectionPinMotorA, LOW);

delay(5000);

// stop
Serial.println("stop");
   analogWrite(PwmPinMotorA, 0);
   digitalWrite(DirectionPinMotorA, LOW);
   analogWrite(PwmPinMotorB, 0);
   digitalWrite(DirectionPinMotorB, LOW);

delay(5000);


}
