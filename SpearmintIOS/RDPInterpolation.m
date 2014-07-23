//
//  RDPInterpolation.m
//  SpearnintIOS
//
//  Created by Matthew Ziegler on 7/23/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPInterpolation.h"
#import "RDPTimerManager.h"

@implementation RDPInterpolation

- (id) initWithStart:(double)start andEnd:(double)end over:(NSInteger)milliseconds
{
    self = [super init];
    if (self)
    {
        if (milliseconds < 0) {
            milliseconds = 0;
        }
        self.timer = [RDPTimerManager createTimerWithTime:milliseconds];
        self.start = start;
        self.end = end;
    }
    return self;
}

- (double) getCurrentValue
{
    NSAssert(true, @"getCurrentValue must be overwritten.");
    return 0;
}

- (BOOL) isFinished
{
    return NO;
}

@end
