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

#define kStoryboard @"Main"
#define kSetAmount @"setAmount"

@interface RDPSetAGoalViewController ()

@end

@implementation RDPSetAGoalViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // setup the cut out view
    self.setAGoalTextField.indentAmount = 10;
    self.cutOutView.innerView = self.setAGoalTextField; 
    
    // Show the navigation bar without the background button
    [self.navigationItem setHidesBackButton:YES];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
//    [[UINavigationBar appearance] setBackIndicatorImage:nil];
//    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:nil];
    
    [self addNavigationBarButton];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.delegate = self;
    
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
    UIViewController *viewController =
    [[UIStoryboard storyboardWithName:kStoryboard
                           bundle:NULL] instantiateViewControllerWithIdentifier:kSetAmount];

    [self.navigationController pushViewController:viewController animated:YES];
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

@end
