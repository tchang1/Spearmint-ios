//
//  RDPAsyncProgressTracker.m
//  SpearmintIOS
//
//  Created by Matthew Ziegler on 8/6/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPAsyncProgressTracker.h"

@implementation RDPAsyncProgressTracker

-(id)init
{
    self = [super init];
    if (self) {
        self.totalAsyncOperations = 0;
        self.progress = 0;
    }
    return self;
}

-(BOOL) isComplete
{
    return (self.progress >= self.totalAsyncOperations);
}

-(void)asyncOperationFinished
{
    self.progress++;
    if (self.progress > self.totalAsyncOperations) {
        self.progress = self.totalAsyncOperations;
    }
}

-(void)addOperation
{
    self.totalAsyncOperations++;
}

@end
