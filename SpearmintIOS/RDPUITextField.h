//
//  RDPUITextField.h
//  SpearmintIOS
//
//  Created by Chang, Tony on 8/4/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol RDPUITextFieldProtocol <UITextFieldDelegate>


@optional
-(void)removeNextButton;

@end // end of delegate protocol

@interface RDPUITextField : UITextField

@property (nonatomic, assign) CGFloat indentAmount;
@property (nonatomic, assign) CGFloat borderRadius;
@property (nonatomic, strong) UIColor* parentColor;
@property (nonatomic, strong) UIColor* textFieldColor;



@end


