//
//  RDPNotificationsManager.m
//  SpearmintIOS
//
//  Created by Chang, Tony on 8/11/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPNotificationsManager.h"
#import "RDPUser.h"
#import "RDPQuotes.h"

@implementation RDPNotificationsManager

+(void)scheduleTestNotificationWithMessage:(NSString*)message after:(int)seconds {
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif ==nil)
        return;
    localNotif.fireDate = [NSDate dateWithTimeIntervalSinceNow:seconds];
    localNotif.alertAction = @"Keep";
    localNotif.alertBody= message;
    localNotif.timeZone=[NSTimeZone defaultTimeZone];
    localNotif.applicationIconBadgeNumber = 1;
    localNotif.repeatInterval=NSMinuteCalendarUnit;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
}

+(void)scheduleNotificationWithMessage:(NSString*)message date:(NSDate *)date {
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif ==nil)
        return;
    localNotif.fireDate = date;
    localNotif.alertAction = @"Keep";
    localNotif.alertBody= message;
    localNotif.timeZone=[NSTimeZone defaultTimeZone];
    localNotif.applicationIconBadgeNumber = 1;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
}


+(void)scheduleNotificationsBasedOnUser:(RDPUser *)user
{
    [self clearLocalNotifications];

    RDPGoal *goal = user.getGoal;
    NSArray *savings = goal.getSavingEvents;
    NSDate *startDate = [self daysFromToday:-1 hours:0];
    NSDate *endDate = [self daysFromToday:0 hours:0];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@) AND (deleted == NO)", startDate, endDate];
    NSArray *filteredSavings = [savings filteredArrayUsingPredicate:predicate];
    
    
    NSArray *quotes=[RDPQuotes getRandomQuotes:30];
    
    NSString *message = @"";
    
    if ([filteredSavings count]<1)
    {
        message=[NSString stringWithFormat:@"\"%@\" - %@.\n%@",
                 [[quotes objectAtIndex:0] objectForKey:@"quote"],
                 [[quotes objectAtIndex:0] objectForKey:@"author"],
                 @"What can you Keep today?"];
    }
    else
    {
        float total=0;
        for (RDPSavingEvent *saving in filteredSavings)
        {
            total +=[saving.getAmount floatValue];
        }
        NSNumber *totalSavings= [NSNumber numberWithFloat:total];
        message= [NSString stringWithFormat:@"You kept %@ yesterday.\nWhat can you Keep today?",[[RDPConfig numberFormatter] stringFromNumber:totalSavings]];
    }
    
    [self scheduleNotificationWithMessage:message date:[self daysFromToday:1 hours:8]];
    
    for (int i=1; i<30; i++) {
        [self scheduleNotificationWithMessage:[NSString stringWithFormat:@"\"%@\" - %@.\n%@",
                                                   [[quotes objectAtIndex:i] objectForKey:@"quote"],
                                                   [[quotes objectAtIndex:i] objectForKey:@"author"],
                                                   @"What can you Keep today?"] date:[self daysFromToday:i+1 hours:8]];
    }
    
}

+(void)enabledDailyNotificationsStartingTomorrowAtHour:(int)hour {
    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif ==nil)
        return;
    
    localNotif.fireDate = [self daysFromToday:1 hours:8];
    localNotif.alertBody= @"Daily reminder";
    localNotif.timeZone=[NSTimeZone defaultTimeZone];
    localNotif.applicationIconBadgeNumber = 1;
    localNotif.repeatInterval = NSDayCalendarUnit;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    
}

//Returns a date where days is relative to today, and hour is the time of that day. E.g. daysFromToday:-1 hours:8 will return date for yesterday 8am.
+(NSDate*)daysFromToday:(int)days hours:(int)hours
{
    NSDate *today = [[NSDate alloc] init];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setTimeZone:[NSTimeZone defaultTimeZone]];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:days];
    
    NSDate *daysFromToday = [gregorian dateByAddingComponents:components toDate:today options:0];
    NSDateComponents *reminderTimeComponents = [gregorian components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:daysFromToday];
    reminderTimeComponents.hour=hours;
    return [gregorian dateFromComponents:reminderTimeComponents];

}

+(void)enableLocalNotifications {
    
}

+(void)clearLocalNotifications {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

@end
