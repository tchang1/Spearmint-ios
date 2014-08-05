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



@interface RDPLoginViewController : RDPViewController <MBProgressHUDDelegate, RDPHTTPClientDelegate> {

MBProgressHUD *HUD;
}
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *emailStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordStatusLabel;
- (IBAction)loginButtonPressed:(id)sender;
- (IBAction)passwordEditingBegan:(id)sender;

@end
