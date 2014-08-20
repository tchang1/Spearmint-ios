//
//  RDPNavigationController.h
//  SpearmintIOS
//
//  Created by Ziegler, Matthew on 8/20/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    RDPTransitionAnimationFlipRight,
    RDPTransitionAnimationFlipLeft,
    RDPTransitionAnimationDefault
} RDPTransitionAnimation;

@interface RDPNavigationController : UINavigationController

-(void)pushViewController:(UIViewController *)viewController withAnimation:(RDPTransitionAnimation)animation;
-(void)popToViewController:(UIViewController *)viewController withAnimation:(RDPTransitionAnimation)animation;

@end
