//
//  RDPSetAmountViewController.m
//  SpearmintIOS
//
//  Created by McElwain, Cori on 8/7/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPSetAmountViewController.h"
#import "RDPSignupViewController.h"
#import "RDPAnalyticsModule.h"

#define kStoryboard @"Main"
#define kSignUp @"signUp"
#define kIndentAmount 20
#define kBorderWidth 1
#define kBorderRadius 5
#define k100 @"100"
#define k500 @"500"
#define k1000 @"1000"

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
        [self.suggestionButton1 setTitle:k100 forState:UIControlStateNormal];
        [self.suggestionButton2 setTitle:k500 forState:UIControlStateNormal];
        [self.suggestionButton3 setTitle:k1000 forState:UIControlStateNormal];
        self.suggestion4.hidden = YES;
        self.suggestion5.hidden = YES;
        self.suggestion6.hidden = YES;
    }
    
    for (RDPSuggestionSquare *square in self.suggestionsView.innerViews) {
        square.parentColor = self.suggestionsView.backgroundColor;
        square.borderWidth = kBorderWidth;
        square.borderRadius = kBorderRadius;
    }
    
    for (UIButton *button in buttons) {
        [button addTarget:nil action:@selector(addGoalAmount:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    // setup the cut out view
    self.setAmountTextField.indentAmount = kIndentAmount;
    self.cutOutView.innerView = self.setAmountTextField;
    self.setAmountTextField.borderRadius = kBorderRadius;
    self.setAmountTextField.parentColor = self.cutOutView.backgroundColor;
    self.setAmountTextField.delegate=self;
    
    // Show the navigation bar with the back button
    [self.navigationItem setHidesBackButton:NO];
    [self addNavigationBarButton];
    
    if ([self.userGoal.getGoalName length]<16)
    {
        self.navigationItem.title = self.userGoal.getGoalName;

    }
    else
    {
        self.navigationItem.title = [RDPStrings stringForID:sGoalAmount];
    }
    
    self.setAmountTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[RDPStrings stringForID:sWillCost] attributes:@{NSForegroundColorAttributeName: kColor_halfWhiteText,NSFontAttributeName : [RDPFonts fontForID:fLoginPlaceholderFont]}];
    self.setAmountTextField.delegate=self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.setAmountTextField becomeFirstResponder];
}

-(void)addNavigationBarButton{
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:
                                   [RDPStrings stringForID:sNext] style:UIBarButtonItemStylePlain target:
                                   self action:@selector(nextButtonClicked)];
    [self.navigationItem setRightBarButtonItem:nextButton];
}

-(void)nextButtonClicked
{
    [RDPAnalyticsModule track:@"Saved goal amount in FTU" properties:@{@"amount" : self.setAmountTextField.text}];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
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
    [RDPAnalyticsModule track:@"Chose default amount" properties:@{@"name" : self.setAmountTextField.text}];
    
    [self nextButtonClicked];

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return (([string isEqualToString:filtered])&&(newLength <= 7));
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==self.setAmountTextField)
    {
        [self nextButtonClicked];
    }
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
