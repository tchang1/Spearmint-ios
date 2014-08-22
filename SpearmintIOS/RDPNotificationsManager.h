//
//  RDPNotificationsManager.h
//  SpearmintIOS
//
//  Created by Chang, Tony on 8/11/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RDPUser.h"

@interface RDPNotificationsManager : NSObject

+(void)scheduleTestNotificationWithMessage:(NSString*)message after:(int)seconds;
+(void)clearLocalNotifications;
+(void)enableLocalNotifications;
//+(void)enableNotificationsAtHour:(int)hour;
+(void)scheduleNotificationsBasedOnUser:(RDPUser *)user;

@end
