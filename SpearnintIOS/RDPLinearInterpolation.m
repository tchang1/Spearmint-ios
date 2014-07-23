//
//  RDPLinearInterpolation.m
//  SpearnintIOS
//
//  Created by Matthew Ziegler on 7/23/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPLinearInterpolation.h"

@implementation RDPLinearInterpolation

- (double) getCurrentValue
{
    if ([self.timer isComplete]) {
        self.value = self.end;
    }
    else {
        double diff = self.end - self.start;
        diff = diff * [[self.timer getProgress] doubleValue];
        self.value = self.start + diff;
    }
    return self.value;
}

@end
