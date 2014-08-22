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
    NSDate *startDate = [self daysFromToday:0 hours:0];
    NSDate *endDate = [self daysFromToday:1 hours:0];

    NSPredicate *dayPredicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@) AND (deleted == NO)", startDate, endDate];
    NSArray *savingsToday = [savings filteredArrayUsingPredicate:dayPredicate];
    
    NSPredicate *totalPredicate = [NSPredicate predicateWithFormat:@"(deleted == NO) AND (date <= %@)",endDate];
    
    NSArray *totalUndeletedSavings= [savings filteredArrayUsingPredicate:totalPredicate];
    
    NSArray *shortQuotes=[RDPQuotes getRandomShortQuotes];
    
    NSString *message = @"";
    
    //Didn't save today
    if ([savingsToday count]<1)
    {
        message=[NSString stringWithFormat:@"%@ %@",
                 [shortQuotes objectAtIndex:0],
                 @"What can you Keep today?"];
    }
    //Saved today
    else
    {
        int streak = [RDPNotificationsManager consecutiveSavingDays:totalUndeletedSavings];
        
        float total=0;
        
        NSUInteger totalCount=[totalUndeletedSavings count];
        NSUInteger todayCount=[savingsToday count];
        NSUInteger untilYesterdayCount = totalCount-todayCount;
        NSUInteger totalMilestones = totalCount/10;
        NSUInteger untilYesterdayMilestones = untilYesterdayCount/10;
        //Should show streak
        if (streak>1 && (streak-1)%2==0)
        {
            message =[NSString stringWithFormat:@"You've kept %i days in a row! What can you Keep today?",streak];
        }
        //Should show milestone
        else if (todayCount>=10 || totalMilestones>untilYesterdayMilestones)
        {
            message= [NSString stringWithFormat:@"You've now kept over %i times! Keep it up!", (int)totalMilestones*10];
        }
        
        else {
            for (RDPSavingEvent *saving in savingsToday)
            {
                total +=[saving.getAmount floatValue];
            }
            NSNumber *totalSavings= [NSNumber numberWithFloat:total];
            message= [NSString stringWithFormat:@"You kept %@ yesterday.\nWhat can you Keep today?",[[RDPConfig numberFormatter] stringFromNumber:totalSavings]];
        }
    }
    
    [self scheduleNotificationWithMessage:message date:[self daysFromToday:1 hours:8]];
    //[self scheduleTestNotificationWithMessage:message after:5];
    
    for (int i=1; i<[shortQuotes count]; i++) {
        [self scheduleNotificationWithMessage:[NSString stringWithFormat:@"%@ %@",
                                                    [shortQuotes objectAtIndex:i],
                                                    @"What can you Keep today?"] date:[self daysFromToday:i+1 hours:8]];
        /*
        [self scheduleTestNotificationWithMessage:[NSString stringWithFormat:@"%@ %@",
                                                   [shortQuotes objectAtIndex:i],
                                                   @"What can you Keep today?"] after:5+i*10];
         */
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

+(int)consecutiveSavingDays:(NSArray *)savings
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setTimeZone:[NSTimeZone defaultTimeZone]];
    NSDate *currentDate=nil;
    NSDate *comparisonDate=nil;
    NSComparisonResult result;
    int streak=0;
    RDPSavingEvent *currentSavings;
    for (int i=(int)[savings count]-1; i>=0 ; i--) {
        currentSavings=[savings objectAtIndex:i];
        currentDate=[RDPNotificationsManager extractDateFromNSDate:currentSavings.date withCalendar:gregorian];
        comparisonDate=[RDPNotificationsManager daysFromToday:streak*-1 hours:0];
        result=[currentDate compare:comparisonDate];
        if (result ==NSOrderedSame)
        {
            streak++;
        }
        else if(result==NSOrderedAscending)
        {
            return streak;
        }
    }
    return streak;
}

+(NSDate *)extractDateFromNSDate:(NSDate *)date withCalendar:(NSCalendar *)cal
{
    NSDateComponents *comps=[cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:date];
    return [cal dateFromComponents:comps];
}

+(void)enableLocalNotifications {
    
}

+(void)clearLocalNotifications {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

@end
