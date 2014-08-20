//
//  RDPCompeteGoalController.m
//  SpearmintIOS
//
//  Created by Ziegler, Matthew on 8/19/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPCompeteGoalController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "RDPImageFetcher.h"
#import "RDPTimerManager.h"
#import "RDPSettingsController.h"
#import "RDPSettingsGoalViewController.h"

#define kStoryboardName             @"Main"
#define kSettingsMyGoalScreen       @"settingsMyGoal"
#define kVideoPlayerViewIndex       2
#define kVideoPlayerTag             98989

#define kScreenHeight  [UIScreen mainScreen].bounds.size.height

@interface RDPCompeteGoalController ()
@property (nonatomic, strong)MPMoviePlayerController* player;
@property (nonatomic, strong)UIImageView* imageView;
@property (weak, nonatomic) IBOutlet UILabel *lineOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *lineTwoLabel;
@property (weak, nonatomic) IBOutlet UIButton *setAnotherGoalButton;
@end

@implementation RDPCompeteGoalController

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
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *moviePath = [bundle pathForResource:@"Savings_Success" ofType:@"mp4"];
    NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
    
    self.player = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
    [self.player setMovieSourceType:MPMovieSourceTypeFile];
    self.player.controlStyle = MPMovieControlStyleNone;

    UIWindow *backgroundWindow = [[UIApplication sharedApplication] keyWindow];
    self.view.backgroundColor = kColor_Transparent;
    
    CAGradientLayer *backgroundLayer = [self createGradient];
    backgroundLayer.frame = self.view.frame;
    [self.view.layer insertSublayer:backgroundLayer atIndex:0];
    
    [self.player.view setFrame:backgroundWindow.frame];
    UIImage* backgroundImage = [[RDPImageFetcher getImageFetcher] getCurrentImage];
    
    UIImageView* imageView = [[UIImageView alloc]initWithImage:backgroundImage];
//    [self.navigationController.view insertSubview:imageView atIndex:0];
    [self.view addSubview:imageView];
    imageView.frame = CGRectMake(self.view.frame.origin.x,
                                 self.view.frame.origin.y,
                                 self.view.frame.size.width,
                                 self.view.frame.size.height);
    imageView.contentMode = UIViewContentModeScaleToFill;
    self.imageView = imageView;
    
    
    [self.lineOneLabel setFont:[RDPFonts fontForID:fReachGoalLine1]];
    self.lineOneLabel.text = [RDPStrings stringForID:sReachedGoalLine1];
    [self.lineTwoLabel setFont:[RDPFonts fontForID:fReachGoalLine2]];
    self.lineTwoLabel.text = [RDPStrings stringForID:sReachedGoalLine2];
    self.setAnotherGoalButton.titleLabel.text = [RDPStrings stringForID:sReachedGoalButtonText];
    [self.setAnotherGoalButton.titleLabel setFont:[RDPFonts fontForID:fLargeButtonFont]];
    self.setAnotherGoalButton.backgroundColor = kColor_PanelColor;
    
    self.lineOneLabel.alpha = 0;
    self.lineTwoLabel.alpha = 0;
    self.setAnotherGoalButton.alpha = 0;
    self.setAnotherGoalButton.enabled = NO;
    
    [RDPTimerManager pauseFor:6000 millisecondsThen:^{
        [UIView transitionWithView:self.navigationController.view
                          duration:0.5
                           options:UIViewAnimationOptionCurveLinear
                        animations:^{
                            self.lineOneLabel.alpha = 1;
                            self.lineTwoLabel.alpha = 1;
                        }
                        completion:nil];
    }];
    
    [RDPTimerManager pauseFor:8000 millisecondsThen:^{
        self.setAnotherGoalButton.enabled = YES;
        [UIView transitionWithView:self.navigationController.view
                          duration:0.5
                           options:UIViewAnimationOptionCurveLinear
                        animations:^{
                            self.setAnotherGoalButton.alpha = 1;
                        }
                        completion:nil];
    }];
    
    self.player.view.tag = kVideoPlayerTag;
    [self.view insertSubview:self.player.view atIndex:0];
    [self.player prepareToPlay];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIView transitionWithView:self.navigationController.view
                      duration:2
                       options:UIViewAnimationOptionCurveEaseIn
                    animations:^{
                        self.imageView.alpha = 0;
                    }
                    completion:nil];
    [self.player play];
}

- (CAGradientLayer *)createGradient
{
    UIColor *topColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    UIColor *bottomColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    NSArray *gradientColors = [NSArray arrayWithObjects:(id)topColor.CGColor, (id)bottomColor.CGColor, nil];
    NSArray *gradientLocations = [NSArray arrayWithObjects:[NSNumber numberWithDouble:0.65],[NSNumber numberWithDouble:1.0], nil];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = gradientColors;
    gradientLayer.locations = gradientLocations;
    
    return gradientLayer;
}

- (IBAction)setAnotherGoalPressed:(id)sender {
//    RDPViewController *settingsController =
//    [[UIStoryboard storyboardWithName:kStoryboardName
//                               bundle:NULL] instantiateViewControllerWithIdentifier:kSettingsScreenName];
//    
//    RDPViewController *myGoalController =
//    [[UIStoryboard storyboardWithName:kStoryboardName
//                               bundle:NULL] instantiateViewControllerWithIdentifier:kSettingsMyGoalScreen];
//    [self.navigationController pushViewController:settingsController animated:NO];
//    [settingsController.navigationController pushViewController:myGoalController animated:YES];
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"SegueFromGoalCompletionToSettings"])
    {
        // Get reference to the destination view controller
        RDPViewController *myGoalController =
        [[UIStoryboard storyboardWithName:kStoryboardName
                                   bundle:NULL] instantiateViewControllerWithIdentifier:kSettingsMyGoalScreen];
        UINavigationController *settingsNavigationController = [segue destinationViewController];
        self.player.view.hidden = YES;
        [[self.navigationController.view viewWithTag:kVideoPlayerTag] removeFromSuperview];
        [settingsNavigationController pushViewController:myGoalController animated:YES];
        
    }
}


@end
