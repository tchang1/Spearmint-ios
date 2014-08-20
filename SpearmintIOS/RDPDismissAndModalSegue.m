//
//  RDPDismissAndModalSegue.m
//  SpearmintIOS
//
//  Created by Chang, Tony on 8/19/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPDismissAndModalSegue.h"

@implementation RDPDismissAndModalSegue

- (void)perform {
    UIViewController *sourceViewController = self.sourceViewController;
    UIViewController *destinationViewController = self.destinationViewController;
    UIViewController *presentingViewController = sourceViewController.presentingViewController;
    [presentingViewController dismissViewControllerAnimated:NO completion:^{
        destinationViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [presentingViewController presentViewController:destinationViewController animated:YES completion:nil];
    }];

}

@end
