//
//  RDPHomeViewController.m
//  SpearmintIOS
//
//  Created by McElwain, Cori on 7/29/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPHomeViewController.h"
#import "RDPImageBlur.h"

@interface RDPHomeViewController ()

@end

@implementation RDPHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // TODO: move this code to get the next image to a place
    // before this view is loading 
    self.imageFetcher = [[RDPImageFetcher alloc] init];
    self.imageFetcher.delegate = self;
    
    [self.imageFetcher nextImage];
    
}

- (void)imageHasLoaded:(UIImage*)image
{
    self.clearImageView.image = image;
    
    // Apply the blur to our background image
    RDPImageBlur *blur = [[RDPImageBlur alloc] init];
    self.blurredImageView.image = [blur applyBlurOnImage:image withRadius:17];
    
    [self.view setNeedsDisplay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pressAndHold:(id)sender {
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
