//
//  RDPLoginViewController.h
//  SpearmintIOS
//
//  Created by Chang, Tony on 8/4/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPViewController.h"
#import "MBProgressHUD.h"
#import "RDPHTTPClient.h"
#import "RDPUITextField.h"



@interface RDPLoginViewController : RDPViewController <MBProgressHUDDelegate, RDPHTTPClientDelegate, UITextFieldDelegate, RDPUITextFieldProtocol> {

MBProgressHUD *HUD;
}
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UIView *emailView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet RDPUITextField *emailTextField;
@property (weak, nonatomic) IBOutlet RDPUITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *emailStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordStatusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *emailFieldIcon;
@property (weak, nonatomic) IBOutlet UIImageView *passwordFieldIcon;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
- (IBAction)loginButtonDown:(id)sender;
- (IBAction)loginButtonPressed:(id)sender;
- (IBAction)passwordEditingBegan:(id)sender;
- (IBAction)forgotPasswordPressed:(id)sender;

@end
