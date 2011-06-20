// Namespaces 
namespace java org.anticlockwise.jwall.generated


struct Ack {
       1: optional i32 timestamp;
       2: optional string message;
}

service JWall {
	Ack incrementPatternMode();
	Ack decrementPatternMode();
	Ack incrementBias();
	Ack decrementBias();
	Ack togglePowerState();
}



/*
struct VideoSubscriptionMessage {
	1: required string frame;
}

// Exceptions 
exception GenericException {
  	1: optional i32    errorCode,
  	2: optional string message
}

// Services 
service Robot {
	Ack performTextInstruction(1: required string instruction) throws (1: GenericException e);
	Ack performDirectionInstruction(1: required DirectionInstruction instruction) throws (1: GenericException e);
	Ack updateSubscription(1: required Subscriber subscriber) throws (1: GenericException e);
}

service VideoSubscription {
	Ack receiveVideo(1: required VideoSubscriptionMessage message) throws (1: GenericException e);
}
*/