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

@interface RDPSignupViewController : RDPViewController <MBProgressHUDDelegate, RDPHTTPClientDelegate, UITextFieldDelegate> {

MBProgressHUD *HUD;
}
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *emailStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordStatusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *emailFieldIcon;
@property (weak, nonatomic) IBOutlet UIImageView *passwordFieldIcon;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
- (IBAction)signupButtonDown:(id)sender;
- (IBAction)signupButtonPressed:(id)sender;

@end
