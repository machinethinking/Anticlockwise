// ****************************************************************************
// ****************************************************************************
// JWall_Touch

// Using SPI --> Analog RGB converter 
// http://www.usledsupply.com/shop/rgb-32-spi-dmx-decoder.html

// Pins on Arduino:
//10 --> 1L
//11 --> 1D  Data
//12 --> 1G
//13 --> 1C  Clock

// FastSPI_LED library by Daniel Garcia 
// http://code.google.com/p/fastspi/

// ****************************************************************************
// ****************************************************************************

#include <FastSPI_LED.h>

#import "JWall.h"

#define NUM_LEDS 32
#define CEREAL 1

#define RED 0
#define GREEN 1
#define BLUE 2

unsigned int channels[NUM_LEDS][3];

byte analogPin;

PatternTypes patternType [2] = {
                PatternTypeTopBottomFade,
                PatternTypeFade,
                 };

// test pattern: PatternTypeCycle
//PatternTypes patternType [1] = { PatternTypeFade };
//PatternType currPatternType = PatternTypeTopBottomFade;
//PatternType currPatternType = PatternTypeCycle;

int maxPatternIndex = (sizeof(patternType)/sizeof(PatternTypes)) -1;
int patternTypeIndex = 0;
char currPatternType;
int currRed;
int currGreen;
int currBlue;
float bias [5] = { 0, .25, .50, .75, 1 };
int bias_index = 4;

const int BlackButtonPin = 2;
const int RedButtonPin = 3;
int buttonState = LOW;
int lastButtonState = LOW; 
int reading;
long lastDebounceTime = 0; 
long debounceDelay = 100; 
int messageCount = 0;

typedef struct {
    byte wall;       // left most wall segment (0)
    byte layer;      // first against wall (0) or second layer (1)
    byte location;   // top (1) or bottom (0)
    byte order;      // leftmost (0)
    byte bias;       // percentage (100 normal)
    byte channel;    // channel on LED slave 
    byte red;
    byte green;
    byte blue;
    } led_strip ;

led_strip strips[4] = { { 0,0,1,0,100,3,0,0,0 },
                       { 0,0,1,1,100,2,0,0,0 },
                       { 0,0,1,2,100,5,0,0,0 },
                       { 0,0,0,0,100,6,0,0,0 }
                       };

void setup() {

    // setup/run the fast spi library
    FastSPI_LED.setLeds(NUM_LEDS);
    FastSPI_LED.setChipset(CFastSPI_LED::SPI_595);
    FastSPI_LED.setCPUPercentage(50); 
    FastSPI_LED.init();
    FastSPI_LED.start();

    // Turn all channels off

    setAllChannelsToRGB(0,0,0);

    int currRed = 0;
    int currGreen = 0;
    int currBlue = 0;

    show();

    Serial.begin(9600);
    pinMode(RedButtonPin, INPUT);
     
}

void loop() {

    currPatternType = patternType[patternTypeIndex];
    Serial.println("patternTypeIndex: ");
    Serial.println(patternTypeIndex);
    checkButton();
    runPattern(currPatternType);
    
}

void runPattern(int patternID) {
   switch (patternID) {
      case PatternTypeAnalog:
	  setAllChannelsToRGB(currRed, currGreen, currBlue);
          show();
          break;  
      case PatternTypeFade:
			Serial.println("About to start 1st fade...");
         FadeLED(1, 256, 10, 0, 255, 0, 255, 0, 0);
		Serial.println("About to start 2nd fade");
         FadeLED(1, 256, 10, 255, 0, 0, 0, 0, 255);
		Serial.println("About to start 3rd fade");
         FadeLED(1, 256, 10, 0, 0, 255, 0, 255, 0);
         break;
        case PatternTypeCycle:
            channel_cycle();
            break;
        case PatternTypeTopBottomFade:
            TopBottomFade(256, 200, 0, 0, 0, 0, 0, 255, 0, 0, 0, 0, 255, 0);
            break;
        case PatternTypeColorCycleTest:
            ColorCycleTest();
   }
}


// ****************************************************************************
// LED Control Functions 
// ****************************************************************************

void wdelay(int wdelay)
{
    for (int i=0; i < wdelay ; i++) {
        checkButton();
        delay (1);
    }
}

void show()
{
  // copy data from display into the rgb library's output - we need to expand it back out since 
  // the rgb library expects values from 0-255 (because it's more generically focused).
   unsigned char *pData = FastSPI_LED.getRGBData();

   for(int i=0; i < NUM_LEDS; i++) { 

      *pData++ = channels[i][RED];
      *pData++ = channels[i][GREEN];
      *pData++ = channels[i][BLUE];
   }
   FastSPI_LED.show();
}

void ColorCycleTest() {

}

void setAllChannelsToRGB(unsigned int r, unsigned int g, unsigned int b) {
   for (int i = 0; i < NUM_LEDS; i++) {
     setChannelRGB(i, r, g, b);
   } 
} 

void setChannelRGB(unsigned int cIndex, unsigned int r, unsigned int g, unsigned int b) {
      channels[cIndex][RED] = r;
      channels[cIndex][GREEN] = g;
      channels[cIndex][BLUE] = b;
}

void FadeLED(int channel, int steps, int fadedelay, int red1, int green1, int blue1, int red2, int green2, int blue2) {

   for (int fadeindex = 0; fadeindex < steps+1; fadeindex++) {

      int newRed = (red1 * (steps - fadeindex) + red2 * fadeindex)/steps;
      int newGreen = (green1 * (steps - fadeindex) + green2 * fadeindex)/steps;
      int newBlue = (blue1 * (steps - fadeindex) + blue2 * fadeindex)/steps;

  // setChannelRGB(channel, newRed, newGreen, newBlue);  // Commented out to set all channels instead....
  setAllChannelsToRGB(newRed, newGreen, newBlue);
  

      show();
      wdelay(fadedelay);
   }
}

void checkButton() {
    
    buttonState = digitalRead(RedButtonPin);
    if ((buttonState != lastButtonState) && (millis() - lastDebounceTime) > debounceDelay) {
        lastDebounceTime = millis();
        if (buttonState == HIGH) {    
            Serial.println("button!!");
            patternTypeIndex--;
            currPatternType = patternType[patternTypeIndex];
            Serial.println(currPatternType);
            if (patternTypeIndex < 0 ) {
                patternTypeIndex = maxPatternIndex;
            }
            lastButtonState = buttonState;
            loop();
        } 
    } 
    lastButtonState = buttonState;
}

/*
    //reading = digitalRead(RedButtonPin);
    if (buttonState != lastButtonState) {
        lastDebounceTime = millis();
    } 
    if ((millis() - lastDebounceTime) > debounceDelay) {
        buttonState = reading;
        if (buttonState == HIGH) {    
            Serial.println("button!!");
            patternTypeIndex--;
            currPatternType = patternType[patternTypeIndex];
            Serial.println(currPatternType);
            if (patternTypeIndex < 0 ) {
                patternTypeIndex = maxPatternIndex;
            }
            lastButtonState = reading;
            loop();
        } 
    }
    lastButtonState = reading;
}
*/


void TopBottomFade(int steps, int fadedelay, int redTop1, int greenTop1, int blueTop1, int redTop2, int greenTop2, int blueTop2, int redBottom1, int greenBottom1, int blueBottom1, int redBottom2, int greenBottom2, int blueBottom2) {

    int numStrips = sizeof(strips)/sizeof(led_strip);

    for (int fadeindex = 0; fadeindex < steps+1; fadeindex++) {

        int newRedTop = (redTop1 * (steps - fadeindex) + redTop2 * fadeindex)/steps;
        int newGreenTop = (greenTop1 * (steps - fadeindex) + greenTop2 * fadeindex)/steps;
        int newBlueTop = (blueTop1 * (steps - fadeindex) + blueTop2 * fadeindex)/steps;

        int newRedBottom = (redBottom1 * (steps - fadeindex) + redBottom2 * fadeindex)/steps;
        int newGreenBottom = (greenBottom1 * (steps - fadeindex) + greenBottom2 * fadeindex)/steps;
        int newBlueBottom = (blueBottom1 * (steps - fadeindex) + blueBottom2 * fadeindex)/steps;

        for (int stripindex = 0; stripindex < numStrips ; stripindex++) {
            int channel = strips[stripindex].channel;
            if (strips[stripindex].location == 1) {
	        setChannelRGB(channel, newRedTop, newGreenTop, newBlueTop);
            } else {
	      	setChannelRGB(channel, newRedBottom, newGreenBottom, newBlueBottom);
            }
        }

        checkButton();
        buttonState = digitalRead(BlackButtonPin);
        if (buttonState == HIGH) {    
            //Serial.println("button!!");
            bias_index--;
        } 
        if (bias_index < 0 ) {
            bias_index = 4;
        }

        show();
        wdelay(fadedelay);
        
   }
}

void channel_cycle()
{   

    for(int i=0; i < NUM_LEDS; i++) {
	setAllChannelsToRGB(0, 0, 0);
        show();
	setChannelRGB(i, 255, 255, 255);
        show();
        Serial.println(i);
        wdelay(2000);
    }
}

