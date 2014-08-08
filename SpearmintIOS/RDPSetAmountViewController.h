//
//  RDPSetAmountViewController.h
//  SpearmintIOS
//
//  Created by McElwain, Cori on 8/7/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPViewController.h"
#import "RDPCutOutView.h"
#import "RDPUITextField.h"

@interface RDPSetAmountViewController : RDPViewController <UINavigationControllerDelegate>

// The input text field
@property (weak, nonatomic) IBOutlet RDPCutOutView *cutOutView;
@property (weak, nonatomic) IBOutlet RDPUITextField *setAmountTextField;

@end
