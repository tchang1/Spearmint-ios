//
//  RDPInterpolation.h
//  SpearnintIOS
//
//  Created by Matthew Ziegler on 7/23/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RDPTimer.h"

@interface RDPInterpolation : NSObject

@property double start;
@property double end;
@property double value;
@property (nonatomic, strong) RDPTimer* timer;

- (id) initWithStart:(double)start andEnd:(double)end over:(NSInteger)milliseconds;

- (double) getCurrentValue;

- (BOOL) isFinished;

@end
