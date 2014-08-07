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

@interface RDPFTUViewController : UIViewController

// Background image views
@property (weak, nonatomic) IBOutlet UIImageView *clearImageView;
@property (weak, nonatomic) IBOutlet UIImageView *blurredImageView;

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

// The example ending view and button
@property (weak, nonatomic) IBOutlet CSAnimationView *endExampleView;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (weak, nonatomic) IBOutlet UILabel *instructionsLabel;

- (IBAction)startFTU:(id)sender;

- (IBAction)continueFTU:(id)sender;


@end
