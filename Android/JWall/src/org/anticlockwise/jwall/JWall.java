package org.anticlockwise.jwall;

import org.anticlockwise.soapfactory.R;
import org.apache.thrift.server.TServer;
import org.apache.thrift.server.TServer.Args;
import org.apache.thrift.server.TSimpleServer;
import org.apache.thrift.transport.TServerSocket;
import org.apache.thrift.transport.TServerTransport;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;

public class JWall extends Activity implements org.anticlockwise.jwall.generated.JWall.Iface {
    
	//public static Robot.Processor<TraceRobot> processor;
	
	private org.anticlockwise.jwall.generated.JWall.Processor<JWall> processor;
	
	/** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
        
        
        processor = new org.anticlockwise.jwall.generated.JWall.Processor<JWall>(this);
	    
        
        // Create the JWall Server thread
		Runnable jwallServer = new Runnable() {
	        public void run() {
	        	 try {
	        		 
	   		      TServerTransport serverTransport = new TServerSocket(9092);
	   		      TServer server = new TSimpleServer(new Args(serverTransport).processor(processor));
	   		      
	   		      // Use this for a multithreaded server                                                                                                                                                                                                
	   		      // TServer server = new TThreadPoolServer(new TThreadPoolServer.Args(serverTransport).processor(processor));                                                                                                                          

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
    
    
    public void incrementPatternMode() throws org.apache.thrift.TException {
    	Log.d("OUTPUT", "incrementPatternMode");
    }

    public void decrementPatternMode() throws org.apache.thrift.TException {
    	Log.d("OUTPUT", "decrementPatternMode");
    }

    public void incrementBias() throws org.apache.thrift.TException {
    	Log.d("OUTPUT", "incrementBias");
    }

    public void decrementBias() throws org.apache.thrift.TException {
    	Log.d("OUTPUT", "decrementBias");
    }

    public void togglePowerState() throws org.apache.thrift.TException {
    	Log.d("OUTPUT", "togglePowerState");
    }
    
    
}