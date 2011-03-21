// Firmware for the Android Shield Board for tank robots
// Pan/tilt servos now work: 0 pin off, 255 pin on, 1~254 8 bit granularity servo movement (5 microseconds).
#define PwmPinMotorA 5
#define PwmPinMotorB 6
#define DirectionPinMotorA 4
#define DirectionPinMotorB 7
#define ServoPin1 3
#define ServoPin2 8

#define mySerialSpeed 4800 // arduino 2009: 4800 or lower!
#define debugSerialSpeed 4800 // arduino 2009: 4800 or lower!
#define BufferLength 16
#define LineEnd1 13
#define LineEnd2 10
#define ServoTimingStep 5
#define ServoCenter 1500
#define ServoTimingFloor ServoCenter-(127*ServoTimingStep)

#define LED_PIN 13

//#define serialout 
#define debugout

#include <NewSoftSerial.h>

NewSoftSerial mySerial(2, 255); // rx only

char charin = 80;
char inputBuffer[BufferLength];
int value = 128;
int speed = 128;
int timer = 15;
int timermax = 15;
int inputLength = 0;
int servoval1 = 127;
int servoval2 = 127;
int tempval1, tempval2;

void setup()
{
    pinMode(LED_PIN, OUTPUT);
    
  mySerial.begin(mySerialSpeed); 
#ifdef debugout
  Serial.begin(debugSerialSpeed);
#endif

  digitalWrite(LED_PIN, HIGH);
}

// process a command string
void HandleCommand(char* input, int length)
{
#ifdef debugout
  Serial.print(">");
  Serial.print(input);
  Serial.print("<");
  Serial.print(length);
  Serial.println("|");
#endif
  if (length < 1) { // not a valid command
    return;
  }
  // calculate number following command (d10~d255)
  if (length > 1) {
    
  }

  timer = timermax;

  int* command = (int*)input;
  // check commands
  // note that the two bytes are swapped, ie 'RA' means command AR



  switch(*command) {
  }  
} 

void loop()
{ 
     
#ifdef debugout
    Serial.println("Entered loop, debugout is defined");
#endif

#ifdef serialout
    mySerial.print("Entered loop, serialout is defined");
#endif
  
  // get a command string form the mySerial port
  inputLength = 0;
  
  do {
    while (!mySerial.available()){
        delay(15);
    }; 

    // wait for input 
    {
      charin = mySerial.read(); // read it in
#ifdef debugout
        Serial.print(charin);
        tempval1 = charin;
        Serial.println(tempval1);
#endif

      if (charin > 31 && charin < 128)
      {
        inputBuffer[inputLength]=charin;
        inputLength++;

#ifdef serialout
        mySerial.print("$PD,11,");
        mySerial.print(timer);
        mySerial.print(",");
        mySerial.print(value);
        mySerial.println("*");
#endif
      }

    }
  } while (charin != LineEnd1 && charin != LineEnd2 && inputLength < BufferLength);
  inputBuffer[inputLength] = 0; //  add null terminator
  
  HandleCommand(inputBuffer, inputLength);


}



