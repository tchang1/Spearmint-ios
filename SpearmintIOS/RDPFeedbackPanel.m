//
//  RDPFeedbackPanel.m
//  SpearmintIOS
//
//  Created by Matthew Ziegler on 8/4/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPFeedbackPanel.h"

@interface RDPFeedbackPanel()
@property (weak, nonatomic) IBOutlet UITextView *feedbackTextView;
@end

@implementation RDPFeedbackPanel

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
    // Start by filling the area with the blue color
    [self.backgroundColor setFill];
    UIRectFill( rect );
    
    CGRect holeRectIntersection = CGRectIntersection(self.feedbackTextView.frame, rect);
    
    [kColor_Transparent setFill];
    UIRectFill( holeRectIntersection);
}


@end
