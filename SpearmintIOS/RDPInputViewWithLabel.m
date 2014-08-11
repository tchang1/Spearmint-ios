//
//  RDPInputViewWithLabel.m
//  SpearmintIOS
//
//  Created by Matthew Ziegler on 8/4/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPInputViewWithLabel.h"

@implementation RDPInputViewWithLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect inputRectInner = CGRectMake(self.input.frame.origin.x,
                                           self.input.frame.origin.y,
                                           self.input.frame.size.width,
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
    
    CGRect holeRectIntersection = CGRectIntersection(self.input.frame, rect);
    
    [kColor_Transparent setFill];
    UIRectFill( holeRectIntersection);
}


@end
