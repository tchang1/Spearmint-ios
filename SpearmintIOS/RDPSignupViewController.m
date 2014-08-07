//
//  RDPSignupViewController.m
//  SpearmintIOS
//
//  Created by Chang, Tony on 8/7/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPSignupViewController.h"
#import "RDPValidationService.h"

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
    
    self.emailTextField.attributedText = [[NSAttributedString alloc] initWithString:@"iostest@trykeep.com" attributes:@{NSForegroundColorAttributeName: kColor_WhiteText, NSFontAttributeName : [RDPFonts fontForID:fLoginFont]}];
    self.passwordTextField.attributedText = [[NSAttributedString alloc] initWithString:@"test" attributes:@{NSForegroundColorAttributeName: kColor_WhiteText, NSFontAttributeName : [RDPFonts fontForID:fLoginFont]}];
    
    self.emailTextField.layer.cornerRadius = 2;
    self.emailTextField.clipsToBounds = YES;
    
    self.passwordTextField.layer.cornerRadius = 2;
    self.passwordTextField.clipsToBounds = YES;
    
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
    [self.loginButton setAlpha:1];
    BOOL valid=YES;
    if (![RDPValidationService validateUsername:self.emailTextField.text])
    {
        self.emailStatusLabel.text=[RDPStrings stringForID:sEmailValidation];
        [self.emailFieldIcon setImage:[UIImage imageNamed:@"Envelope_red.png"]];
        valid=NO;
    }
    if (![RDPValidationService validatePassword:self.passwordTextField.text])
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
        [self trySignupWithUsername:self.emailTextField.text andPassword:self.passwordTextField.text];
    }
    
    
    
}

-(void)trySignupWithUsername:(NSString *)username andPassword:(NSString *)password {
    NSLog(@"trying login");
    RDPGoal *goal=[[RDPGoal alloc] initWithName:@"testGoal" andTagetAmount:@100 andCurrentAmount:@0 andSavingEvents:nil andGoalID:nil];
    [RDPUserService createUserWithUsername:username andPassword:password andGoal:goal then:^(RDPUser *user) {
        HUD.labelText=@"ClientDidLoginYALL!";
        HUD.mode =MBProgressHUDModeText;
        [HUD hide:YES afterDelay:2];
        
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self performSegueWithIdentifier:@"signupToHome" sender:self];
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
