//
//  RDPSignupViewController.h
//  SpearmintIOS
//
//  Created by Chang, Tony on 8/7/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//


#import "RDPViewController.h"
#import "MBProgressHUD.h"
#import "RDPHTTPClient.h"
#import "RDPImageBlur.h"
#import "RDPUserService.h"
#import "RDPFonts.h"
#import "RDPColors.h"
#import "RDPStrings.h"
#import "RDPUITextField.h"
#import "RDPGoal.h"

@interface RDPSignupViewController : RDPViewController <MBProgressHUDDelegate, RDPHTTPClientDelegate, UITextFieldDelegate, RDPUITextFieldProtocol> {

MBProgressHUD *HUD;
}
@property (weak, nonatomic) IBOutlet UILabel *signupMessage;
@property (weak, nonatomic) IBOutlet UIView *emailView;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet RDPUITextField *emailTextField;
@property (weak, nonatomic) IBOutlet RDPUITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *emailStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordStatusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *emailFieldIcon;
@property (weak, nonatomic) IBOutlet UIImageView *passwordFieldIcon;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) RDPGoal *userGoal; 
- (IBAction)signupButtonDown:(id)sender;
- (IBAction)signupButtonPressed:(id)sender;

@end
