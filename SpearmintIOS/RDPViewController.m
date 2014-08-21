//
//  RDPViewController.m
//  SpearnintIOS
//
//  Created by Matthew Ziegler on 7/21/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "RDPNavigator.h"

#define kStatusBarViewTag           4357
#define kLowerBackgroundImageIndex  0
#define kBackgroundImageIndex       1
#define kBackgroundImageTag         1001
#define kLowerBackgroundImageTag    1002

@interface RDPViewController ()

@property (nonatomic, strong)UIView* statusBarBackground;

@end

@implementation RDPViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(RDPNavigationController*)RDPNavigationController
{
    return (RDPNavigationController*)self.navigationController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.delegate = [RDPNavigator sharedInstance];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setNavigationBarColor:(UIColor*)color
{
    [self removeStatusBar];
    if (!self.statusBarBackground) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                      forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = [UIImage new];
        self.navigationController.navigationBar.translucent = YES;
        
        self.statusBarBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 340, 20)];

        [self.navigationController.view addSubview:self.statusBarBackground];
        self.statusBarBackground.layer.zPosition = MAXFLOAT;
        self.statusBarBackground.tag = kStatusBarViewTag;
    }
    
    [self.statusBarBackground setBackgroundColor:color];
    [self.navigationController.navigationBar setBackgroundColor:color];
}

-(void)removeStatusBar
{
    UIView *statusBarBackground = [self.navigationController.view viewWithTag:kStatusBarViewTag];
    [statusBarBackground removeFromSuperview];

}

-(void)clearNavigationView
{
    [self removeStatusBar];
    [self removePersistentBackgroundImage];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)setPersistentBackgroundImage:(UIImage*)background
{
    if ([self.navigationController.view viewWithTag:kBackgroundImageTag]) {
        if ([(UIImageView*)[self.navigationController.view viewWithTag:kBackgroundImageTag] image] == background) {
            return;
        }
    }
    
    UIImageView* imageView = [[UIImageView alloc] initWithImage:background];
    
    imageView.frame = CGRectMake(self.navigationController.view.frame.origin.x,
                                 self.navigationController.view.frame.origin.y,
                                 self.navigationController.view.frame.size.width,
                                 self.navigationController.view.frame.size.height);
    imageView.contentMode = UIViewContentModeScaleToFill;
    [self setPersistentBackgroundImageView:imageView];
}

-(void)setPersistentBackgroundImageLower:(UIImage*)background
{
    if ([self.navigationController.view viewWithTag:kBackgroundImageTag]) {
        if ([(UIImageView*)[self.navigationController.view viewWithTag:kBackgroundImageTag] image] == background) {
            return;
        }
    }
    
    
    UIImageView* imageView = [[UIImageView alloc] initWithImage:background];
    
    
    imageView.frame = CGRectMake(self.navigationController.view.frame.origin.x,
                                 self.navigationController.view.frame.origin.y,
                                 self.navigationController.view.frame.size.width,
                                 self.navigationController.view.frame.size.height);
    imageView.contentMode = UIViewContentModeScaleToFill;
    [self setPersistentBackgroundImageViewLower:imageView];
}

-(void)setPersistentBackgroundImageView:(UIImageView*)background
{
//    if ([self.navigationController.view viewWithTag:kBackgroundImageTag]) {
//        if ((UIImageView*)[self.navigationController.view viewWithTag:kBackgroundImageTag] == background) {
//            return;
//        }
//    }
//    [self removePersistentBackgroundImage];
    [[self.navigationController.view viewWithTag:kBackgroundImageTag] removeFromSuperview];
    [self.navigationController.view insertSubview:background atIndex:kBackgroundImageIndex];
    background.tag = kBackgroundImageTag;
}

-(void)setPersistentBackgroundImageViewLower:(UIImageView*)background
{
//    if ([self.navigationController.view viewWithTag:kBackgroundImageTag]) {
//        if ((UIImageView*)[self.navigationController.view viewWithTag:kBackgroundImageTag] == background) {
//            return;
//        }
//    }
//    [self removePersistentBackgroundImage];
    [[self.navigationController.view viewWithTag:kLowerBackgroundImageTag] removeFromSuperview];
    [self.navigationController.view insertSubview:background atIndex:kLowerBackgroundImageIndex];
    background.tag = kLowerBackgroundImageTag;
}

-(void)removePersistentBackgroundImage
{
    [[self.navigationController.view viewWithTag:kBackgroundImageTag] removeFromSuperview];
    [[self.navigationController.view viewWithTag:kLowerBackgroundImageTag] removeFromSuperview];
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
