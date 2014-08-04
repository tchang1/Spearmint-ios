//
//  UINavigationController+Retro.h
//  SpearmintIOS
//
//  Created by Matthew Ziegler on 8/3/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Retro)

- (void)pushViewControllerRetro:(UIViewController *)viewController;
- (void)popViewControllerRetro;

@end
