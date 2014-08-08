//
//  RDPSuggestionView.m
//  SpearmintIOS
//
//  Created by McElwain, Cori on 8/8/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPSuggestionsView.h"

@implementation RDPSuggestionsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Start by filling the area with the blue color
    [self.backgroundColor setFill];
    UIRectFill( rect );
        
    int numViews = [self.innerViews count];
    for (int i=0; i < numViews; i++) {
        UIView *view = self.innerViews[i];
        //UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:view.bounds cornerRadius:10];
        
        CGRect holeRectIntersection = CGRectIntersection(view.frame, rect);
        
        [kColor_Transparent setFill];

        UIRectFill(holeRectIntersection);
    }
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
