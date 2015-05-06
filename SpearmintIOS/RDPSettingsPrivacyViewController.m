//
//  RDPSettingsPrivacyViewController.m
//  SpearmintIOS
//
//  Created by Chang, Tony on 4/28/15.
//  Copyright (c) 2015 Spearmint. All rights reserved.
//

#import "RDPSettingsPrivacyViewController.h"


@implementation RDPSettingsPrivacyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:self.webURL];
    [self.privacyWebView loadRequest:requestObj];
    [self setNavigationBarColor:[UIColor whiteColor]];
    self.title = self.webViewTitle;
}


- (IBAction)backPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];

}

@end