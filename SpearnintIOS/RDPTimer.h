//
//  RDPTimer.h
//  SpearnintIOS
//
//  Created by Matthew Ziegler on 7/21/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RDPTimer : NSObject

- (RDPTimer*) init;

- (RDPTimer*) initWithTime:(NSInteger)milliseconds;

- (RDPTimer*) initWithTime:(NSInteger)milliseconds andCompletionBlock:(void (^)(void))block;

- (void) tick:(NSInteger)milliseconds;

- (NSNumber*) getProgress;

- (BOOL) isComplete;

@end
