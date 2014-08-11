//
//  RDPSettingsFeedbackViewController.m
//  SpearmintIOS
//
//  Created by Matthew Ziegler on 8/4/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPSettingsFeedbackViewController.h"

@interface RDPSettingsFeedbackViewController ()
@property (weak, nonatomic) IBOutlet UILabel *feedbackHeader;
@property (weak, nonatomic) IBOutlet UIView *feedbackContainer;
@property (weak, nonatomic) IBOutlet UITextView *feedbackTextView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end

@implementation RDPSettingsFeedbackViewController

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
    [self.feedbackHeader setFont:[RDPFonts fontForID:fSectionHeaderFont]];
    [self.feedbackHeader setTextColor:kColor_DarkText];
    [self.feedbackHeader setText:[RDPStrings stringForID:sFeedback]];
    [self.feedbackContainer setBackgroundColor:kColor_PanelColor];
    [self.feedbackTextView setBackgroundColor:kColor_InputFieldColor];

    [self.submitButton.titleLabel setTextColor:kColor_DarkText];
    [self.submitButton setTintColor:kColor_DarkText];
    [self.submitButton.titleLabel setFont:[RDPFonts fontForID:fMenuFont]];
    [self.submitButton setBackgroundColor:kColor_PanelColor];
    self.feedbackTextView.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.feedbackTextView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
