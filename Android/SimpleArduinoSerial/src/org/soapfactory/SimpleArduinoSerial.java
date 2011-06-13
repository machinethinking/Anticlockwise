package org.soapfactory;

import re.serialout.AudioSerialOutMono;
import android.app.Activity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;

public class SimpleArduinoSerial extends Activity {
	
	public Button touchMeButton;
	public boolean ledOn = false;
	
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
        
        AudioSerialOutMono.activate();
        
        this.touchMeButton = (Button)this.findViewById(R.id.touch_me_button);
        this.touchMeButton.clearFocus();
        setButtonTitleFromLedOnState();
        
        this.touchMeButton.setOnClickListener(new OnClickListener() {
          @Override
          public void onClick(View v) {
            Log.d("log", "TouchMeButton touched");
            if (!AudioSerialOutMono.isPlaying()) {
            	AudioSerialOutMono.output("_____Toggle____\r");
            	ledOn = !ledOn;
            }
            setButtonTitleFromLedOnState();
          }
        });
        
    }
    
    public void setButtonTitleFromLedOnState() {
    	if (ledOn) {
    		this.touchMeButton.setText("ON");
    	} else {
    		this.touchMeButton.setText("OFF");
    	}
    }
}