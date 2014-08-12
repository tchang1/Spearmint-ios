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
#import "RDPPushAnimation.h"

#define kStoryboard @"Main"
#define kSetGoal @"setGoal"

@interface RDPFTUViewController ()

@end

@implementation RDPFTUViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Make this view the delegate for the navigation controller
    self.navigationController.delegate = self;
    
    // Initialize the background images
    UIImage *image = [UIImage imageNamed:@"ireland.png"];
    self.clearImageView = [[UIImageView alloc] initWithImage:image];
    self.blurredImageView = [[UIImageView alloc] initWithImage:[RDPImageBlur applyBlurOnFTUImage:image]];
    
    [self.navigationController.view insertSubview:self.clearImageView atIndex:0];
    self.clearImageView.frame = CGRectMake(self.navigationController.view.frame.origin.x,
                                 self.navigationController.view.frame.origin.y,
                                 self.navigationController.view.frame.size.width,
                                 self.navigationController.view.frame.size.height);
    self.clearImageView.contentMode = UIViewContentModeScaleToFill;
    
    [self.navigationController.view insertSubview:self.blurredImageView atIndex:1];
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
    
    // Set the text for the labels to be the first example
    self.keepSlogan.text = [RDPStrings stringForID:sSlogan];
    self.tapAndHoldLabel.text = [RDPStrings stringForID:sCoffeeTapAndHold];
    self.savingsExampleLabel.text = [RDPStrings stringForID:sCoffeeExampleHeader];
    self.counterLabel.text = [RDPStrings stringForID:sCoffeeCounterLabel];
    self.keepHoldingLabel.text = [RDPStrings stringForID:sKeepHolding];
    self.instructionsLabel.text = [RDPStrings stringForID:sAddToGoalInstructions];
    [self.continueButton setTitle:[RDPStrings stringForID:sContinue] forState:UIControlStateNormal];
    
    // Disable the gesture recognizer at first
    self.pressAndHoldGestureRecognizer.enabled = NO;
    
    // Set the bools to keep track of the state of the FTU
    self.onLastExmaple = NO;
    self.hasSeenKeepHoldingOnce = NO;
    self.hasReachedTargetAmount = NO;
    
    // Set the max value for the first example to 3
    self.counterView.maxValue = 3;
    self.counterView.rotationsPerSecond = 10; // TODO: remove me
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

- (IBAction)startFTU:(id)sender
{
    // Fade out the welcome screen
    self.welcomeView.duration = 0.75;
    self.welcomeView.type     = CSAnimationTypeFadeOut;
    [self.welcomeView startCanvasAnimation];
    
    // Fade in the first FTU screen
    self.startExampleView.hidden = NO;
    self.startExampleView.duration = 0.75;
    self.startExampleView.type = CSAnimationTypeFadeIn;
    self.startExampleView.delay = 1.0;
    [self.startExampleView startCanvasAnimation];
    
    // Enable the gesture recognizer
    self.pressAndHoldGestureRecognizer.enabled = YES;
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
    self.endExampleView.duration = 0.75;
    self.endExampleView.type = CSAnimationTypeFadeOut;
    [self.endExampleView startCanvasAnimation];
    
    // Adjust the bools to keep track of where we are in the FTU
    self.hasSeenKeepHoldingOnce = NO;
    self.hasReachedTargetAmount = NO;
    self.onLastExmaple = YES;
    
    // Set the max value for the first example to 8
    self.counterView.maxValue = 8;
    //self.counterView.rotationsPerSecond = 1.5;
    
    // Change all the labels
    self.tapAndHoldLabel.text = [RDPStrings stringForID:sBusTapAndHold];
    self.savingsExampleLabel.text = [RDPStrings stringForID:sBusExmapleHeader];
    self.counterLabel.text = [RDPStrings stringForID:sBusCounterLabel];
    self.keepHoldingLabel.text = [RDPStrings stringForID:sKeepHolding];
    
    self.startExampleView.hidden = NO;
    self.startExampleView.duration = 0.75;
    self.startExampleView.delay = 2;
    self.startExampleView.type     = CSAnimationTypeFadeIn;
    [self.startExampleView startCanvasAnimation];
    
    // Slowly transition to the next blurred image
    UIImage *image = [UIImage imageNamed:@"ridge.png"];
    self.clearImageView.image = image;
    UIImage *toImage = [RDPImageBlur applyBlurOnFTUImage:image];
    [UIView transitionWithView:self.blurredImageView
                      duration:2.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.blurredImageView.image = toImage;
                    } completion:^(BOOL finished){
                        
                        // Change the instructions label
                        self.instructionsLabel.text = [RDPStrings stringForID:sUseKeepInstructions];
                        [self.continueButton setTitle:[RDPStrings stringForID:sSetAGoal] forState:UIControlStateNormal];
                        
                        self.pressAndHoldGestureRecognizer.enabled = YES;
                    }];
}

- (IBAction)pressAndHold:(UIGestureRecognizer *)recognizer
{
    switch (recognizer.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            [UIView animateWithDuration:0.75 animations:^{
                
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
                self.hasReachedTargetAmount = [amountSaved isEqualToNumber:[NSNumber numberWithInt:3]];
            }
            else {
                self.hasReachedTargetAmount = [amountSaved isEqualToNumber:[NSNumber numberWithInt:8]];
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
                self.keepHoldingView.duration = 0.75;
                self.keepHoldingView.type     = CSAnimationTypeFadeIn;
                [self.keepHoldingView startCanvasAnimation];
                
                self.hasSeenKeepHoldingOnce = YES;
            } else {
                self.endExampleView.hidden = NO;
                self.endExampleView.duration = 0.75;
                self.endExampleView.type     = CSAnimationTypeFadeIn;
                [self.endExampleView startCanvasAnimation];
            }
            
            // disable the gesture recognizer while animations and transitions occur
            self.pressAndHoldGestureRecognizer.enabled = NO;
            
            [self.counterView stop];
            self.counterAndTextView.hidden = YES;
            
            [UIView animateWithDuration:0.75 animations:^{
                
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

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    
    RDPPushAnimation* pushAnimation = [RDPPushAnimation new];
    pushAnimation.navigationControllerOperation = operation;
    return pushAnimation;
}

-(void)setAGoalTapped
{
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


