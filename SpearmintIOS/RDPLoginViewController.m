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
    
    self.emailTextField.attributedText = [[NSAttributedString alloc] initWithString:@"iostest@trykeep.com" attributes:@{NSForegroundColorAttributeName: kColor_WhiteText, NSFontAttributeName : [RDPFonts fontForID:fLoginFont]}];
    self.passwordTextField.attributedText = [[NSAttributedString alloc] initWithString:@"test" attributes:@{NSForegroundColorAttributeName: kColor_WhiteText, NSFontAttributeName : [RDPFonts fontForID:fLoginFont]}];
    
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
        
        UIImage *errorImage=[UIImage imageNamed:@"Envelope_red.png"];
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
                            self.emailFieldIcon.image =[UIImage imageNamed:@"Envelope.png"];
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
                                self.passwordFieldIcon.image =[UIImage imageNamed:@"Key_red.png"];
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
                            self.passwordFieldIcon.image =[UIImage imageNamed:@"key.png"];
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
    NSLog(@"trying login");
    [RDPUserService loginWithUsername:username andPassword:password then:^(RDPUser *user) {
        HUD.labelText=@"ClientDidLoginYALL!";
        HUD.mode =MBProgressHUDModeText;
        [HUD hide:YES afterDelay:0.5];

        [RDPAnalyticsModule track:@"Logged In" properties:@{@"username" : username } ];
        [RDPAnalyticsModule identifyProfile];
        [RDPAnalyticsModule setProfile:@{@"$email" : self.emailTextField.text}];
        
        double delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self performSegueWithIdentifier:@"loginToHome" sender:self];
        });
    } failure:^(RDPResponseCode errorCode) {
        HUD.labelText=@"Something bad happened";
        HUD.mode =MBProgressHUDModeText;
        [RDPAnalyticsModule track:@"Login failed" properties:@{@"username" : username,@"reason" : HUD.labelText } ];
        [HUD hide:YES afterDelay:2];
    }];
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
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



- (IBAction)passwordEditingBegan:(id)sender {
}
@end
