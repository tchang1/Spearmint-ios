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

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // TODO: move this code to get the next image to a place
    // before this view is loading 
//    self.imageFetcher = [[RDPImageFetcher alloc] init];
//    self.imageFetcher.delegate = self;
//    
//    [self.imageFetcher nextImage];
    self.imageFetcher = [RDPImageFetcher getImageFetcher];
    int index = self.imageFetcher.indexOfImageFile;
    self.clearImageView.image = self.imageFetcher.nextImagesArray[index];
    self.blurredImageView.image = self.imageFetcher.currentBlurredImage;
    
    
//    __weak __typeof(self) weakSelf = self;
//    self.imageFetcher.completionBlock = ^(UIImage* image) {
//        weakSelf.clearImageView.image = image;
//        
//        // Apply the blur to our background image
//        RDPImageBlur *blur = [[RDPImageBlur alloc] init];
//        weakSelf.blurredImageView.image = [blur applyBlurOnImage:image withRadius:10];
//        [weakSelf.view setNeedsDisplay];
//    };
    
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
    int nextIndex = (self.imageFetcher.indexOfImageFile + 1) % 10;
    self.clearImageView.image = self.imageFetcher.nextImagesArray[nextIndex];
    
    [UIView animateWithDuration:0.75 animations:^{
        self.blurredImageView.image = self.imageFetcher.nextBlurredImage;
    }];
    
    // Get new images from the server
    self.imageFetcher.indexOfImageFile = nextIndex;
    [self.imageFetcher blurNextTwoImages];
    [self.imageFetcher nextImage];
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
