//
//  RDPTimer.m
//  SpearnintIOS
//
//  Created by Matthew Ziegler on 7/21/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPTimer.h"
//#import <NSDate>

@interface RDPTimer()

@property NSInteger beginningTime;
@property NSInteger endTime;
@property NSInteger currentTime;
@property BOOL complete;
@property (nonatomic, copy) CompletionBlock completionBlock;

@end

@implementation RDPTimer

- (RDPTimer*) init
{
    return [self initWithTime:0 andCompletionBlock:nil];
}

- (RDPTimer*) initWithTime:(NSInteger)milliseconds
{
    return [self initWithTime:milliseconds andCompletionBlock:nil];
}

- (RDPTimer*) initWithTime:(NSInteger)milliseconds andCompletionBlock:(CompletionBlock)block
{
    self = [super init];
    if (self)
    {
        self.beginningTime = 0;
        self.currentTime = self.beginningTime;
        self.endTime = self.beginningTime + milliseconds;
        _completionBlock = block;
    }
    return self;
}

- (void) tick:(NSInteger)milliseconds
{
    self.currentTime += milliseconds;
    if (self.currentTime > self.endTime) {
        self.currentTime = self.endTime;
        if (!self.isComplete && self.completionBlock) {
            self.completionBlock();
            self.complete = YES;
        }
    }
}

- (void) setCompletionBlock:(CompletionBlock)block
{
    _completionBlock = block;
}

- (NSNumber*) getProgress
{
    return [NSNumber numberWithDouble:(self.currentTime/self.endTime)];
}

- (BOOL) isComplete
{
    return self.complete;
}

@end
