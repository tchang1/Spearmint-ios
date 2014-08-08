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
    // Start by filling the area with the
    [self.backgroundColor setFill];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:10];
    [path fill];
    
    self.layer.borderColor = [UIColor orangeColor].CGColor;
    self.layer.borderWidth = 0.5f;
    
//    self.suggestionButton =  [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [self.suggestionButton addTarget:self
//               action:@selector(aMethod:)
//     forControlEvents:UIControlEventTouchUpInside];
//    [self.suggestionButton setTitle:@"Show View" forState:UIControlStateNormal];
//    self.suggestionButton.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
//    [self addSubview:self.suggestionButton];

}

@end
