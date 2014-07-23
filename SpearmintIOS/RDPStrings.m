//
//  RDPStrings.m
//  SpearnintIOS
//
//  Created by McElwain, Cori on 7/22/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPStrings.h"

@implementation RDPStrings

+ (NSString *)stringForID:(RDPStringID)stringID
{
    NSString *result = @"";
    
    switch (stringID) {
        case sPressAndHold:
            result = @"Press and hold to Keep the savings.";
            break;
        case sSettings:
            result = @"Settings";
            break;
        case sBack:
            result = @"Back";
            break;
        case sHistory:
            result = @"History";
            break;
        case sLogout:
            result = @"Logout";
            break;
        case sMyGoal:
            result = @"My Goal";
            break;
        case sNotificationSettings:
            result = @"Notification Settings";
            break;
        case sSubmitFeedback:
            result = @"Submit Feedback";
            break;
    }
    
    return result;
}

@end
