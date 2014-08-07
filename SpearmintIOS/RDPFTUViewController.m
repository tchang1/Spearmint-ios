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

@interface RDPFTUViewController ()

@end

@implementation RDPFTUViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Initialize the background images
    UIImage *image = [UIImage imageNamed:@"ireland.jpg"];
    self.clearImageView.image = image;
    self.blurredImageView.image = [RDPImageBlur applyBlurOnImage:image];
    
    // Hide everything except the welcome view
    self.startExampleView.hidden = YES;
    self.counterAndTextView.hidden = YES;
    self.endExampleView.hidden = YES;
    
    // Set the text for the labels to be the first example
    self.keepSlogan.text = [RDPStrings stringForID:sSlogan];
    self.tapAndHoldLabel.text = [RDPStrings stringForID:sCoffeeTapAndHold];
    self.savingsExampleLabel.text = [RDPStrings stringForID:sCoffeeExampleHeader];
    self.counterLabel.text = [RDPStrings stringForID:sCoffeeCounterLabel];
    self.instructionsLabel.text = [RDPStrings stringForID:sAddToGoalInstructions];
    self.continueButton.titleLabel.text = [RDPStrings stringForID:sContinue]; 
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

- (IBAction)startFTU:(id)sender {
    
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
    
}

- (IBAction)continueFTU:(id)sender {
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}



@end


