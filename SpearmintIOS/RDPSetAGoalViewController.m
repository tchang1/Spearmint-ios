//
//  RDPSetAGoalViewController.m
//  SpearmintIOS
//
//  Created by McElwain, Cori on 8/7/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPSetAGoalViewController.h"
#import "RDPColors.h"
#import "RDPStrings.h"
#import "RDPSetAmountViewController.h"

#define kStoryboard @"Main"
#define kSetAmount @"setAmount"

@interface RDPSetAGoalViewController ()

@end

@implementation RDPSetAGoalViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // create user goal
    self.userGoal = [[RDPGoal alloc] init];
    
    // setup the cut out view
    self.setAGoalTextField.indentAmount = 10;
    self.cutOutView.innerView = self.setAGoalTextField; 
    
    // Show the navigation bar without the background button
    [self.navigationItem setHidesBackButton:YES];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController.navigationBar setBackIndicatorImage:[[UIImage alloc]init]];
    [self.navigationController.navigationBar setBackIndicatorTransitionMaskImage:[[UIImage alloc]init]];
    
    [self addNavigationBarButton];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    UIView* statusBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 340, 20)];
    [statusBackground setBackgroundColor:kColor_SettingPanelHeader];
    [self.navigationController.view insertSubview:statusBackground atIndex:2];
    
    // Make the navigation bar look pretty
    [self.navigationController.navigationBar setBackgroundColor:kColor_SettingPanelHeader];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [RDPFonts fontForID:fNavigationHeaderFont],
      NSFontAttributeName, nil]];
    self.navigationItem.title = [RDPStrings stringForID:sSetAGoal];
    
    self.setAGoalTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[RDPStrings stringForID:sIwant] attributes:@{NSForegroundColorAttributeName: kColor_halfWhiteText,NSFontAttributeName : [RDPFonts fontForID:fLoginPlaceholderFont]}];
}

-(void)addNavigationBarButton{
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:
                                  @"Next" style:UIBarButtonItemStylePlain target:
                                  self action:@selector(nextButtonClicked)];
    [self.navigationItem setRightBarButtonItem:nextButton];
}

-(void)nextButtonClicked
{
    [self.userGoal setGoalName:self.setAGoalTextField.text];
    
    RDPSetAmountViewController *viewController =
    [[UIStoryboard storyboardWithName:kStoryboard
                           bundle:NULL] instantiateViewControllerWithIdentifier:kSetAmount];
    
    viewController.userGoal = self.userGoal;

    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
