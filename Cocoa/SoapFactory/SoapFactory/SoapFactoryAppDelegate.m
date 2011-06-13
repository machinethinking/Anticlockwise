//
//  SoapFactoryAppDelegate.m
//  SoapFactory
//
//  Created by Paul Mans on 6/12/11.
//  Copyright 2011 TripAdvisor. All rights reserved.
//

#import "SoapFactoryAppDelegate.h"
#import "MainViewController.h"

@implementation SoapFactoryAppDelegate


@synthesize window=_window;

@synthesize mainViewController=_mainViewController;

@synthesize jwallClient;

- (void)dealloc
{
    [_window release];
    [_mainViewController release];
    [jwallClient release];
    [super dealloc];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // Add the main view controller's view to the window and display.
    self.window.rootViewController = self.mainViewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    self.jwallClient = nil;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (JWallClient *)jwallClient {
    if (!jwallClient) {
        TSocketClient *transport = [[[TSocketClient alloc] initWithHostname:/*@"192.168.1.122"*/ @"10.0.2.7" /*   @"192.168.0.104" */
                                                                      port:9092] autorelease];
        TBinaryProtocol *protocol = [[[TBinaryProtocol alloc] initWithTransport:transport 
                                                                    strictRead:YES 
                                                                   strictWrite:YES] autorelease];
        
        // Use the service defined in profile.thrift
        jwallClient = [[JWallClient alloc] initWithProtocol:protocol];
    }
    return jwallClient;
}

@end
