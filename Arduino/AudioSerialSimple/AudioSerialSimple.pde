
#define MY_SERIAL_SPEED 4800 // arduino 2009: 4800 or lower!
#define DEBUG_SERIAL_SPEED 4800 // arduino 2009: 4800 or lower!
#define BUFFER_LENGTH 16
#define LINE_END_1 13
#define LINE_END_2 10
#define LED_PIN 13


#define STRING_PADDING_CHARACTER '1'
#define TOGGLE_STRING "Toggle"

#define DEBUG_OUT_TRUE 

#include <NewSoftSerial.h>

NewSoftSerial mySerial(2, 255); // rx only

char charin = 80;
char inputBuffer[BUFFER_LENGTH];
int inputLength = 0;

int ledOn = 0;

void setup()
{
  pinMode(LED_PIN, OUTPUT);
    
  mySerial.begin(MY_SERIAL_SPEED); 

#ifdef DEBUG_OUT_TRUE
  Serial.begin(DEBUG_SERIAL_SPEED);
#endif

  digitalWrite(LED_PIN, LOW);
}

void loop()
{ 
  readSerial();  // Note, program flow will not execute past this point until LINE_END chars are read over Serial or BUFFER_LENGTH is reached
  
  HandleCommand(inputBuffer, inputLength);  

  	if (ledOn == 0) {
		digitalWrite(LED_PIN, LOW);
	} else {
		digitalWrite(LED_PIN, HIGH);
	}
}

/*
 * If input string is recognized performs command, in this case toggling LED 
 */
void HandleCommand(char* input, int length)
{

	char *trimmedString = trimchar(input, STRING_PADDING_CHARACTER);
	
	#ifdef DEBUG_OUT_TRUE
		Serial.println(trimmedString);
	#endif
	
	if (strcmp(trimmedString, TOGGLE_STRING) == 0) {
		if (ledOn) {
			ledOn = 0;
		} else {
			ledOn = 1;
		}
	}
}

/*
 * Waits for Serial until available and then reads it into inputBuffer
 */
void readSerial() {
	// get a command string form the mySerial port
	inputLength = 0;

	do {
	  while (!mySerial.available()){
	      delay(15);
	  }; 

	  // wait for input 
	  {
	    charin = mySerial.read(); // read it in

	    if (charin > 31 && charin < 128) {
	      inputBuffer[inputLength]=charin;
	      inputLength++;
	    }

	  }
	} while (charin != LINE_END_1 && charin != LINE_END_2 && inputLength < BUFFER_LENGTH);
	inputBuffer[inputLength] = 0; //  add null terminator
}

/*
 * Trims specified character from front and back of specified string 
 */
char *trimchar(char *str, char chartotrim)
{
  char *end;

  // Trim leading space
  while(*str == chartotrim) str++;

  if(*str == 0)  // All spaces?
    return str;

  // Trim trailing space
  end = str + strlen(str) - 1;
  while(end > str && *end == chartotrim) end--;

  // Write new null terminator
  *(end+1) = 0;

  return str;
}



