package org.anticlockwise.jwall;

import org.anticlockwise.jwall.generated.Ack;
import org.anticlockwise.soapfactory.R;
import org.apache.thrift.server.TServer;
import org.apache.thrift.server.TThreadPoolServer;
import org.apache.thrift.transport.TServerSocket;
import org.apache.thrift.transport.TServerTransport;

import android.app.Activity;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.widget.TextView;

import com.phinominal.common.NetworkHelper;

public class JWall extends Activity implements org.anticlockwise.jwall.generated.JWall.Iface {
    
	// UI Members
	private TextView ipTextView;
	private TextView statusTextView;
	
	String currentMessage = "";
	
	private StatusHandler statusHandler = new StatusHandler();
	
	TServer server;
	
	private org.anticlockwise.jwall.generated.JWall.Processor<JWall> processor;
	
	/** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        // Layout
        setContentView(R.layout.main);
        
        ipTextView = (TextView) findViewById(R.id.IP_label);
        ipTextView.setText("IP Addr:  " + NetworkHelper.getLocalIpAddress()); //GetIPs.getAllIpAddress(",   "));
        
        statusTextView = (TextView) findViewById(R.id.status_label);

        
        processor = new org.anticlockwise.jwall.generated.JWall.Processor<JWall>(this);
	    
        
        // Create the JWall Server thread
		Runnable jwallServer = new Runnable() {
	        public void run() {
	        	 try {
	        		 
	   		      TServerTransport serverTransport = new TServerSocket(9090);
	   		      //server = new TSimpleServer(new Args(serverTransport).processor(processor));
	   		      
	   		      // Use this for a multithreaded server                                                                                                                                                                                                
	   		       server = new TThreadPoolServer(new TThreadPoolServer.Args(serverTransport).processor(processor));                                                                                                                          

	   		      Log.d("OUTPUT", "Starting the JWall server...");
	 
	   		      server.serve();
	   		      
	   		    } catch (Exception e) {
	   		      e.printStackTrace();
	   		    }
	        }
	      };
	      
	      // Start the JWall server thread
	      new Thread(jwallServer).start();
    }
    
    
    
    
    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        MenuInflater inflater = getMenuInflater();
        inflater.inflate(R.layout.menu, menu);
        return true;
    }
    
    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle item selection
        switch (item.getItemId()) {
            case R.id.use_timer:
            	getWindow().clearFlags(android.view.WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
                return true;
            case R.id.stay_on:
            	getWindow().addFlags(android.view.WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
                return true;
            default:
                return super.onOptionsItemSelected(item);
        }
    }
    
    public Ack incrementPatternMode() throws org.apache.thrift.TException {
    	Log.d("OUTPUT", "incrementPatternMode");
    	currentMessage = "+ patternMode";
    	statusHandler.sendEmptyMessage(0);
    	
    	
    	Ack myAck = new Ack();
		myAck.message = "My Message";
		return myAck;
    }

    public Ack decrementPatternMode() throws org.apache.thrift.TException {
    	Log.d("OUTPUT", "decrementPatternMode");
    	currentMessage = "- patternMode";
    	statusHandler.sendEmptyMessage(0);
    	
    	
    	Ack myAck = new Ack();
		myAck.message = "My Message";
		return myAck;
    }

    public Ack incrementBias() throws org.apache.thrift.TException {
    	Log.d("OUTPUT", "incrementBias");
    	currentMessage = "+ Bias";
    	statusHandler.sendEmptyMessage(0);
    	
    	
    	Ack myAck = new Ack();
		myAck.message = "My Message";
		return myAck;
    }

    public Ack decrementBias() throws org.apache.thrift.TException {
    	Log.d("OUTPUT", "decrementBias");
    	currentMessage = "- Bias";
    	statusHandler.sendEmptyMessage(0);
    	
    	
    	Ack myAck = new Ack();
		myAck.message = "My Message";
		return myAck;
    }

    public Ack togglePowerState() throws org.apache.thrift.TException {
    	Log.d("OUTPUT", "togglePowerState");
    	currentMessage = "togglePowerState";
    	statusHandler.sendEmptyMessage(0);
    	
    	Ack myAck = new Ack();
		myAck.message = "My Message";
		return myAck;
    }

	class StatusHandler extends Handler {

		@Override
		public void handleMessage(Message msg) {
			super.handleMessage(msg);
			statusTextView.setText(currentMessage);
			}

	  };

    
}