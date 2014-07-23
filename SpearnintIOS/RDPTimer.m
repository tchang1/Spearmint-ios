//
//  RDPTimer.m
//  SpearnintIOS
//
//  Created by Matthew Ziegler on 7/21/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPTimer.h"
//#import <NSDate>

typedef void(^CompletionBlock)(void);

@interface RDPTimer()

@property NSInteger beginningTime;
@property NSInteger endTime;
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

- (RDPTimer*) initWithTime:(NSInteger)milliseconds andCompletionBlock:(void (^)(void))block
{
    self = [super init];
    if (self)
    {
        self.beginningTime = [NSDate timeIntervalSinceReferenceDate];
        self.endTime = self.beginningTime + milliseconds;
        self.completionBlock = block;
    }
    return self;
}

- (void) tick:(NSInteger)milliseconds
{
    
}

- (NSNumber*) getProgress
{

    return nil;
}

- (BOOL) isComplete
{

    return NO;
}

@end
