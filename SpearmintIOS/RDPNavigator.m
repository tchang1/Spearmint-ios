//
//  RDPNavigator.m
//  SpearmintIOS
//
//  Created by Ziegler, Matthew on 8/20/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPNavigator.h"
#import "RDPPushAnimation.h"

static RDPNavigator* navigator;

@implementation RDPNavigator

+(RDPNavigator*)sharedInstance
{
    if (!navigator) {
        navigator = [[RDPNavigator alloc] init];
    }
    return navigator;
}


- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    
    RDPPushAnimation* pushAnimation = [RDPPushAnimation new];
    pushAnimation.navigationControllerOperation = operation;
    return pushAnimation;
}

@end
