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
#define kQueueName "com.spearmint.updateQueue"

typedef void (^UpdateBlock)(NSInteger);
typedef void(^CompletionBlock)(void);

static NSMutableArray* timers = nil;
static NSMutableDictionary* blocks = nil;
static NSInteger previousTime = 0;
static BOOL needsUpdating = NO;
static dispatch_queue_t updateQueue;

@implementation RDPTimerManager

+(void) update
{
    [RDPTimerManager validateNeedsUpdating];
    if (needsUpdating) {
        NSInteger currentTime = [NSDate timeIntervalSinceReferenceDate];
        NSInteger deltaTime = previousTime - currentTime;
        previousTime = currentTime;
        RDPTimer* timer;
        UpdateBlock updateBlock;
        NSInteger i = 0;
        
        if (timers && [timers count] > 0) {
            for(i = 0; i < [timers count]; i++) {
                timer = [timers objectAtIndex:i];
                [timer tick:deltaTime];
            }
        }
        
        if (blocks && [blocks count] > 0) {
            for (NSString* blockName in blocks)
            {
                updateBlock = [blocks objectForKey:blockName];
                if (updateBlock) {
                    updateBlock(deltaTime);
                }
            }
        }
        
        [RDPTimerManager validateNeedsUpdating];
        if (needsUpdating) {
            
        }
        else {
            updateQueue = NULL;
        }
    }
}

+(void) pauseFor:(NSInteger)milliseconds millisecondsThen: (void (^)(void))callbackBlock
{
    [RDPTimerManager createTimerWithTime:milliseconds andCompletionBlock:callbackBlock];
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
    return nil;
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

+(void) validateNeedsUpdating
{
    BOOL shouldUpdate = NO;
    if (timers && [timers count] > 0) {
        shouldUpdate = YES;
    }
    if (blocks && [blocks count] > 0) {
        shouldUpdate = YES;
    }
    needsUpdating = shouldUpdate;
}

+(void) startUpdating
{
    if (!updateQueue) {
        updateQueue = dispatch_queue_create(kQueueName , DISPATCH_QUEUE_SERIAL);
    }
    needsUpdating = YES;
    previousTime = [NSDate timeIntervalSinceReferenceDate];
}

@end
