//
//  RDPTimerManager.m
//  SpearnintIOS
//
//  Created by Matthew Ziegler on 7/21/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPTimerManager.h"
#import "RDPTimer.h"

#define FPS 60
#define kTolerance 0.001
#define kQueueName "com.spearmint.updateQueue"

static NSMutableArray* timers = nil;
static NSMutableDictionary* blocks = nil;
static double previousTime = 0;
static BOOL needsUpdating = NO;
//static dispatch_queue_t updateQueue;
static dispatch_source_t gcdTimer;

@implementation RDPTimerManager

+(void) update
{
    dispatch_source_cancel(gcdTimer);
    gcdTimer = NULL;
    [RDPTimerManager validateNeedsUpdating];
    if (needsUpdating) {
        double currentTime = CACurrentMediaTime() * 1000;
        double deltaTime = (currentTime - previousTime);
        previousTime = currentTime;
        RDPTimer* timer;
        UpdateBlock updateBlock;
        NSInteger i = 0;
                
        // "Ticks" all timers by the amount of milliseconds passed
        if (timers && [timers count] > 0) {
            // uses a copy of the timers array so that clients can remove timers in their completion block without
            // destroying the for loop.
            NSArray* timerCopies = [timers copy];
            for(i = 0; i < [timerCopies count]; i++) {
                timer = [timerCopies objectAtIndex:i];
                [timer tick:deltaTime];
            }
        }
        
        // Calls all update blocks and passes in the amount of milliseconds passed.
        if (blocks && [blocks count] > 0) {
            // uses a copy of the blocks dictionary so that clients can remove blocks in their update method without
            // destroying the for loop.
            NSDictionary* blocksCopy = [blocks copy];
            for (NSString* blockName in blocksCopy)
            {
                updateBlock = [blocksCopy objectForKey:blockName];
                if (updateBlock) {
                    updateBlock(deltaTime);
                }
            }
        }
        
        // Check to see if there are any timers or blocks that still need updating. If so,
        // schedule this method to be called again in 1.0/FPS seconds.
        [RDPTimerManager validateNeedsUpdating];
        if (needsUpdating) {
            [RDPTimerManager callUpdateIn:(1.0/FPS)];
        }
        else {
//            updateQueue = NULL;
        }
    }
}

/**
 Check to see if there are any timers or blocks that need to be updated. If so,
 mark the flag for needsUpdating. Otherwise, clear the update timer.
 */
+(void) validateNeedsUpdating
{
    BOOL shouldUpdate = NO;
    if (timers && [timers count] > 0) {
        shouldUpdate = YES;
    }
    if (blocks && [blocks count] > 0) {
        shouldUpdate = YES;
    }
    if (!shouldUpdate) {
        gcdTimer = nil;
    }
    needsUpdating = shouldUpdate;
}

/**
 Sets up the update queue and schedules the update block to run.
 */
+(void) startUpdating
{
//    if (!updateQueue) {
//        updateQueue = dispatch_queue_create(kQueueName , DISPATCH_QUEUE_SERIAL);
//    }
    needsUpdating = YES;
    previousTime = CACurrentMediaTime() * 1000;
    [RDPTimerManager callUpdateIn:1.0/FPS];
}

/**
 Schedules the update method to be called in x milliseconds.
 */
+(void) callUpdateIn:(double)milliseconds
{
    if (!gcdTimer) {
        gcdTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
        
        if (gcdTimer) {
            dispatch_source_set_timer(gcdTimer, dispatch_time(DISPATCH_TIME_NOW, milliseconds * NSEC_PER_SEC), milliseconds * NSEC_PER_SEC, (kTolerance * NSEC_PER_SEC));
            dispatch_source_set_event_handler(gcdTimer,
                                              ^(void){
                                                  [RDPTimerManager update];
                                              });
            dispatch_resume(gcdTimer);
        }
    }
}

+(void) pauseFor:(NSInteger)milliseconds millisecondsThen: (void (^)(void))callbackBlock
{
    RDPTimer* timer = [RDPTimerManager createTimerWithTime:milliseconds];
    __weak RDPTimer* weakTimer = timer;
    
    CompletionBlock newBlock = ^(void)
    {
        callbackBlock();
        if (weakTimer) {
            [RDPTimerManager clearTimer:weakTimer];
        }
    };
    
    NSLog(@"Setting new block");
    [timer setCompletionBlock:newBlock];
}

+(RDPTimer*) createTimerWithTime:(NSInteger)milliseconds
{
    return [RDPTimerManager createTimerWithTime:milliseconds andCompletionBlock:nil];
}

+(RDPTimer*) createTimerWithTime:(NSInteger)milliseconds andCompletionBlock:(CompletionBlock)completionBlock
{
    RDPTimer* timer = [[RDPTimer alloc] initWithTime:milliseconds andCompletionBlock:completionBlock];
    if (!timers) {
        timers = [[NSMutableArray alloc] init];
    }
    [RDPTimerManager startUpdating];
    [timers addObject:timer];
    return timer;
}

+(void) clearTimer:(RDPTimer*)timer
{
    if (timer && timers) {
        [timers removeObject:timer];
    }
}

+(void) clearAllTimers
{
    if (timers) {
        [timers removeAllObjects];
    }
}

+(void) registerUpdateBlock:(UpdateBlock) updateBlock
{
    [RDPTimerManager registerUpdateBlock:updateBlock withName:[NSUUID UUID]];
}

+(void) registerUpdateBlock:(UpdateBlock) updateBlock withName:(NSString*)name
{
    if (!blocks) {
        blocks = [[NSMutableDictionary alloc] init];
    }
    [RDPTimerManager startUpdating];
    [blocks setObject:updateBlock forKey:name];
}

+(void) clearUpdateBlockWithName:(NSString*)name
{
    if (blocks) {
        [blocks removeObjectForKey:name];
    }
}

+(void) clearAllUpdateBlocks
{
    if (blocks) {
        [blocks removeAllObjects];
    }
}

+(void) clearAll
{
    [RDPTimerManager clearAllTimers];
    [RDPTimerManager clearAllUpdateBlocks];
}

@end
