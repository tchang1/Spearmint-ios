//
//  RDPNavigationController.m
//  SpearmintIOS
//
//  Created by Ziegler, Matthew on 8/20/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPNavigationController.h"

@interface RDPNavigationController ()

@end

@implementation RDPNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [super pushViewController:viewController animated:animated];
}

-(UIViewController*)popViewControllerAnimated:(BOOL)animated
{
    return [super popViewControllerAnimated:animated];
}

-(void)pushViewController:(UIViewController *)viewController withAnimation:(RDPTransitionAnimation)animation
{
    if (animation == RDPTransitionAnimationDefault) {
        [self pushViewController:viewController animated:YES];
    }
    else {
        CATransition* transition = [CATransition animation];
        if (animation == RDPTransitionAnimationFlipLeft) {
            transition.type = @"oglFlip";
            transition.subtype = kCATransitionFromLeft;
        }
        else if (animation == RDPTransitionAnimationFlipRight) {
            transition.type = @"oglFlip";
            transition.subtype = kCATransitionFromRight;
        }

        transition.duration = 0.5;
        
        [self.view.layer addAnimation:transition forKey:kCATransition];
        [super pushViewController: viewController animated:NO];
    }
}

-(void)popToViewController:(UIViewController*)viewController withAnimation:(RDPTransitionAnimation)animation
{
    if (animation == RDPTransitionAnimationDefault) {
        [self popToViewController:viewController animated:YES];
    }
    else {
        CATransition* transition = [CATransition animation];
        if (animation == RDPTransitionAnimationFlipLeft) {
            transition.type = @"oglFlip";
            transition.subtype = kCATransitionFromLeft;
        }
        else if (animation == RDPTransitionAnimationFlipRight) {
            transition.type = @"oglFlip";
            transition.subtype = kCATransitionFromRight;
        }
        
        transition.duration = 0.5;
        
        [self.view.layer addAnimation:transition forKey:kCATransition];
        [self popToViewController:viewController animated:NO];
    }
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

@end
