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
#define kSpacing 6.0

#define IS_TALL_SCREEN ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@interface RDPSetAGoalViewController ()

@end

@implementation RDPSetAGoalViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // create user goal
    self.userGoal = [[RDPGoal alloc] init];
    
    NSArray *buttons;
    NSArray *buttonTitles;
    // See if screen in 3.5 inch
    if (IS_TALL_SCREEN) {
        self.suggestionsView.innerViews = [NSArray arrayWithObjects:self.suggestion1, self.suggestion2, self.suggestion3, self.suggestion4,  self.suggestion5, self.suggestion6, nil];
        buttons = @[self.suggestionButton1, self.suggestionButton2, self.suggestionButton3, self.suggestionButton4, self.suggestionButton5, self.suggestionButton6];
        buttonTitles = [NSArray arrayWithObjects:@"Go on\n vacation", @"Pay off\n debt", @"Rainy day\n fund", @"Buy a\n computer", @"Weekend\n away", @"Save for\n school", nil];
    } else { // small screen so remove the last 3 views
        self.suggestionsView.innerViews = [NSArray arrayWithObjects:self.suggestion1, self.suggestion2, self.suggestion3, nil];
        buttons = @[self.suggestionButton1, self.suggestionButton2, self.suggestionButton3];
        buttonTitles = [NSArray arrayWithObjects:@"Go on\n vacation", @"Make extra\n payment", @"Rainy day\n fund", nil];
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
        // setup the suggestion view
        [button.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
        int i = [buttons indexOfObject:button];
        NSString *title = buttonTitles[i];
        [button setTitle:title forState:UIControlStateNormal];
        [button addTarget:nil action:@selector(addGoalTitle:) forControlEvents:UIControlEventTouchUpInside];
        
        
        CGSize imageSize = button.imageView.frame.size;
        button.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (imageSize.height + kSpacing), 0.0);
        
        CGSize titleSize = button.titleLabel.frame.size;
        button.imageEdgeInsets = UIEdgeInsetsMake( - (titleSize.height + kSpacing), 0.0, 0.0, - titleSize.width);
    }
    
    
    // setup the cut out view
    self.setAGoalTextField.indentAmount = 10;
    self.cutOutView.innerView = self.setAGoalTextField; 
    
    // Show the navigation bar without the background button
    [self.navigationItem setHidesBackButton:YES];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController.navigationBar setBackIndicatorImage:[[UIImage alloc]init]];
    [self.navigationController.navigationBar setBackIndicatorTransitionMaskImage:[[UIImage alloc]init]];
    
    [self addNavigationBarButton];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    [self setNavigationBarColor:kColor_SettingPanelHeader];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [RDPFonts fontForID:fNavigationHeaderFont],
      NSFontAttributeName, nil]];
    self.navigationItem.title = [RDPStrings stringForID:sSetAGoal];
    
    self.setAGoalTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[RDPStrings stringForID:sIwant] attributes:@{NSForegroundColorAttributeName: kColor_halfWhiteText,NSFontAttributeName : [RDPFonts fontForID:fLoginPlaceholderFont]}];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.setAGoalTextField becomeFirstResponder];
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

- (void)addGoalTitle:(UIButton *)button
{
    self.setAGoalTextField.text = [button.titleLabel.text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
