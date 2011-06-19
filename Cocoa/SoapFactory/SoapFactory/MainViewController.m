//
//  MainViewController.m
//  SoapFactory
//
//  Created by Paul Mans on 6/12/11.
//  Copyright 2011 TripAdvisor. All rights reserved.
//

#import "MainViewController.h"
#import "SoapFactoryAppDelegate.h"
#import "jwall.h"
#import "TSocketClient.h"

@interface MainViewController ()

@property (nonatomic, readonly) SoapFactoryAppDelegate *appDelegate;

@end

@implementation MainViewController
@synthesize brightnessMinusButton;
@synthesize brightnessPlusButton;
@synthesize patternMinusButton;
@synthesize patternPlusButton;
@synthesize masterPowerButton;


- (void)dealloc
{
    [brightnessMinusButton release];
    [brightnessPlusButton release];
    [patternMinusButton release];
    [patternPlusButton release];
    [masterPowerSwitch release];
    [masterPowerButton release];
    [super dealloc];
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"JWallClient: %@", self.appDelegate.jWallClient);
    
}


- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)showInfo:(id)sender
{    
    FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
    controller.delegate = self;
    
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:controller animated:YES];
    
    [controller release];
}

- (IBAction)decrementBrightness:(id)sender {
    
    NSLog(@"Stream status:  %d", self.appDelegate.transport.outputStreamStatus);
    
    
    @try {
        Ack *ack = [self.appDelegate.jWallClient testMethod:@"message from cocoa app"];
        NSLog(@"Ack message:  %@", ack.message);
        //[self.appDelegate.jWallClient decrementBias];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception:  %@", exception);
    }
}

- (IBAction)incrementBrightness:(id)sender {
    @try {
        [self.appDelegate.jWallClient incrementBias];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception:  %@", exception);
    }
}

- (IBAction)decrementPattern:(id)sender {
    @try {
        [self.appDelegate.jWallClient decrementPatternMode];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception:  %@", exception);
    }
}

- (IBAction)incrementPattern:(id)sender {
    @try {
        [self.appDelegate.jWallClient incrementPatternMode];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception:  %@", exception);
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload
{
    [self setBrightnessMinusButton:nil];
    [self setBrightnessPlusButton:nil];
    [self setPatternMinusButton:nil];
    [self setPatternPlusButton:nil];
    [self setMasterPowerButton:nil];
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (SoapFactoryAppDelegate *)appDelegate {
    return [SoapFactoryAppDelegate instance];
}

@end
