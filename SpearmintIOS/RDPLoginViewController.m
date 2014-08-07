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

@interface RDPLoginViewController ()

@end

@implementation RDPLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_backgroundImageView setImage:[RDPImageBlur applyBlurOnImage:_backgroundImageView.image]];
    
    self.emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[RDPStrings stringForID:SEmailPlaceholder] attributes:@{NSForegroundColorAttributeName: kColor_halfWhiteText,
        NSFontAttributeName : [RDPFonts fontForID:fLoginPlaceholderFont]}];
    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[RDPStrings stringForID:sPasswordPlaceholder] attributes:@{NSForegroundColorAttributeName: kColor_halfWhiteText,
        NSFontAttributeName : [RDPFonts fontForID:fLoginPlaceholderFont]}];
    
    self.emailTextField.attributedText = [[NSAttributedString alloc] initWithString:@"iostest@trykeep.com" attributes:@{NSForegroundColorAttributeName: kColor_WhiteText, NSFontAttributeName : [RDPFonts fontForID:fLoginFont]}];
    self.passwordTextField.attributedText = [[NSAttributedString alloc] initWithString:@"test" attributes:@{NSForegroundColorAttributeName: kColor_WhiteText, NSFontAttributeName : [RDPFonts fontForID:fLoginFont]}];
    
    self.emailTextField.layer.cornerRadius = 2;
    self.emailTextField.clipsToBounds = YES;
    
    self.passwordTextField.layer.cornerRadius = 2;
    self.passwordTextField.clipsToBounds = YES;
    
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
    if (![self validateUsername:self.emailTextField.text])
    {
        self.emailStatusLabel.text=[RDPStrings stringForID:sEmailValidation];
        [self.emailFieldIcon setImage:[UIImage imageNamed:@"Envelope_red.png"]];
        valid=NO;
    }
    if (![self validatePassword:self.passwordTextField.text])
    {
        self.passwordStatusLabel.text=[RDPStrings stringForID:sPasswordValidation];
        [self.passwordFieldIcon setImage:[UIImage imageNamed:@"Key_red.png" ]];
        valid=NO;
    }
    
    if(valid)
    {
        self.emailStatusLabel.text=@"";
        self.passwordStatusLabel.text=@"";
        [self.passwordFieldIcon setImage:[UIImage imageNamed:@"key.png" ]];
        [self.emailFieldIcon setImage:[UIImage imageNamed:@"Envelope.png"]];
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.view addSubview:HUD];
        HUD.delegate = self;
        [self tryLoginWithUsername:self.emailTextField.text andPassword:self.passwordTextField.text];
    }


    
}

-(BOOL)validateUsername:(NSString *)username {
    NSString *emailRegex=@"^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,4})$";
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:emailRegex options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:username options:0 range:NSMakeRange(0, [username length])];
    
    NSLog(@"%i", regExMatches);
    if (regExMatches == 0) {
        return NO;
    } else {
        return YES;
    }
}

-(BOOL)validatePassword:(NSString *)password {
    return [password length]>=4;
}

-(void)tryLoginWithUsername:(NSString *)username andPassword:(NSString *)password {
    NSLog(@"trying login");
    [RDPUserService loginWithUsername:username andPassword:password then:^(RDPUser *user) {
        HUD.labelText=@"ClientDidLoginYALL!";
        HUD.mode =MBProgressHUDModeText;
        [HUD hide:YES afterDelay:2];
        
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self performSegueWithIdentifier:@"loginToHome" sender:self];
        });
    } failure:^(RDPResponseCode errorCode) {
        HUD.labelText=@"Something bad happened";
        HUD.mode =MBProgressHUDModeText;
        [HUD hide:YES afterDelay:2];
    }];
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	HUD = nil;
}


- (IBAction)passwordEditingBegan:(id)sender {
}
@end
