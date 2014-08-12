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

#define IS_TALL_SCREEN ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@interface RDPSetAmountViewController ()

@end

@implementation RDPSetAmountViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray *buttons;
    // See if screen in 3.5 inch
    if (IS_TALL_SCREEN) {
        self.suggestionsView.innerViews = [NSArray arrayWithObjects:self.suggestion1, self.suggestion2, self.suggestion3, self.suggestion4,  self.suggestion5, self.suggestion6, nil];
        buttons = @[self.suggestionButton1, self.suggestionButton2, self.suggestionButton3, self.suggestionButton4, self.suggestionButton5, self.suggestionButton6];
    } else { // small screen so remove the last 3 views
        self.suggestionsView.innerViews = [NSArray arrayWithObjects:self.suggestion1, self.suggestion2, self.suggestion3, nil];
        buttons = @[self.suggestionButton1, self.suggestionButton2, self.suggestionButton3];
        [self.suggestionButton1 setTitle:@"100" forState:UIControlStateNormal];
        [self.suggestionButton2 setTitle:@"500" forState:UIControlStateNormal];
        [self.suggestionButton3 setTitle:@"1000" forState:UIControlStateNormal];
        self.suggestion4.hidden = YES;
        self.suggestion5.hidden = YES;
        self.suggestion6.hidden = YES;
    }
    
    for (RDPSuggestionSquare *square in self.suggestionsView.innerViews) {
        square.parentColor = self.suggestionsView.backgroundColor;
        square.borderWidth = 10;
        square.borderRadius = 5 ;
    }
    
    for (UIButton *button in buttons) {
        [button addTarget:nil action:@selector(addGoalAmount:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    // setup the cut out view
    self.setAmountTextField.indentAmount = 20;
    self.cutOutView.innerView = self.setAmountTextField;
    
    // Show the navigation bar with the back button
    [self.navigationItem setHidesBackButton:NO];
    
    
    [self addNavigationBarButton];
    

    self.navigationItem.title = [RDPStrings stringForID:sGoalAmount];
    
    self.setAmountTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[RDPStrings stringForID:sWillCost] attributes:@{NSForegroundColorAttributeName: kColor_halfWhiteText,NSFontAttributeName : [RDPFonts fontForID:fLoginPlaceholderFont]}];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.setAmountTextField becomeFirstResponder];
}

-(void)addNavigationBarButton{
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:
                                   @"Next" style:UIBarButtonItemStylePlain target:
                                   self action:@selector(nextButtonClicked)];
    [self.navigationItem setRightBarButtonItem:nextButton];
}

-(void)nextButtonClicked
{
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Saved goal amount in FTU" properties:@{@"amount" : self.setAmountTextField.text}];
    
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

- (void)addGoalAmount:(UIButton *)button
{
    self.setAmountTextField.text = button.titleLabel.text;
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Chose default amount" properties:@{@"name" : self.setAmountTextField.text}];
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
