//
//  FlipsideViewController.m
//  SoapFactory
//
//  Created by Paul Mans on 6/12/11.
//  Copyright 2011 TripAdvisor. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "FlipsideViewController.h"
#import "SoapFactoryAppDelegate.h"
#import "JWallConfig.h"

@interface FlipsideViewController ()

@property (nonatomic, readonly) SoapFactoryAppDelegate *appDelegate;

@end

@implementation FlipsideViewController

@synthesize ipTextField = _ipTextField;
@synthesize portTextField = _portTextField;
@synthesize serverSettingsBackgroundView = _serverSettingsBackgroundView;
@synthesize delegate=_delegate;

- (void)dealloc
{
    [_ipTextField release];
    [_portTextField release];
    [_serverSettingsBackgroundView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor]; 
    
    self.ipTextField.text = self.appDelegate.jWallConfig.jWallServerIP;
    self.portTextField.text = [NSString stringWithFormat:@"%d", self.appDelegate.jWallConfig.jWallServerPort];
    
    self.serverSettingsBackgroundView.layer.cornerRadius = 6;
}

- (void)viewDidUnload
{
    [self setIpTextField:nil];
    [self setPortTextField:nil];
    [self setServerSettingsBackgroundView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Actions

- (IBAction)cancel:(id)sender
{
    [self.delegate flipsideViewControllerDidCancel:self];
}

- (IBAction)save:(id)sender {
    [self.delegate flipsideViewControllerDidSave:self];
}

- (SoapFactoryAppDelegate *)appDelegate {
    return [SoapFactoryAppDelegate instance];
}


@end
