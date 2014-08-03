//
//  RDPStrings.h
//  SpearnintIOS
//
//  Created by McElwain, Cori on 7/22/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    sPressAndHold,
    sSettings,
    sBack,
    sMyGoal,
    sNotificationSettings,
    sSubmitFeedback,
    sHistory,
    sRateTheApp,
    sLogout
} RDPStringID;

@interface RDPStrings : NSObject

+ (NSString *)stringForID:(RDPStringID)stringID;

@end
