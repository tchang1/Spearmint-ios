//
//  RDPHomeViewController.h
//  SpearmintIOS
//
//  Created by McElwain, Cori on 7/29/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDPImageFetcher.h"
#import "RDPCounter.h"
#import "RDPViewController.h"
#import "CSAnimationView.h"
#import "RDPCongratulations.h"
#import "RDPSavingSuggestions.h"
#import "RDPTimerManager.h"
#import "RDPCutOutView.h"
#import "RDPUITextField.h"


typedef enum HomeScreenMode {
    OnRecordScreen,
    OnSaveScreen,
    OnProgressView,
} HomeScreenMode;

@interface RDPHomeViewController : RDPViewController <UIScrollViewDelegate>

// The image views that contain the clear and blurred version of
// the image to display to users on the home screen.
@property (weak, nonatomic) IBOutlet UIImageView *clearImageView;
@property (weak, nonatomic) IBOutlet UIImageView *blurredImageView;

// The scroll view that contains all the content except the images
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

// The input field to record why you saved
@property (weak, nonatomic) IBOutlet RDPCutOutView *cutOutView;
@property (weak, nonatomic) IBOutlet RDPUITextField *savingsTextField;

// Press and hold to save view and label
@property (weak, nonatomic) IBOutlet CSAnimationView *pressAndHoldView;
@property (weak, nonatomic) IBOutlet UILabel *pressAndHoldLabel;

// Congratulations view and labels
@property (weak, nonatomic) IBOutlet CSAnimationView *congratsView;
@property (weak, nonatomic) IBOutlet UILabel *congratsLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountKeptLabel;

// Savings suggestion view and label
@property (weak, nonatomic) IBOutlet CSAnimationView *suggestionView;
@property (weak, nonatomic) IBOutlet UILabel *suggestionLabel;

// The settings button view
@property (weak, nonatomic) IBOutlet CSAnimationView *settingsButtonView;

// The counter view
@property (weak, nonatomic) IBOutlet RDPCounter *counterView;

// The gesture recognizer to detect when a user is pressing and holding
// down anywhere on the screen
@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *pressAndHoldGestureRecognizer;

// The image fetcher to get our next image 
@property (strong, nonatomic) RDPImageFetcher *imageFetcher;

// The congratulations message
@property (strong, nonatomic) RDPCongratulations *congratulations;

// The saving suggestion messages
@property (strong, nonatomic) RDPSavingSuggestions *suggestions;
@property (nonatomic, assign) int suggestionIndex;
@property (nonatomic, strong) NSTimer *suggestionTimer;

// Keep track of the view
@property HomeScreenMode screenMode; 

/**
 Fades our the blurred image to reveal the clear image when a user holds the screen
 
 @param recognizer : the gesture recognizer being fired 
 */
- (IBAction)pressAndHold:(UIGestureRecognizer *)recognizer;

@end
