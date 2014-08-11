//
//  RDPUITextField.h
//  SpearmintIOS
//
//  Created by Chang, Tony on 8/4/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RDPUITextField : UITextField

@property (nonatomic, assign) CGFloat indentAmount;
@property (nonatomic, assign) CGFloat borderRadius;
@property (nonatomic, strong) UIColor* parentColor;

@end
