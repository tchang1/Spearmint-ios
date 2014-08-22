//
//  RDPLoginViewController.m
//  SpearmintIOS
//
//  Created by Chang, Tony on 8/4/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPLoginViewController.h"
#import "RDPImageBlur.h"
#import "RDPUserService.h"
#import "RDPFonts.h"
#import "RDPColors.h"
#import "RDPStrings.h"
#import "RDPValidationService.h"
#import "RDPAnalyticsModule.h"

#define kStoryboard @"Main"
#define kHome @"home"

@interface RDPLoginViewController ()

@end

@implementation RDPLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_backgroundImageView setImage:[RDPImageBlur applyBlurOnFTUImage:_backgroundImageView.image]];
    
    self.emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[RDPStrings stringForID:SEmailPlaceholder] attributes:@{NSForegroundColorAttributeName: kColor_halfWhiteText,
        NSFontAttributeName : [RDPFonts fontForID:fLoginPlaceholderFont]}];
    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[RDPStrings stringForID:sPasswordPlaceholder] attributes:@{NSForegroundColorAttributeName: kColor_halfWhiteText,
        NSFontAttributeName : [RDPFonts fontForID:fLoginPlaceholderFont]}];
    
    self.emailTextField.font= [RDPFonts fontForID:fLoginFont];
    self.emailTextField.textColor=kColor_WhiteText;
    self.passwordTextField.font= [RDPFonts fontForID:fLoginFont];
    self.passwordTextField.textColor=kColor_WhiteText;
    
    self.emailTextField.delegate=self;
    self.passwordTextField.delegate=self;

    
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
    


    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)loginButtonDown:(id)sender {
    [self.loginButton setAlpha:0.5];
}

- (IBAction)loginButtonPressed:(id)sender {
    [self.loginButton setAlpha:1];
    BOOL valid=YES;
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
        
        valid=NO;
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

    }
    
    
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
        valid=NO;
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

    }
    
    if(valid)
    {
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.view addSubview:HUD];
        HUD.delegate = self;
        [self tryLoginWithUsername:self.emailTextField.text andPassword:self.passwordTextField.text];
    }


    
}

-(void)tryLoginWithUsername:(NSString *)username andPassword:(NSString *)password {
    //DevNSLog(@"trying login");
    [RDPUserService loginWithUsername:username andPassword:password then:^(RDPUser *user) {
        [RDPAnalyticsModule track:@"Logged In" properties:@{@"username" : username } ];
        [RDPAnalyticsModule identifyProfile];
        [RDPAnalyticsModule setProfile:@{@"$email" : self.emailTextField.text}];
        
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
        if (errorCode==RDPErrorCodeUnauthorized)
        {
            HUD.labelText=[RDPStrings stringForID:sLoginUnauthorized];
        }
        else
        {
            HUD.labelText=[RDPStrings stringForID:sLoginGeneralError];
        }
        HUD.mode =MBProgressHUDModeText;
        [RDPAnalyticsModule track:@"Login failed" properties:@{@"username" : username,@"reason" : HUD.labelText } ];
        [HUD hide:YES afterDelay:2];
    }];
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidden
	[HUD removeFromSuperview];
	HUD = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==self.emailTextField)
    {
        [self.passwordTextField becomeFirstResponder];
    }
    else if (textField== self.passwordTextField)
    {
        [self loginButtonPressed:self];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength <= 32);

}



- (IBAction)passwordEditingBegan:(id)sender {
}

- (IBAction)forgotPasswordPressed:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:team%40trykeep.com?subject=Recover%20my%20password&body=Hi%20Keep%20Team%2C%0APlease%20help%20me%20recover%20my%20password.%0AThe%20email%20I%20used%20to%20sign%20up%20for%20keep%20is..."]];
}
@end
