//
//  RDPCutOutView.m
//  SpearmintIOS
//
//  Created by McElwain, Cori on 8/7/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPCutOutView.h"

@implementation RDPCutOutView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Start by filling the area with the blue color
    [self.backgroundColor setFill];
    UIRectFill( rect );
    
    CGRect holeRectIntersection = CGRectIntersection(self.innerView.frame, rect);
    
    [kColor_Transparent setFill];
    UIRectFill( holeRectIntersection);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
