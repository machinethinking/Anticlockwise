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
#include <Firmata.h>

#import "JWall.h"

#define NUM_LEDS 32
#define CEREAL 1

unsigned int Display[NUM_LEDS];  
byte analogPin;
PatternType currPatternType = PatternTypeTopBottomFade;
//PatternType currPatternType = PatternTypeCycle;

unsigned int currColor;

int currRed;
int currGreen;
int currBlue;

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

led_strip strips[4] = { { 0,0,1,0,100,29,0,0,0 },
                       { 0,0,1,1,100,31,0,0,0 },
                       { 0,0,1,2,100,30,0,0,0 },
                       { 0,0,0,0,100,1,0,0,0 }

};

void setup() {
    //if (CEREAL) {
    //}

  // setup/run the fast spi library
   FastSPI_LED.setLeds(NUM_LEDS);
   FastSPI_LED.setChipset(CFastSPI_LED::SPI_595);
   FastSPI_LED.setCPUPercentage(50); 
   FastSPI_LED.init();
   FastSPI_LED.start();

   // Turn all channels off
   setAllChannelsToColor(adjustedColor(0,0,0));
   currColor = adjustedColor(0,0,0);
   int currRed = 0;
   int currGreen = 0;
   int currBlue = 0;
   
   show();

   // setup/run Firmata
   Firmata.setFirmwareVersion(0, 1);
   Firmata.attach(ANALOG_MESSAGE, analogWriteCallback);
   Firmata.begin();
   Serial.begin(9600);
    
}

void loop() {

   while(Firmata.available()) {
      Firmata.processInput();
   }

   Firmata.sendAnalog(0, messageCount);
   
   runPattern(currPatternType);
}

void runPattern(int patternID) {
   switch (patternID) {
      case PatternTypeAnalog:
          setAllChannelsToColor(adjustedColor(currRed, currGreen, currBlue));
          show();
          break;  
      case PatternTypeFade:
         FadeLED(1, 32, 100, 0, 31, 0, 31, 0, 0);
         FadeLED(1, 32, 100, 31, 0, 0, 0, 0, 31);
         FadeLED(1, 32, 100, 0, 0, 31, 0, 31, 0);
         break;
        case PatternTypeCycle:
            channel_cycle();
            break;
        case PatternTypeTopBottomFade:
            TopBottomFade(32, 200, 0, 0, 31, 0, 31, 0, 32, 0, 16, 0, 15, 32);
            break;
   }
}


// ****************************************************************************
// Firmata Control
// ****************************************************************************

void analogWriteCallback(byte pin, int value)
{
   messageCount++;
   //if (pin == 3) {
      //currPatternType = (PatternType)value;      
   //} else if (pin == 2) {
      currRed = value;
   //}


    //pinMode(pin,OUTPUT);
    //analogWrite(pin, value);
}


// ****************************************************************************
// LED Control Functions 
// ****************************************************************************

void show()
{
  // copy data from display into the rgb library's output - we need to expand it back out since 
  // the rgb library expects values from 0-255 (because it's more generically focused).
   unsigned char *pData = FastSPI_LED.getRGBData();
   for(int i=0; i < NUM_LEDS; i++) { 
      int r = (Display[i] & 0x1F) * 8;
      int g = ((Display[i] >> 10) & 0x1F) * 8;
      int b = ((Display[i] >> 5) & 0x1F) * 8;

      *pData++ = r;
      *pData++ = g;
      *pData++ = b;
   }
   FastSPI_LED.show();
}


// Create a 15 bit color value from R,G,B
unsigned int Color(byte r, byte g, byte b)
{
  //Take the lowest 5 bits of each value and append them end to end
   return( ((unsigned int)g & 0x1F )<<10 | ((unsigned int)b & 0x1F)<<5 | (unsigned int)r & 0x1F);
}

unsigned int adjustedColor(byte r, byte g, byte b) {
   return Color(g, b, r);
}

void setAllChannelsToColor(unsigned int color) {
   for (int i = 0; i < NUM_LEDS; i++) {
      Display[i] = color;
   }
}

void FadeLED(int channel, int steps, int fadedelay, int red1, int green1, int blue1, int red2, int green2, int blue2) {

   for (int fadeindex = 0; fadeindex < steps+1; fadeindex++) {

      int newRed = (red1 * (steps - fadeindex) + red2 * fadeindex)/steps;
      int newGreen = (green1 * (steps - fadeindex) + green2 * fadeindex)/steps;
      int newBlue = (blue1 * (steps - fadeindex) + blue2 * fadeindex)/steps;

      unsigned int newColor = adjustedColor(newRed, newGreen, newBlue);

      //Display[channel] = newColor;
      setAllChannelsToColor(newColor);

      show();
      delay(fadedelay);
   }
}


void TopBottomFade(int steps, int fadedelay, int redTop1, int greenTop1, int blueTop1, int redTop2, int greenTop2, int blueTop2, int redBottom1, int greenBottom1, int blueBottom1, int redBottom2, int greenBottom2, int blueBottom2) {

    int numStrips = sizeof(strips)/sizeof(led_strip);
    Serial.println("numStrips: \t");
    Serial.println(numStrips);
    Serial.println("\n");
    for (int fadeindex = 0; fadeindex < steps+1; fadeindex++) {

        int newRedTop = (redTop1 * (steps - fadeindex) + redTop2 * fadeindex)/steps;
        int newGreenTop = (greenTop1 * (steps - fadeindex) + greenTop2 * fadeindex)/steps;
        int newBlueTop = (blueTop1 * (steps - fadeindex) + blueTop2 * fadeindex)/steps;

        int newRedBottom = (redBottom1 * (steps - fadeindex) + redBottom2 * fadeindex)/steps;
        int newGreenBottom = (greenBottom1 * (steps - fadeindex) + greenBottom2 * fadeindex)/steps;
        int newBlueBottom = (blueBottom1 * (steps - fadeindex) + blueBottom2 * fadeindex)/steps;

        unsigned int newColorTop = adjustedColor(newRedTop, newGreenTop, newBlueTop);
        unsigned int newColorBottom = adjustedColor(newRedBottom, newGreenBottom, newBlueBottom);

        //setAllChannelsToColor(newColor);

        //if (CEREAL) {
        //}

        for (int stripindex = 0; stripindex < numStrips ; stripindex++) {
       
            int channel = strips[stripindex].channel;
                Serial.println("channels: ");
                Serial.println(channel);
                Serial.println("\n");
            if (strips[stripindex].location == 1) {
                Display[channel] = newColorTop; 
            } else {
                Display[channel] = newColorBottom;
            }
        }

        show();
        delay(fadedelay);
   }
}

void channel_cycle()
{   

    Serial.begin(9600);
    for(int i=0; i < NUM_LEDS; i++) {
        setAllChannelsToColor(0);
        show();
        unsigned int color = adjustedColor(255,255,255);
        Serial.println(i);
        Display[i] = color;
        show();
        delay(2000);
    }
}

