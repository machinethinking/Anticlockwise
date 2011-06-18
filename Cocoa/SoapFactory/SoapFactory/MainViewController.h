//
//  MainViewController.h
//  SoapFactory
//
//  Created by Paul Mans on 6/12/11.
//  Copyright 2011 TripAdvisor. All rights reserved.
//

#import "FlipsideViewController.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate> {

    UIButton *brightnessMinusButton;
    UIButton *brightnessPlusButton;
    UIButton *patternMinusButton;
    UIButton *patternPlusButton;
    UIButton *masterPowerButton;
    UISwitch *masterPowerSwitch;
    UIButton *decrementPattern;
}

@property (nonatomic, retain) IBOutlet UIButton *brightnessMinusButton;
@property (nonatomic, retain) IBOutlet UIButton *brightnessPlusButton;
@property (nonatomic, retain) IBOutlet UIButton *patternMinusButton;
@property (nonatomic, retain) IBOutlet UIButton *patternPlusButton;
@property (nonatomic, retain) IBOutlet UIButton *masterPowerButton;


- (IBAction)showInfo:(id)sender;
- (IBAction)decrementBrightness:(id)sender;
- (IBAction)incrementBrightness:(id)sender;
- (IBAction)decrementPattern:(id)sender;
- (IBAction)incrementPattern:(id)sender;


@end
