//
//  RDPNotificationsManager.m
//  SpearmintIOS
//
//  Created by Chang, Tony on 8/11/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPNotificationsManager.h"

@implementation RDPNotificationsManager

+(void)scheduleTestNotificationWithMessage:(NSString*)message after:(int)seconds {
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif ==nil)
        return;
    localNotif.fireDate = [NSDate dateWithTimeIntervalSinceNow:seconds];
    localNotif.alertBody= message;
    localNotif.timeZone=[NSTimeZone defaultTimeZone];
    localNotif.applicationIconBadgeNumber = 1;
    localNotif.repeatInterval=NSMinuteCalendarUnit;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
}

+(void)enableDailyNotificationsAtHour:(int)hour{
    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif ==nil)
        return;
    NSDate *today = [[NSDate alloc] init];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setTimeZone:[NSTimeZone defaultTimeZone]];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:1];
    NSDate *tomorrow = [gregorian dateByAddingComponents:components toDate:today options:0];
    NSDateComponents *reminderTimeComponents = [gregorian components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:tomorrow];
    reminderTimeComponents.hour=hour;
    NSDate *tomorrowReminderTime=[gregorian dateFromComponents:reminderTimeComponents];
    
    NSLog(@"%@",tomorrowReminderTime);
    
    
    localNotif.fireDate = tomorrowReminderTime;
    localNotif.alertBody= @"Daily reminder";
    localNotif.timeZone=[NSTimeZone defaultTimeZone];
    localNotif.applicationIconBadgeNumber = 1;
    localNotif.repeatInterval = NSDayCalendarUnit;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    
}

+(void)enableLocalNotifications {
    
}

+(void)clearLocalNotifications {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

@end
