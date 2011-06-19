package org.anticlockwise.jwall;

import org.anticlockwise.jwall.generated.Ack;
import org.anticlockwise.soapfactory.R;
import org.apache.thrift.TException;
import org.apache.thrift.protocol.TBinaryProtocol;
import org.apache.thrift.protocol.TProtocol;
import org.apache.thrift.server.TServer;
import org.apache.thrift.server.TServer.Args;
import org.apache.thrift.server.TSimpleServer;
import org.apache.thrift.transport.TServerSocket;
import org.apache.thrift.transport.TServerTransport;
import org.apache.thrift.transport.TSocket;
import org.apache.thrift.transport.TTransport;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;
import android.widget.TextView;

import com.phinominal.common.NetworkHelper;
import com.re.anywhere.client.GetIPs;

public class JWall extends Activity implements org.anticlockwise.jwall.generated.JWall.Iface {
    
	// UI Members
	private TextView ipTextView;
	private TextView statusTextView;
	
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
	   		      server = new TSimpleServer(new Args(serverTransport).processor(processor));
	   		      
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
    	//statusTextView.setText("+ patternMode");
    }

    public void decrementPatternMode() throws org.apache.thrift.TException {
    	Log.d("OUTPUT", "decrementPatternMode");
    	//statusTextView.setText("- patternMode");
    }

    public void incrementBias() throws org.apache.thrift.TException {
    	Log.d("OUTPUT", "incrementBias");
    	//statusTextView.setText("+ bias");
    }

    public void decrementBias() throws org.apache.thrift.TException {
    	Log.d("OUTPUT", "decrementBias");
    	//statusTextView.setText("- bias");
    }

    public void togglePowerState() throws org.apache.thrift.TException {
    	Log.d("OUTPUT", "togglePowerState");
    	//statusTextView.setText("power toggled");
    }

	@Override
	public Ack testMethod(String message) throws TException {
		Ack myAck = new Ack();
		myAck.message = "My Message";
		
		Log.d("OUTPUT", "testMethod");
    	//statusTextView.setText("message");
    	
		return myAck;
	}
    
    
}