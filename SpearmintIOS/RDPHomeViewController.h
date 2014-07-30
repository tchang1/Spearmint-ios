//
//  RDPHomeViewController.h
//  SpearmintIOS
//
//  Created by McElwain, Cori on 7/29/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDPImageFetcher.h"
#import "RDPImageFetcherDelegate.h"

@interface RDPHomeViewController : UIViewController <RDPImageFetcherDelegate>

// The image views that contain the clear and blurred version of
// the image to display to users on the home screen.
@property (weak, nonatomic) IBOutlet UIImageView *clearImageView;
@property (weak, nonatomic) IBOutlet UIImageView *blurredImageView;

// The gesture recognizer to detect when a user is pressing and holding
// down anywhere on the screen
@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *pressAndHoldGestureRecognizer;

// The image fetcher to get our next image 
@property RDPImageFetcher *imageFetcher;

/**
 Fades our the blurred image to reveal the clear image when a user holds the screen
 
 @param recognizer : the gesture recognizer being fired 
 */
- (IBAction)pressAndHold:(UIGestureRecognizer *)recognizer;

@end
