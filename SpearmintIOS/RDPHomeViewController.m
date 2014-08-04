//
//  RDPHomeViewController.m
//  SpearmintIOS
//
//  Created by McElwain, Cori on 7/29/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPHomeViewController.h"
#import "RDPImageBlur.h"
#import "RDPHTTPClient.h"

@implementation RDPHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.imageFetcher = [RDPImageFetcher getImageFetcher];
    int index = self.imageFetcher.indexOfImageArray;
    self.clearImageView.image = self.imageFetcher.clearImagesArray[index];
    self.blurredImageView.image = self.imageFetcher.blurredImagesArray[index];
    
    self.counterView.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            self.counterView.hidden = NO;
            [self.counterView start];
        }
            break;
            
        case UIGestureRecognizerStateChanged:
        {
            self.blurredImageView.alpha = 0.0;
        }
            break;
            
        case UIGestureRecognizerStateEnded:
        {
            [UIView animateWithDuration:0.75 animations:^{
                
                self.blurredImageView.alpha = 1.0;
            }
                             completion:^(BOOL finished){
                                 [self transitionImages];
                             }];
            
            [self.counterView stop];
            [self.counterView hide];
            
        }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        default:
            break;
    }
}

- (void)transitionImages
{
    // Get the information on how much has been saved
    NSNumber *amountSaved = self.counterView.currencyValue;
    RDPSavingEvent *saved = [[RDPSavingEvent alloc] init];
    saved.goalid = @"53d2bf28c5fb963e0717d8c8"; //TODO: get actual goal id for user
    saved.amount = (NSDecimalNumber*) amountSaved;
    
    // reset the counter
    [self.counterView reset];
    
    // Transition the images and save this amount only if we have saved more than 0
    if (![amountSaved isEqualToNumber:[NSNumber numberWithInt:0]]) {
        RDPHTTPClient *client = [RDPHTTPClient sharedRDPHTTPClient];
        [client postSavings:saved];
        
        int nextIndex = (self.imageFetcher.indexOfImageArray + 1) % self.imageFetcher.numImages;
        self.clearImageView.image = self.imageFetcher.clearImagesArray[nextIndex];
        
        UIImage * toImage = self.imageFetcher.blurredImagesArray[nextIndex];
        [UIView transitionWithView:self.blurredImageView
                          duration:3.0f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            self.blurredImageView.image = toImage;
                        } completion:nil];
        
        // Update the index for the images array
        self.imageFetcher.indexOfImageArray = nextIndex;
        
        // Get new images from the server
        [self.imageFetcher nextImage];
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
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


@end
