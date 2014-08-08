//
//  RDPSetAGoalViewController.h
//  SpearmintIOS
//
//  Created by McElwain, Cori on 8/7/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDPViewController.h"
#import "RDPUITextField.h"
#import "RDPCutOutView.h"
#import "RDPGoal.h"

@interface RDPSetAGoalViewController : RDPViewController 


// The text field input 
@property (weak, nonatomic) IBOutlet RDPCutOutView *cutOutView;
@property (weak, nonatomic) IBOutlet RDPUITextField *setAGoalTextField;

// The goal
@property (strong, nonatomic) RDPGoal *userGoal; 

@end
