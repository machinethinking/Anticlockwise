//
//  SoapFactoryAppDelegate.h
//  SoapFactory
//
//  Created by Paul Mans on 6/12/11.
//  Copyright 2011 TripAdvisor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSocketClient.h"
#import "TBinaryProtocol.h"
#import "jwall.h"

@class MainViewController;

@interface SoapFactoryAppDelegate : NSObject <UIApplicationDelegate> {
    JWallClient *jwallClient;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet MainViewController *mainViewController;

@property (nonatomic, retain) JWallClient *jwallClient;

@end
