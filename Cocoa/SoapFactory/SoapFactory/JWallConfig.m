//
//  JWallConfig.m
//  SoapFactory
//
//  Created by Paul Mans on 6/18/11.
//  Copyright 2011 TripAdvisor. All rights reserved.
//

#import "JWallConfig.h"


@implementation JWallConfig
@synthesize jWallServerIP;
@synthesize jWallServerPort;

- (id)init {
    if ((self = [super init])) {
        self.jWallServerIP = @"192.168.0.140";
        self.jWallServerPort = 9090;
    }
    return self;
}


@end
