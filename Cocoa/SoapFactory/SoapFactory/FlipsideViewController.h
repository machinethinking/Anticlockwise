//
//  FlipsideViewController.h
//  SoapFactory
//
//  Created by Paul Mans on 6/12/11.
//  Copyright 2011 TripAdvisor. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FlipsideViewControllerDelegate;

@interface FlipsideViewController : UIViewController {

    UITextField *_ipTextField;
    UITextField *_portTextField;
    UIView *_serverSettingsBackgroundView;
}
@property (nonatomic, retain) IBOutlet UITextField *ipTextField;
@property (nonatomic, retain) IBOutlet UITextField *portTextField;
@property (nonatomic, retain) IBOutlet UIView *serverSettingsBackgroundView;

@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end


@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidSave:(FlipsideViewController *)controller;
- (void)flipsideViewControllerDidCancel:(FlipsideViewController *)controller;
@end
