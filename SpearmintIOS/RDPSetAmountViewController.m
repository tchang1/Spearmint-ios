//
//  RDPSetAmountViewController.m
//  SpearmintIOS
//
//  Created by McElwain, Cori on 8/7/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPSetAmountViewController.h"
#import "RDPSignupViewController.h"

#define kStoryboard @"Main"
#define kSignUp @"signUp"

@interface RDPSetAmountViewController ()

@end

@implementation RDPSetAmountViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // setup the cut out view
    self.setAmountTextField.indentAmount = 20;
    self.cutOutView.innerView = self.setAmountTextField;
    
    // Show the navigation bar with the back button
    [self.navigationItem setHidesBackButton:NO];
    
    
    [self addNavigationBarButton];
    

    self.navigationItem.title = [RDPStrings stringForID:sGoalAmount];
    
    self.setAmountTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[RDPStrings stringForID:sWillCost] attributes:@{NSForegroundColorAttributeName: kColor_halfWhiteText,NSFontAttributeName : [RDPFonts fontForID:fLoginPlaceholderFont]}];
}

-(void)addNavigationBarButton{
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:
                                   @"Next" style:UIBarButtonItemStylePlain target:
                                   self action:@selector(nextButtonClicked)];
    [self.navigationItem setRightBarButtonItem:nextButton];
}

-(void)nextButtonClicked
{
    NSNumberFormatter *formatter = [RDPConfig numberFormatter];
    NSNumber *amount = [formatter numberFromString:self.setAmountTextField.text];
    [self.userGoal setTargetAmount:amount];
    
    RDPSignupViewController *viewController =
    [[UIStoryboard storyboardWithName:kStoryboard
                               bundle:NULL] instantiateViewControllerWithIdentifier:kSignUp];
    
    viewController.userGoal = self.userGoal;
    
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
