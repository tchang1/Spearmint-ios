//
//  RDPSettingsController.h
//  SpearmintIOS
//
//  Created by Matthew Ziegler on 8/3/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDPViewController.h"

@interface RDPSettingsController : RDPViewController <UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate>

-(void)navigateToMyGoal;

@end
