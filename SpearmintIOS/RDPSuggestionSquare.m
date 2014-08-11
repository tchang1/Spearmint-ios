//
//  RDPSuggestionSquare.m
//  SpearmintIOS
//
//  Created by McElwain, Cori on 8/8/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPSuggestionSquare.h"
#import "RDPFonts.h"

@implementation RDPSuggestionSquare

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    [kColor_Transparent setFill];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:10];
    path.lineWidth = 1.0f;
    
    UIColor *color = [UIColor colorWithWhite:0.0 alpha:0.3];
    
    [color setStroke];
    [path stroke];
    [path fill];

}

@end
