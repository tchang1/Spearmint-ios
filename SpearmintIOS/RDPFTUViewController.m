//
//  RDPFTUViewController.m
//  SpearmintIOS
//
//  Created by McElwain, Cori on 8/6/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPFTUViewController.h"
#import "RDPImageBlur.h"
#import "RDPStrings.h"
#import "RDPAnalyticsModule.h"
#import "RDPTimerManager.h"
#import "RDPUserService.h"

#define kStoryboard @"Main"
#define kSetGoal @"setGoal"
#define kHome @"home"

#define IS_TALL_SCREEN ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define kScreenHeight  [UIScreen mainScreen].bounds.size.height
#define kCircleShiftTallScreen 100
#define kCircleShiftShortScreen 150

#define kFirstExampleImage @"ireland.png"
#define kSecondExampleImage @"ridge.png"

#define kMinimumPressDuration 0.1

#define kMaxAmountFirstExample 3
#define kMaxAmountSecondExample 8

#define kFirstExampleSpeed 1
#define kSecondExampleSpeed 1.5
#define kTestingSpeed 10

#define kFadeLabelsTime 0.75
#define kFadeImagesTime 0.75

#define kImageTransitionTime 2.5f

#define kReleaseMessageUpdateBlockName     @"releaseMessageUpdateBlock"

@interface RDPFTUViewController ()

@end

@implementation RDPFTUViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self removePersistentBackgroundImage];
    //
    CGRect newFrame = self.keepLogo.frame;
    newFrame.origin.y = (kScreenHeight - self.keepLogo.frame.size.height)/2;
    self.keepLogo.frame = newFrame;
    
    // Initialize the minimum press duration to be short so it seems more responsive
    self.pressAndHoldGestureRecognizer.minimumPressDuration = kMinimumPressDuration;
    
    // Initialize the background images
    UIImage *image = [UIImage imageNamed:kFirstExampleImage];
    self.clearImageView = [[UIImageView alloc] initWithImage:image];
    self.blurredImageView = [[UIImageView alloc] initWithImage:[RDPImageBlur applyBlurOnFTUImage:image]];
    
    [self setPersistentBackgroundImageViewLower:self.clearImageView];
    self.clearImageView.frame = CGRectMake(self.navigationController.view.frame.origin.x,
                                 self.navigationController.view.frame.origin.y,
                                 self.navigationController.view.frame.size.width,
                                 self.navigationController.view.frame.size.height);
    self.clearImageView.contentMode = UIViewContentModeScaleToFill;
    
    [self setPersistentBackgroundImageView:self.blurredImageView];
    self.blurredImageView.frame = CGRectMake(self.navigationController.view.frame.origin.x,
                                           self.navigationController.view.frame.origin.y,
                                           self.navigationController.view.frame.size.width,
                                           self.navigationController.view.frame.size.height);
    self.blurredImageView.contentMode = UIViewContentModeScaleToFill;
    
    // Hide everything except the welcome view
    self.startExampleView.hidden = YES;
    self.counterAndTextView.hidden = YES;
    self.keepHoldingView.hidden = YES;
    self.endExampleView.hidden = YES;
    self.releaseScreenView.hidden = YES;
    self.welcomeView.hidden=YES;
    self.loadingLabel.hidden=YES;
    
    
    // Set the text for the labels to be the first example
    self.keepSlogan.text = [RDPStrings stringForID:sSlogan];
    self.tapAndHoldLabel.text = [RDPStrings stringForID:sPressAndHoldOnly];
    self.toKeepLabel.text = [RDPStrings stringForID:sCoffeeTapAndHold];
    self.savingsExampleLabel.text = [RDPStrings stringForID:sCoffeeExampleHeader];
    self.counterLabel.text = [RDPStrings stringForID:sCoffeeCounterLabel];
    self.keepHoldingLabel.text = [RDPStrings stringForID:sKeepHolding];
    self.instructionsLabel.text = [RDPStrings stringForID:sAddToGoalInstructions];
    self.releaseScreenLabel.text = [RDPStrings stringForID:sReleaseMessage1];
    self.loadingLabel.text= [RDPStrings stringForID:sLoading];
    [self.continueButton setTitle:[RDPStrings stringForID:sContinue] forState:UIControlStateNormal];
    
    // Disable the gesture recognizer at first
    self.pressAndHoldGestureRecognizer.enabled = NO;
    
    // Set the bools to keep track of the state of the FTU
    self.onLastExmaple = NO;
    self.hasSeenKeepHoldingOnce = NO;
    self.hasReachedTargetAmount = NO;
    
    // Set the max value for the first example to 3
    self.counterView.maxValue = kMaxAmountFirstExample;
    //self.counterView.rotationsPerSecond = kTestingSpeed;
    self.counterView.rotationsPerSecond = kFirstExampleSpeed;
}

-(void)viewWillAppear:(BOOL)animated
{
   
}

-(void)viewDidAppear:(BOOL)animated
{
    //Check if logged in
    NSArray *cookies=[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    if ([cookies count]>0)
    {
        self.loadingLabel.hidden=YES;
        //Assume logged in, try the cookie.
        [RDPUserService loginWithCookie:^(RDPUser *user) {
            
            [RDPAnalyticsModule track:@"Logged in with existing" properties:@{@"username" : [user getUsername] } ];
            [RDPAnalyticsModule identifyProfile];
            [RDPAnalyticsModule setProfile:@{@"$email" : [user getUsername]}];
            
            //Login successful, animate to home view
            [UIView animateWithDuration:0.5
                             animations:^{
                                 self.keepLogo.layer.opacity = 0;
                                 self.loadingLabel.layer.opacity=0;
                             }
                             completion:^(BOOL finished) {
                                 UIViewController *viewController =
                                 [[UIStoryboard storyboardWithName:kStoryboard
                                                            bundle:NULL] instantiateViewControllerWithIdentifier:kHome];
                                 CATransition *transition = [CATransition animation];
                                 transition.duration = 0.5f;
                                 transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                                 transition.type = kCATransitionFade;
                                 [self.navigationController.view.layer addAnimation:transition forKey:nil];
                                 [self.navigationController pushViewController:viewController animated:NO];
                             }];

            
                    } failure:^(RDPResponseCode code) {
                        ////*NSLog(@"autologin failed");
                        self.loadingLabel.hidden = YES;
                        [RDPAnalyticsModule track:@"Error with existing login"];

                        CGRect newFrame = self.keepLogo.frame;
                        if IS_TALL_SCREEN {
                            newFrame.origin.y -= kCircleShiftTallScreen;
                        }
                        else {
                            newFrame.origin.y -= kCircleShiftShortScreen;
                        }
                        
                        [UIView animateWithDuration:1.0
                                         animations:^{
                                             self.keepLogo.frame = newFrame;
                                         }
                                         completion:^(BOOL finished) {
                                             self.welcomeView.hidden=NO;
                                             self.welcomeView.duration = kFadeLabelsTime;
                                             self.welcomeView.type     = CSAnimationTypeFadeIn;
                                             [self.welcomeView startCanvasAnimation];
                                         }];
        }];

    }
    //not logged in, show welcome FTU
    else {
        CGRect newFrame = self.keepLogo.frame;
        if IS_TALL_SCREEN {
            newFrame.origin.y -= kCircleShiftTallScreen;
        }
        else {
            newFrame.origin.y -= kCircleShiftShortScreen;
        }
            
        self.loadingLabel.hidden = YES;
        
        [UIView animateWithDuration:1.0
                         animations:^{
                             self.keepLogo.frame = newFrame;
                         }
                         completion:^(BOOL finished) {
                                self.welcomeView.hidden=NO;
                                self.welcomeView.duration = kFadeLabelsTime;
                                self.welcomeView.type     = CSAnimationTypeFadeIn;
                                [self.welcomeView startCanvasAnimation];
                            }];
    }
   
}
-(void)viewDidDisappear:(BOOL)animated
{
    self.view.hidden = NO;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)showReleaseMessage
{
    if (!self.onLastExmaple) {
        if ([self.counterView.currencyValue intValue] == kMaxAmountFirstExample) {
            self.releaseScreenView.hidden = NO;
            self.releaseScreenView.duration = kFadeLabelsTime;
            self.releaseScreenView.type = CSAnimationTypeFadeIn;
            [self.releaseScreenView startCanvasAnimation];
            
            [RDPTimerManager clearUpdateBlockWithName:kReleaseMessageUpdateBlockName];
        }
    } else {// we are on the last example
        if ([self.counterView.currencyValue intValue] == (kMaxAmountSecondExample-3)) {
            self.releaseScreenView.hidden = NO;
            self.releaseScreenView.duration = kFadeLabelsTime;
            self.releaseScreenView.type = CSAnimationTypeFadeIn;
            [self.releaseScreenView startCanvasAnimation];
            
            [RDPTimerManager clearUpdateBlockWithName:kReleaseMessageUpdateBlockName];
        }
    }
}

- (IBAction)startFTU:(id)sender
{
    [RDPAnalyticsModule track:@"FTU Started"];
    
    //Reposition frame based on welcomeView before adding as a subview prior to fadeout.
    CGRect newFrame = self.keepLogo.frame;
    newFrame.origin.y -= self.welcomeView.frame.origin.y;
    self.keepLogo.frame=newFrame;
    [self.welcomeView insertSubview:self.keepLogo atIndex:0];
    
    // Fade out the welcome screen
    self.welcomeView.duration = kFadeLabelsTime;
    self.welcomeView.type     = CSAnimationTypeFadeOut;
    [self.welcomeView startCanvasAnimation];
    
    // Fade in the first FTU screen
    self.startExampleView.hidden = NO;
    self.startExampleView.duration = kFadeLabelsTime;
    self.startExampleView.type = CSAnimationTypeFadeIn;
    self.startExampleView.delay = 1.0;
    [self.startExampleView startCanvasAnimation];
    
    // Enable the gesture recognizer
    self.pressAndHoldGestureRecognizer.enabled = YES;
    
    [RDPTimerManager registerUpdateBlock:^(NSInteger milliseconds){
        [self showReleaseMessage];
    }
                                withName:kReleaseMessageUpdateBlockName];
}

- (IBAction)continueFTU:(id)sender
{
    if (self.onLastExmaple) {
        [self setAGoalTapped];
        return;
    }
    
    [self.counterView reset];
    
    // Fade out the first FTU screen
    self.endExampleView.hidden = NO;
    self.endExampleView.duration = kFadeLabelsTime;
    self.endExampleView.type = CSAnimationTypeFadeOut;
    [self.endExampleView startCanvasAnimation];
    
    // Adjust the bools to keep track of where we are in the FTU
    self.hasSeenKeepHoldingOnce = NO;
    self.hasReachedTargetAmount = NO;
    self.onLastExmaple = YES;
    
    // Set the max value for the first example to 8
    self.counterView.maxValue = kMaxAmountSecondExample;
    //self.counterView.rotationsPerSecond = kTestingSpeed;
    self.counterView.rotationsPerSecond = kSecondExampleSpeed;
    
    // Change all the labels
    self.tapAndHoldLabel.text = [RDPStrings stringForID:sPressAndHoldOnly];
    self.toKeepLabel.text = [RDPStrings stringForID:sBusTapAndHold];
    self.savingsExampleLabel.text = [RDPStrings stringForID:sBusExmapleHeader];
    self.counterLabel.text = [RDPStrings stringForID:sBusCounterLabel];
    self.keepHoldingLabel.text = [RDPStrings stringForID:sKeepHolding];
    self.releaseScreenLabel.text = [RDPStrings stringForID:sReleaseMessage2];
    
    self.startExampleView.hidden = NO;
    self.startExampleView.duration = kFadeLabelsTime;
    self.startExampleView.delay = 2;
    self.startExampleView.type     = CSAnimationTypeFadeIn;
    [self.startExampleView startCanvasAnimation];
    
    // Slowly transition to the next blurred image
    UIImage *image = [UIImage imageNamed:kSecondExampleImage];
    self.clearImageView.image = image;
    UIImage *toImage = [RDPImageBlur applyBlurOnFTUImage:image];
    [UIView transitionWithView:self.blurredImageView
                      duration:kImageTransitionTime
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.blurredImageView.image = toImage;
                    } completion:^(BOOL finished){
                        
                        // Change the instructions label
                        self.instructionsLabel.text = [RDPStrings stringForID:sUseKeepInstructions];
                        [self.continueButton setTitle:[RDPStrings stringForID:sSetAGoal] forState:UIControlStateNormal];
                        
                        self.pressAndHoldGestureRecognizer.enabled = YES;
                    }];
    
    [RDPTimerManager registerUpdateBlock:^(NSInteger milliseconds){
        [self showReleaseMessage];
    }
                                withName:kReleaseMessageUpdateBlockName];
}

- (IBAction)pressAndHold:(UIGestureRecognizer *)recognizer
{
    switch (recognizer.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            [UIView animateWithDuration:kFadeImagesTime animations:^{
                
                self.blurredImageView.alpha = 0.0;
                
            }];
            self.counterAndTextView.hidden = NO;
            [self.counterView start];
            
            self.startExampleView.hidden = YES;
            self.keepHoldingView.hidden = YES;
        }
            break;
            
        case UIGestureRecognizerStateChanged:
        {
            self.blurredImageView.alpha = 0.0;
        }
            break;
            
        case UIGestureRecognizerStateEnded:
        {
            NSNumber *amountSaved = self.counterView.currencyValue;
            
            if (!self.onLastExmaple) {
                self.hasReachedTargetAmount = [amountSaved isEqualToNumber:[NSNumber numberWithInt:kMaxAmountFirstExample]];
            }
            else {
                self.hasReachedTargetAmount = [amountSaved isEqualToNumber:[NSNumber numberWithInt:kMaxAmountSecondExample]];
            }
            
            if (!self.hasReachedTargetAmount) {
                // Update the label if they have already seen the keep holding message once
                if (self.hasSeenKeepHoldingOnce) {
                    if (self.onLastExmaple) {
                        self.keepHoldingLabel.text = [RDPStrings stringForID:sKeepHolding8];
                    }
                    else {
                        self.keepHoldingLabel.text = [RDPStrings stringForID:sKeepHolding3];
                    }
                }
                
                self.keepHoldingView.hidden = NO;
                self.keepHoldingView.duration = kFadeLabelsTime;
                self.keepHoldingView.type     = CSAnimationTypeFadeIn;
                [self.keepHoldingView startCanvasAnimation];
                
                self.hasSeenKeepHoldingOnce = YES;
            } else {
                self.endExampleView.hidden = NO;
                self.endExampleView.duration = kFadeLabelsTime;
                self.endExampleView.type     = CSAnimationTypeFadeIn;
                [self.endExampleView startCanvasAnimation];
            }
            
            // disable the gesture recognizer while animations and transitions occur
            self.pressAndHoldGestureRecognizer.enabled = NO;
            
            [self.counterView stop];
            self.counterAndTextView.hidden = YES;
            
            self.releaseScreenView.hidden = YES; 
            
            [UIView animateWithDuration:kFadeImagesTime animations:^{
                
                self.blurredImageView.alpha = 1.0;
            }
                             completion:^(BOOL finished){
                                 if (!self.hasReachedTargetAmount) {
                                     self.pressAndHoldGestureRecognizer.enabled = YES;
                                 }
                             }];
        }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        default:
            break;
    }
}

-(void)setAGoalTapped
{
    [RDPAnalyticsModule track:@"Set a goal tapped"];
    UIViewController *viewController =
    [[UIStoryboard storyboardWithName:kStoryboard
                               bundle:NULL] instantiateViewControllerWithIdentifier:kSetGoal];
    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}



@end


