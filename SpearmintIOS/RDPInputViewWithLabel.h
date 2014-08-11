//
//  RDPInputViewWithLabel.h
//  SpearmintIOS
//
//  Created by Matthew Ziegler on 8/4/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDPUITextField.h"

@interface RDPInputViewWithLabel : UIView
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet RDPUITextField *input;
@property (strong, nonatomic) UIColor* backgroundColor;

@end
