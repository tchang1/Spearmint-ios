//
//  RDPTimer.h
//  SpearnintIOS
//
//  Created by Matthew Ziegler on 7/21/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CompletionBlock)(void);

@interface RDPTimer : NSObject

/**
 Creates a timer with no end time and no completion block. If you're thinking of using this,
 you're probably doing something wrong.
 */
- (RDPTimer*) init;

/**
 Creates a timer with an end time with no completion block. This will be useful for things such
 as interpolation where you want to get the progress over a set amount of time.
 
 @param milliseconds : The number of milliseconds that the timer will be running for.
 */
- (RDPTimer*) initWithTime:(NSInteger)milliseconds;

/**
 Creates a timer with a set amount of milliseconds and a completion block. This is useful for 
 running a block of code after a set amount of time.
 
 @param milliseconds : The number of milliseconds that the timer will be running for.
 @param (block)block : The block of code to run once the timer has finished.
 */
- (RDPTimer*) initWithTime:(NSInteger)milliseconds andCompletionBlock:(CompletionBlock)block;

/**
 This progresses the timer forward a set number of milliseconds. This should only be called by
 RDPTimerManager or another timer managing class.
 
 @param milliseconds : The amount of milliseconds to progress the timer.
 */
- (void) tick:(NSInteger)milliseconds;

/**
 Manually sets a completion block for the timer.
 
 @param (block)block : The block to call upon completion.
 */
- (void) setCompletionBlock:(CompletionBlock)block;

/**
 Gets the progress from 0.0 to 1.0 of the timer.
 */
- (NSNumber*) getProgress;

/**
 Returns if the timer has completed or not.
 */
- (BOOL) isComplete;

@end
