//
//  RDPTimerManager.h
//  SpearnintIOS
//
//  Created by Matthew Ziegler on 7/21/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RDPTimer.h"

typedef void (^UpdateBlock)(NSInteger);
typedef void(^CompletionBlock)(void);

@interface RDPTimerManager : NSObject

/**
 Pauses for a set number of milliseconds and then calls the specified block of code.
 
 @param milliseconds : The numbner of milliseconds to pause for.
 @param (block)callbackBlock : The block to execute after the pause.
 */
+(void) pauseFor:(NSInteger)milliseconds millisecondsThen: (void (^)(void))callbackBlock;

/**
 Creates a timer with the specified number of milliseconds. The timer can be queried to get the
 progress towards completion (from 0.0 to 1.0) and can be queried to see if the timer is finished.
 Timers should be cleared by either calling clearTimer:RDPTimer, clearAllTimers, or clearAll.
 
 @param milliseconds : The duration of the timer.
 */
+(RDPTimer*) createTimerWithTime:(NSInteger)milliseconds;

/**
 Creates a timer with the specified number of milliseconds. The timer will execute the specified 
 block when the timer has finished. The timer can be queried to get the
 progress towards completion (from 0.0 to 1.0) and can be queried to see if the timer is finished.
 Timers should be cleared by either calling clearTimer:RDPTimer, clearAllTimers, or clearAll.
 
 @param milliseconds : The duration of the timer.
 @param (block)completionBlock : The block to execute when the timer finishes.
 */
+(RDPTimer*) createTimerWithTime:(NSInteger)milliseconds andCompletionBlock:(CompletionBlock)completionBlock;

/**
 Clears a specified timer. If a timer is cleared before it is finished, the completionBlock will not 
 execute. It is up to clients to clear timers when they no longer need them.
 
 @param timer : The timer to clear.
 */
+(void) clearTimer:(RDPTimer*)timer;

/**
 Clears all (if any) timers.
 */
+(void) clearAllTimers;

/**
 Registeres a block to be called every frame per second. The FPS will ideally be 60, but conditions 
 may cause the FPS to be lower. Because of this, updateBlocks will have a parameter for milliseconds, which
 will contain the number of milliseconds since the last call. This will allow clients to adjust (if needed)
 when the FPS drops.
 */
+(void) registerUpdateBlock:(UpdateBlock) updateBlock;

/**
 Registeres a block to be called every frame per second. The block is registered with a NSString for a name
 so that the block can be referenced and cleared individually. The FPS will ideally be 60, but conditions
 may cause the FPS to be lower. Because of this, updateBlocks will have a parameter for milliseconds, which
 will contain the number of milliseconds since the last call. This will allow clients to adjust (if needed)
 when the FPS drops.
 */
+(void) registerUpdateBlock:(UpdateBlock) updateBlock withName:(NSString*)name;

/**
 Clears an update block with the specified name. If no name was given to the update block, the block must be
 cleared via clearAllUpdateBlocks or clearAll.
 */
+(void) clearUpdateBlockWithName:(NSString*)name;

/**
 Clears all (if any) updateBlocks.
 */
+(void) clearAllUpdateBlocks;

/**
 Clears all timers and update blocks.
 */
+(void) clearAll;

@end
