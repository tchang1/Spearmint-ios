//
//  RDPViewController.h
//  SpearnintIOS
//
//  Created by Matthew Ziegler on 7/21/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDPNavigationController.h"

@interface RDPViewController : UIViewController

@property (nonatomic, strong)RDPNavigationController* RDPNavigationController;

-(void)setNavigationBarColor:(UIColor*)color;
-(void)removeStatusBar;
-(void)clearNavigationView;
-(void)setPersistentBackgroundImage:(UIImage*)background;
-(void)removePersistentBackgroundImage;

@end
