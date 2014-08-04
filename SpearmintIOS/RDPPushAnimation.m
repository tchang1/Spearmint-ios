//
//  RDPPushAnimation.m
//  SpearmintIOS
//
//  Created by Matthew Ziegler on 8/3/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPPushAnimation.h"

#define kAnimationTime      0.25

@implementation RDPPushAnimation

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // the containerView is the superview during the animation process.
    UIView *container = transitionContext.containerView;
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *fromView = fromVC.view;
    UIView *toView = toVC.view;
    CGFloat containerWidth = container.frame.size.width;
    
    // Set the needed frames to animate.
    
    CGRect toInitialFrame = [container frame];
    CGRect fromDestinationFrame = fromView.frame;
    
    if ([self navigationControllerOperation] == UINavigationControllerOperationPush)
    {
        toInitialFrame.origin.x = containerWidth;
        toView.frame = toInitialFrame;
        fromDestinationFrame.origin.x = -containerWidth;
    }
    else if ([self navigationControllerOperation] == UINavigationControllerOperationPop)
    {
        toInitialFrame.origin.x = -containerWidth;
        toView.frame = toInitialFrame;
        fromDestinationFrame.origin.x = containerWidth;
    }
    
    // Create a screenshot of the toView.
    UIView *move = [toView snapshotViewAfterScreenUpdates:YES];
    move.frame = toView.frame;
    [container addSubview:move];
    
    [UIView animateWithDuration:kAnimationTime delay:0
         usingSpringWithDamping:1000 initialSpringVelocity:1
                        options:0 animations:^{
                            move.frame = container.frame;
                            fromView.frame = fromDestinationFrame;
                        }
                     completion:^(BOOL finished) {
                         if (![[container subviews] containsObject:toView])
                         {
                             [container addSubview:toView];
                         }
                         
                         toView.frame = container.frame;
                         [fromView removeFromSuperview];
                         [move removeFromSuperview];
                         [transitionContext completeTransition: YES];
                     }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if ([transitionContext isAnimated]){
        return kAnimationTime;
    }
    else {
        return 0;
    }
}

@end
