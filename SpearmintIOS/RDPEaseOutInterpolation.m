//
//  RDPEaseOutInterpolation.m
//  SpearmintIOS
//
//  Created by Matthew Ziegler on 7/23/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPEaseOutInterpolation.h"

#define kEaseInEaseOutSteepness 10

@implementation RDPEaseOutInterpolation

- (double) getCurrentValue
{
    if ([self.timer isComplete]) {
        self.value = self.end;
    }
    else {
        double diff = self.end - self.start;
        double y = 0.5 + (atan(kEaseInEaseOutSteepness*([[self.timer getProgress] doubleValue] - 0.5)))/(2*atan(kEaseInEaseOutSteepness/2));
        self.value = self.start + diff * y;
    }
    return self.value;
}


@end
