//
//  RDPEaseInInterpolation.m
//  SpearmintIOS
//
//  Created by Matthew Ziegler on 7/23/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPEaseInInterpolation.h"

@implementation RDPEaseInInterpolation

- (double) getCurrentValue
{
    if ([self.timer isComplete]) {
        self.value = self.end;
    }
    else {
        // This equation will probably work better: y = x*x*x*(10+x*(6*x-15))
        
        double diff = self.end - self.start;
        diff = diff * ([[self.timer getProgress] doubleValue] * [[self.timer getProgress] doubleValue]);
        self.value = self.start + diff;
    }
    return self.value;
}

@end