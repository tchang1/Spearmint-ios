//
//  RDPSettingsPrivacyViewController.h
//  SpearmintIOS
//
//  Created by Chang, Tony on 4/28/15.
//  Copyright (c) 2015 Spearmint. All rights reserved.
//

#import "RDPViewController.h"
#import "RDPSignupViewController.h" 
#import "TTTAttributedLabel.h"

@interface RDPSettingsPrivacyViewController : RDPViewController <UITextViewDelegate, UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *privacyWebView;
@property (strong, nonatomic) NSString* webViewTitle;
@property (strong, nonatomic) NSURL* webURL;

@end
