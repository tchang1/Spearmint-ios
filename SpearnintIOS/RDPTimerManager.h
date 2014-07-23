//
//  RDPTimerManager.h
//  SpearnintIOS
//
//  Created by Matthew Ziegler on 7/21/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RDPTimer.h"

@interface RDPTimerManager : NSObject

+(void) pauseFor:(NSInteger)milliseconds millisecondsThen: (void (^)(void))callbackBlock;


@end
