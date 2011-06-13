package org.anticlockwise.jwall;

import org.anticlockwise.soapfactory.R;

import android.app.Activity;
import android.os.Bundle;

public class JWall extends Activity {
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
    }
}