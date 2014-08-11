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
        
    NSUInteger numViews = [self.innerViews count];
    for (int i=0; i < numViews; i++) {
        UIView *view = self.innerViews[i];
        
        CGRect holeRectIntersection = CGRectIntersection(view.frame, rect);
        
        [kColor_Transparent setFill];

        UIRectFill(holeRectIntersection);
        
        
//        CGBlendMode blendMode = kCGBlendModeClear;
//        CGFloat alpha = CGColorGetAlpha(view.backgroundColor.CGColor);
//        
//        UIBezierPath *aPath = [UIBezierPath bezierPath];
//        CGFloat borderRadius = 10;
//        
//        //Top Left
//        [aPath moveToPoint:CGPointMake(view.frame.origin.x, borderRadius)];
//        [aPath addArcWithCenter:CGPointMake(borderRadius, borderRadius)
//                         radius:borderRadius
//                     startAngle:M_PI
//                       endAngle:M_PI * 1.5
//                      clockwise:YES];
//        [aPath addLineToPoint:CGPointMake(view.frame.origin.x, view.frame.origin.y)];
//        [aPath addLineToPoint:CGPointMake(view.frame.origin.x, borderRadius)];
//        
//        [aPath closePath];
//        [aPath fillWithBlendMode:blendMode alpha:alpha];
//        
//        [aPath removeAllPoints];
//        
//        //Top Right
//        [aPath moveToPoint:CGPointMake(view.frame.origin.x + view.frame.size.width - borderRadius, view.frame.origin.y)];
//        [aPath addArcWithCenter:CGPointMake(view.frame.origin.x + view.frame.size.width - borderRadius, borderRadius)
//                         radius:borderRadius
//                     startAngle:M_PI * 1.5
//                       endAngle:0
//                      clockwise:YES];
//        [aPath addLineToPoint:CGPointMake(view.frame.origin.x + view.frame.size.width, view.frame.origin.y)];
//        [aPath addLineToPoint:CGPointMake(view.frame.origin.x + view.frame.size.width - borderRadius, view.frame.origin.y)];
//        
//        [aPath closePath];
//        [aPath fillWithBlendMode:blendMode alpha:alpha];
//        
//        [aPath removeAllPoints];
//        
//        //Bottom Left
//        [aPath moveToPoint:CGPointMake(view.frame.origin.x + borderRadius, view.frame.origin.y + view.frame.size.height)];
//        [aPath addArcWithCenter:CGPointMake(view.frame.origin.x + borderRadius, view.frame.origin.y + view.frame.size.height - borderRadius)
//                         radius:borderRadius
//                     startAngle:M_PI * 0.5
//                       endAngle:M_PI
//                      clockwise:YES];
//        [aPath addLineToPoint:CGPointMake(view.frame.origin.x, view.frame.origin.y + view.frame.size.height)];
//        [aPath addLineToPoint:CGPointMake(view.frame.origin.x + borderRadius, view.frame.origin.y + view.frame.size.height)];
//        
//        [aPath closePath];
//        [aPath fillWithBlendMode:blendMode alpha:alpha];
//        
//        [aPath removeAllPoints];
//        
//        //Bottom Right
//        [aPath moveToPoint:CGPointMake(view.frame.origin.x + view.frame.size.width, view.frame.origin.y + view.frame.size.height - borderRadius)];
//        [aPath addArcWithCenter:CGPointMake(view.frame.origin.x + view.frame.size.width - borderRadius, view.frame.origin.y + view.frame.size.height - borderRadius)
//                         radius:borderRadius
//                     startAngle:0
//                       endAngle:M_PI * 0.5
//                      clockwise:YES];
//        [aPath addLineToPoint:CGPointMake(view.frame.origin.x + view.frame.size.width, view.frame.origin.y + view.frame.size.height)];
//        [aPath addLineToPoint:CGPointMake(view.frame.origin.x + view.frame.size.width, view.frame.origin.y + view.frame.size.height - borderRadius)];
//        
//        [aPath closePath];
//        [aPath fillWithBlendMode:blendMode alpha:0.0];
//        
//        [aPath removeAllPoints];
//        
//        //draw background
//        [kColor_Transparent setFill];
//        aPath = [UIBezierPath bezierPathWithRoundedRect:view.frame cornerRadius:borderRadius];
//        [aPath fillWithBlendMode:blendMode alpha:0.0];
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
