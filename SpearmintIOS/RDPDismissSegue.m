//
//  RDPDismissSegue.m
//  SpearmintIOS
//
//  Created by Chang, Tony on 8/19/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDPDismissSegue.h"

@implementation RDPDismissSegue

- (void)perform {
    UIViewController *sourceViewController = self.sourceViewController;
    [sourceViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end