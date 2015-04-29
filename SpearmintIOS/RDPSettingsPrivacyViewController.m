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
    NSURL *URL = [NSURL URLWithString:@"http://placehold.it/300x550&text=There+is+no+PRIVACY"];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:URL];
    [self.privacyWebView loadRequest:requestObj];
    [self setNavigationBarColor:[UIColor whiteColor]];

}

- (IBAction)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end