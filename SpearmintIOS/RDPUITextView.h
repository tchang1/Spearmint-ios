//
//  RDPUITextView.h
//  SpearmintIOS
//
//  Created by Matthew Ziegler on 8/12/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RDPUITextView : UITextView

@property (nonatomic, assign) CGFloat borderRadius;
@property (nonatomic, strong) UIColor* parentColor;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, strong) UIColor* textFieldColor;

@end
