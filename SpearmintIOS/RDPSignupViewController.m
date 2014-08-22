//
//  RDPSignupViewController.m
//  SpearmintIOS
//
//  Created by Chang, Tony on 8/7/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPSignupViewController.h"
#import "RDPValidationService.h"
#import "RDPAnalyticsModule.h"

#define kStoryboard @"Main"
#define kHome @"home"

@interface RDPSignupViewController ()

@end

@implementation RDPSignupViewController

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
    [_backgroundImageView setImage:[RDPImageBlur applyBlurOnImage:_backgroundImageView.image]];
    
    self.emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[RDPStrings stringForID:SEmailPlaceholder] attributes:@{NSForegroundColorAttributeName: kColor_halfWhiteText,
                                                                                                                                                   NSFontAttributeName : [RDPFonts fontForID:fLoginPlaceholderFont]}];
    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[RDPStrings stringForID:sPasswordPlaceholder] attributes:@{NSForegroundColorAttributeName: kColor_halfWhiteText,
                                                                                                                                                         NSFontAttributeName : [RDPFonts fontForID:fLoginPlaceholderFont]}];
    
    self.emailTextField.attributedText = [[NSAttributedString alloc] initWithString:@"" attributes:@{NSForegroundColorAttributeName: kColor_WhiteText, NSFontAttributeName : [RDPFonts fontForID:fLoginFont]}];
    self.passwordTextField.attributedText = [[NSAttributedString alloc] initWithString:@"" attributes:@{NSForegroundColorAttributeName: kColor_WhiteText, NSFontAttributeName : [RDPFonts fontForID:fLoginFont]}];
    
    self.emailTextField.layer.cornerRadius = 2;
    self.emailTextField.clipsToBounds = YES;
    self.emailTextField.indentAmount=10;
    self.emailStatusLabel.text=[RDPStrings stringForID:sEmailValidation];
    self.emailStatusLabel.alpha=0;
    
    self.passwordTextField.layer.cornerRadius = 2;
    self.passwordTextField.clipsToBounds = YES;
    self.passwordTextField.indentAmount=10;
    self.passwordStatusLabel.text=[RDPStrings stringForID:sPasswordValidation];
    self.passwordStatusLabel.alpha=0;
    
    self.emailTextField.delegate=self;
    self.passwordTextField.delegate=self;

    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self removeStatusBar];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signupButtonDown:(id)sender {
    [self.loginButton setAlpha:0.5];
}

- (IBAction)signupButtonPressed:(id)sender {
    [RDPAnalyticsModule track:@"Tried to sign up" properties:@{@"username" : self.emailTextField.text}];
    
    [self.loginButton setAlpha:1];
    BOOL valid=YES;
    valid = [self checkUsername] && [self checkPassword];
    
    if(valid)
    {
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.view addSubview:HUD];
        HUD.delegate = self;
        [self trySignupWithUsername:self.emailTextField.text andPassword:self.passwordTextField.text];
    }
}

-(BOOL)checkUsername {
    if (![RDPValidationService validateUsername:self.emailTextField.text])
    {
        
        UIImage *errorImage=[UIImage imageNamed:@"Envelope_Red"];
        [UIView animateWithDuration:0.25f animations:^{
            self.emailView.alpha=0.25;
        } completion:^(BOOL finished) {
            [UIView transitionWithView:self.emailFieldIcon
                              duration:0.25f
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                self.emailFieldIcon.image =errorImage;
                                self.emailView.alpha=1;
                                self.emailStatusLabel.alpha=1;
                            } completion:nil];
            
        }];
        
        return NO;
    }
    else
    {
        [UIView transitionWithView:self.emailFieldIcon
                          duration:0.5f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            self.emailFieldIcon.image =[UIImage imageNamed:@"Envelope"];
                        } completion:nil];
        self.emailStatusLabel.alpha=0;
        return YES;
    }
}

-(BOOL)checkPassword {
    if (![RDPValidationService validatePassword:self.passwordTextField.text])
    {
        [UIView animateWithDuration:0.25f animations:^{
            self.passwordView.alpha=0.25;
        } completion:^(BOOL finished) {
            [UIView transitionWithView:self.passwordFieldIcon
                              duration:0.25f
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                self.passwordFieldIcon.image =[UIImage imageNamed:@"Key_Red"];
                                self.passwordView.alpha=1;
                                self.passwordStatusLabel.alpha=1;
                            } completion:nil];
            
        }];
        return NO;
    }
    else
    {
        [UIView transitionWithView:self.passwordFieldIcon
                          duration:0.5f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            self.passwordFieldIcon.image =[UIImage imageNamed:@"key"];
                        } completion:nil];
        self.passwordStatusLabel.alpha=0;
        return YES;
    }
}

-(void)trySignupWithUsername:(NSString *)username andPassword:(NSString *)password {
    
    [self.userGoal setCurrentAmount:[[NSNumber alloc] initWithInt:0]];
    
    [RDPUserService createUserWithUsername:username andPassword:password andGoal:self.userGoal then:^(RDPUser *user) {
        
        [RDPAnalyticsModule track:@"Signed up" properties:@{@"username" : self.emailTextField.text}];
        [RDPAnalyticsModule identifyProfile];
        [RDPAnalyticsModule setProfile:@{@"Goal Name" : self.userGoal.getGoalName, @"$email" : self.emailTextField.text, @"Goal target amount": self.userGoal.getTargetAmount}];
        
        double delayInSeconds = 0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            UIViewController *viewController =
            [[UIStoryboard storyboardWithName:kStoryboard
                                       bundle:NULL] instantiateViewControllerWithIdentifier:kHome];
            CATransition *transition = [CATransition animation];
            transition.duration = 0.5f;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionFade;
            [self.navigationController.view.layer addAnimation:transition forKey:nil];
            [self.navigationController pushViewController:viewController animated:NO];
        });
    } failure:^(RDPResponseCode errorCode) {
        if (errorCode==RDPErrorCodeInvalidUsername) {
            HUD.labelText=[RDPStrings stringForID:sSignupUsernameError];
        }
        else {
            HUD.labelText=[RDPStrings stringForID:sSignupGeneralError];
        }
        
        [RDPAnalyticsModule track:@"Signup failed" properties:@{@"username" : self.emailTextField.text, @"reason" : HUD.labelText}];
        
        HUD.mode =MBProgressHUDModeText;
        [HUD hide:YES afterDelay:2];
    }];
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	HUD = nil;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength <= 32);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==self.emailTextField)
    {
        [self.passwordTextField becomeFirstResponder];
    }
    else if (textField== self.passwordTextField)
    {
        [self signupButtonPressed:self];
    }
    return YES;
}


- (BOOL)prefersStatusBarHidden
{
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
