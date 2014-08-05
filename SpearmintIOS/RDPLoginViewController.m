//
//  RDPLoginViewController.m
//  SpearmintIOS
//
//  Created by Chang, Tony on 8/4/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPLoginViewController.h"
#import "RDPImageBlur.h"

@interface RDPLoginViewController ()

@end

@implementation RDPLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_backgroundImageView setImage:[RDPImageBlur applyBlurOnImage:_backgroundImageView.image]];
    UIColor *color = [UIColor whiteColor];
    
    self.emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"PlaceHolder Text" attributes:@{NSForegroundColorAttributeName: color}];
    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"PlaceHolder Text" attributes:@{NSForegroundColorAttributeName: color}];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)loginButtonPressed:(id)sender {
    BOOL valid=YES;
    if (![self validateUsername:self.emailTextField.text])
    {
        self.emailStatusLabel.text=@"Please enter a valid email address";
        valid=NO;
    }
    if (![self validatePassword:self.passwordTextField.text])
    {
        self.passwordStatusLabel.text=@"Passwords must be at least 6 characters";
        valid=NO;
    }
    
    if(valid)
    {
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
    return [password length]>=6;
}

-(void)tryLoginWithUsername:(NSString *)username andPassword:(NSString *)password {
    NSLog(@"trying login");
    RDPHTTPClient *client = [RDPHTTPClient sharedRDPHTTPClient];
    [client loginWithUsername:username andPassword:password andCompletionBlock:^(void){
        HUD.labelText=@"ClientDidLoginYALL!";
        HUD.mode =MBProgressHUDModeText;
        [HUD hide:YES afterDelay:2];
        
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self performSegueWithIdentifier:@"loginToHome" sender:self];
        });
    }
     andFailureBlock:^(NSError *error) {
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
