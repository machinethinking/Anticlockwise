//
//  Soap_FactoryAppDelegate.h
//  Soap Factory
//
//  Created by Paul Mans on 6/12/11.
//  Copyright 2011 TripAdvisor. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainViewController;

@interface Soap_FactoryAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet MainViewController *mainViewController;

@end
