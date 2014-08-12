//
//  RDPUITextView.m
//  SpearmintIOS
//
//  Created by Matthew Ziegler on 8/12/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPUITextView.h"

@implementation RDPUITextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
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
            aPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(self.bounds.origin.x + self.borderWidth,
                                                                       self.bounds.origin.y + self.borderWidth,
                                                                       self.bounds.size.width - (self.borderWidth *2),
                                                                       self.bounds.size.height - (self.borderWidth * 2))
                                               cornerRadius:self.borderRadius];
            [aPath fillWithBlendMode:blendMode alpha:alpha];
        }
    }
}

@end
