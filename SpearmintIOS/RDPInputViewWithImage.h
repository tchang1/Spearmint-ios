//
//  RDPInputViewWithImage.h
//  SpearmintIOS
//
//  Created by Chang, Tony on 8/6/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDPUITextField.h"

@interface RDPInputViewWithImage : UIView

@property (weak, nonatomic) IBOutlet UIImageView *inputIcon;
@property (weak, nonatomic) IBOutlet RDPUITextField *inputField;


+ (id)customView;

@end
