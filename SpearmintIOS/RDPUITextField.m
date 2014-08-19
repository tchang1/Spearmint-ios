//
//  RDPUITextField.m
//  SpearmintIOS
//
//  Created by Chang, Tony on 8/4/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPUITextField.h"
#include <math.h>

@implementation RDPUITextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (!_indentAmount) {
            _indentAmount = 10;
        }
    }
    return self;
}

- (void)clearTextField:(id)sender
{
    self.text = @"";
}


- (void)setIndentAmount:(CGFloat)indentAmount
{
    _indentAmount = indentAmount;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + self.indentAmount, bounds.origin.y + 8,
                      bounds.size.width - 20, bounds.size.height - 16);
}
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}

- (void)drawRect:(CGRect)rect
{
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *img = [UIImage imageNamed:@"X.png"];
    CGRect frame = CGRectMake(0, 0, img.size.width + 10, img.size.height);
    [clearButton setFrame:frame];
    [clearButton setImage:img forState:UIControlStateNormal];
    [clearButton addTarget:self action:@selector(clearTextField:) forControlEvents:UIControlEventTouchUpInside];
    
    self.rightViewMode = UITextFieldViewModeWhileEditing;
    [self setRightView:clearButton];
    
    
    if (0 < self.borderRadius && self.parentColor) {
        CGBlendMode blendMode = kCGBlendModeNormal;
        CGFloat alpha = 1;
        
        [self.parentColor setFill];
        
        UIBezierPath *aPath = [UIBezierPath bezierPath];
        
        //Top Left
        [aPath moveToPoint:CGPointMake(self.bounds.origin.x, self.borderRadius)];
        [aPath addArcWithCenter:CGPointMake(self.borderRadius, self.borderRadius)
                         radius:self.borderRadius
                     startAngle:M_PI
                       endAngle:M_PI * 1.5
                      clockwise:YES];
        [aPath addLineToPoint:CGPointMake(self.bounds.origin.x, self.bounds.origin.y)];
        [aPath addLineToPoint:CGPointMake(self.bounds.origin.x, self.borderRadius)];

        [aPath closePath];
        [aPath fillWithBlendMode:blendMode alpha:alpha];
        
        [aPath removeAllPoints];
        
        //Top Right
        [aPath moveToPoint:CGPointMake(self.bounds.origin.x + self.bounds.size.width - self.borderRadius, self.bounds.origin.y)];
        [aPath addArcWithCenter:CGPointMake(self.bounds.origin.x + self.bounds.size.width - self.borderRadius, self.borderRadius)
                         radius:self.borderRadius
                     startAngle:M_PI * 1.5
                       endAngle:0
                      clockwise:YES];
        [aPath addLineToPoint:CGPointMake(self.bounds.origin.x + self.bounds.size.width, self.bounds.origin.y)];
        [aPath addLineToPoint:CGPointMake(self.bounds.origin.x + self.bounds.size.width - self.borderRadius, self.bounds.origin.y)];
        
        [aPath closePath];
        [aPath fillWithBlendMode:blendMode alpha:alpha];
        
        [aPath removeAllPoints];
        
        //Bottom Left
        [aPath moveToPoint:CGPointMake(self.bounds.origin.x + self.borderRadius, self.bounds.origin.y + self.bounds.size.height)];
        [aPath addArcWithCenter:CGPointMake(self.bounds.origin.x + self.borderRadius, self.bounds.origin.y + self.bounds.size.height - self.borderRadius)
                         radius:self.borderRadius
                     startAngle:M_PI * 0.5
                       endAngle:M_PI
                      clockwise:YES];
        [aPath addLineToPoint:CGPointMake(self.bounds.origin.x, self.bounds.origin.y + self.bounds.size.height)];
        [aPath addLineToPoint:CGPointMake(self.bounds.origin.x + self.borderRadius, self.bounds.origin.y + self.bounds.size.height)];
        
        [aPath closePath];
        [aPath fillWithBlendMode:blendMode alpha:alpha];
        
        [aPath removeAllPoints];
        
        //Bottom Right
        [aPath moveToPoint:CGPointMake(self.bounds.origin.x + self.bounds.size.width, self.bounds.origin.y + self.bounds.size.height - self.borderRadius)];
        [aPath addArcWithCenter:CGPointMake(self.bounds.origin.x + self.bounds.size.width - self.borderRadius, self.bounds.origin.y + self.bounds.size.height - self.borderRadius)
                         radius:self.borderRadius
                     startAngle:0
                       endAngle:M_PI * 0.5
                      clockwise:YES];
        [aPath addLineToPoint:CGPointMake(self.bounds.origin.x + self.bounds.size.width, self.bounds.origin.y + self.bounds.size.height)];
        [aPath addLineToPoint:CGPointMake(self.bounds.origin.x + self.bounds.size.width, self.bounds.origin.y + self.bounds.size.height - self.borderRadius)];
        
        [aPath closePath];
        [aPath fillWithBlendMode:blendMode alpha:alpha];
        
        [aPath removeAllPoints];
        
        //draw background
        if (self.textFieldColor) {
            [self.textFieldColor setFill];
            aPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.borderRadius];
            [aPath fillWithBlendMode:blendMode alpha:alpha];
        }
    }
}

@end
