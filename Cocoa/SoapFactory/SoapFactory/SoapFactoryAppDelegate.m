//
//  SoapFactoryAppDelegate.m
//  SoapFactory
//
//  Created by Paul Mans on 6/12/11.
//  Copyright 2011 TripAdvisor. All rights reserved.
//

#import "SoapFactoryAppDelegate.h"
#import "MainViewController.h"
#import "JWallConfig.h"

@implementation SoapFactoryAppDelegate
@synthesize transport;

@synthesize window=_window;

@synthesize mainViewController=_mainViewController;

@synthesize jWallClient;
@synthesize jWallConfig;

+ (SoapFactoryAppDelegate *)instance {
    return (SoapFactoryAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)dealloc
{
    [_window release];
    [_mainViewController release];
    [jWallClient release];
    [jWallConfig release];
    [transport release];
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
    self.jWallClient = nil;
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

- (JWallClient *)jWallClient {
    if (!jWallClient) {
        self.jWallConfig = [[[JWallConfig alloc] init] autorelease];
        self.transport = [[[TSocketClient alloc] initWithHostname:self.jWallConfig.jWallServerIP 
                                                                      port:self.jWallConfig.jWallServerPort] autorelease];
        TBinaryProtocol *protocol = [[[TBinaryProtocol alloc] initWithTransport:transport 
                                                                    strictRead:YES 
                                                                   strictWrite:YES] autorelease];
        
        // Use the service defined in profile.thrift
        jWallClient = [[JWallClient alloc] initWithProtocol:protocol];
        
        NSLog(@"Stream status:  %d", self.transport.outputStreamStatus);
        
    }
    return jWallClient;
}

@end
