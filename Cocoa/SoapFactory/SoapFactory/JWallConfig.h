//
//  JWallConfig.h
//  SoapFactory
//
//  Created by Paul Mans on 6/18/11.
//  Copyright 2011 TripAdvisor. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface JWallConfig : NSObject {
    NSString *jWallServerIP;
    NSInteger jWallServerPort;
}

@property (nonatomic, retain) NSString *jWallServerIP;
@property (nonatomic, assign) NSInteger jWallServerPort;



@end
