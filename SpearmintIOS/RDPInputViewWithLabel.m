//
//  RDPInputViewWithLabel.m
//  SpearmintIOS
//
//  Created by Matthew Ziegler on 8/4/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPInputViewWithLabel.h"

#define kTextFieldPadding       5

@implementation RDPInputViewWithLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect inputRectInner = CGRectMake(self.input.frame.origin.x + kTextFieldPadding,
                                           self.input.frame.origin.y,
                                           self.input.frame.size.width - (kTextFieldPadding * 2),
                                           self.input.frame.size.height);
        [self.input setFrame:inputRectInner];
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    // Start by filling the area with the blue color
    [self.backgroundColor setFill];
    UIRectFill( rect );
    
    // Assume that there's an ivar somewhere called holeRect of type CGRect
    // We could just fill holeRect, but it's more efficient to only fill the
    // area we're being asked to draw.
    
    CGRect inputRect = CGRectMake(self.input.frame.origin.x - kTextFieldPadding,
                                  self.input.frame.origin.y,
                                  self.input.frame.size.width + (kTextFieldPadding * 2),
                                  self.input.frame.size.height);
    
    CGRect holeRectIntersection = CGRectIntersection(inputRect, rect);
    
    [self.inputBackgroundColor setFill];
    UIRectFill( holeRectIntersection);
}


@end
