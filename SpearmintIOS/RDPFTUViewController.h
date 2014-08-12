//
//  RDPFTUViewController.h
//  SpearmintIOS
//
//  Created by McElwain, Cori on 8/6/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSAnimationView.h"
#import "RDPCounter.h"
#import "RDPViewController.h"

@interface RDPFTUViewController : RDPViewController <UINavigationControllerDelegate>

// Keep track of the example we are on and if the user has seen "keep holding"
@property (nonatomic, assign) BOOL onLastExmaple;
@property (nonatomic, assign) BOOL hasSeenKeepHoldingOnce;
@property (nonatomic, assign) BOOL hasReachedTargetAmount; 

// Background image views
@property (strong, nonatomic) UIImageView *clearImageView;
@property (strong, nonatomic) UIImageView *blurredImageView;

// The views, labels and buttons for the welcome screen
@property (weak, nonatomic) IBOutlet CSAnimationView *welcomeView;
@property (weak, nonatomic) IBOutlet UILabel *keepSlogan;
@property (weak, nonatomic) IBOutlet UIButton *startFTUButton;
@property (weak, nonatomic) IBOutlet UIButton *goToLoginButton; 

// The example starting view and labels
@property (weak, nonatomic) IBOutlet CSAnimationView *startExampleView;
@property (weak, nonatomic) IBOutlet UILabel *tapAndHoldLabel;
@property (weak, nonatomic) IBOutlet UILabel *savingsExampleLabel;

// Counter and text
@property (weak, nonatomic) IBOutlet CSAnimationView *counterAndTextView;
@property (weak, nonatomic) IBOutlet RDPCounter *counterView;
@property (weak, nonatomic) IBOutlet UILabel *counterLabel;

// Keep holding view and label
@property (weak, nonatomic) IBOutlet CSAnimationView *keepHoldingView;
@property (weak, nonatomic) IBOutlet UILabel *keepHoldingLabel;

// The example ending view and button
@property (weak, nonatomic) IBOutlet CSAnimationView *endExampleView;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (weak, nonatomic) IBOutlet UILabel *instructionsLabel;

// The gesture recognizer
@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *pressAndHoldGestureRecognizer;

- (IBAction)startFTU:(id)sender;

- (IBAction)continueFTU:(id)sender;

- (IBAction)pressAndHold:(UIGestureRecognizer *)recognizer;


@end
