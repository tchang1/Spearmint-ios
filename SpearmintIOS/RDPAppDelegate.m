//
//  RDPAppDelegate.m
//  SpearnintIOS
//
//  Created by McElwain, Cori on 7/21/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPAppDelegate.h"
#import "RDPTimerManager.h"
#import "RDPHTTPClient.h"
#import "RDPGoal.h"
#import "RDPNotificationsManager.h"
#import "RDPAnalyticsModule.h"
#import "RDPMixpanelAnalyticsProvider.h"
#import "RDPUserService.h"

@implementation RDPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    // Override point for customization after application launch.
//    self.window.backgroundColor = [UIColor whiteColor];
//    [self.window makeKeyAndVisible];
////    [RDPTimerManager registerUpdateBlock:^(NSInteger milliseconds) {
////        NSLog(@"Milliseconds: %i", milliseconds);
////    }
////                                withName:@"testBlock"];
////    
////    [RDPTimerManager pauseFor:5000 millisecondsThen:^(void){
////        [RDPTimerManager clearUpdateBlockWithName:@"testBlock"];
////        NSLog(@"Stopping now");
////    }];
//    NSShadow *shadow = [[NSShadow alloc] init];
//    shadow.shadowOffset = CGSizeMake(0.0, 1.0);
//    shadow.shadowColor = [UIColor whiteColor];
    
    RDPMixpanelAnalyticsProvider *mixpanel= [[RDPMixpanelAnalyticsProvider alloc] init];
    [RDPAnalyticsModule initializeAnalyticsProviders:@[mixpanel]];
    [RDPAnalyticsModule track:@"App opened" properties:@{@"method" : @"launch" } ];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
     setTitleTextAttributes:
     @{NSForegroundColorAttributeName:kColor_DarkText,
       NSFontAttributeName:[RDPFonts fontForID:fNavigationButtonFont]
       }
     forState:UIControlStateNormal];
    
    self.imageFetcher = [RDPImageFetcher getImageFetcher];
    
    //Check if user tapped a notification to launch app
    UILocalNotification *localNotif =
    [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotif) {
        UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"Launched app via notification" message:localNotif.alertBody delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    application.applicationIconBadgeNumber = 0;
    
    [RDPNotificationsManager clearLocalNotifications];
//    [RDPNotificationsManager scheduleTestNotificationWithMessage:@"test" after:5];
//    [RDPNotificationsManager scheduleTestNotificationWithMessage:@"hello" after:10];
//    RDPHTTPClient *client = [RDPHTTPClient sharedRDPHTTPClient];
//    [client getMyGoal];
//    [client testPOSTHTTPRequest:@""];
//     [client getSuggestions:@10 withSuccess:^(NSArray *suggestions) {
//         NSLog(@"%@",suggestions);
//     } andFailure:^(NSError *error) {
//         NSLog(error);
//     }];
//    //[client getMyNotifications];
//    [client logout];
//    RDPSavingEvent *saved = [[RDPSavingEvent alloc] init];
//    [saved setGoalid:@"53d2bf28c5fb963e0717d8c8"];
//    [saved setAmount:[[NSDecimalNumber alloc] initWithString:@"4377"]];
//    [client postSavings:saved];
//    NSHTTPCookie *cookie;
//    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    for (cookie in [storage cookies]) {
//        NSLog(@"%@",cookie);
//    }
    
//   [RDPImageFetcher getImageFetcher];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"become inactive");

    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [[UIApplication sharedApplication] cancelAllLocalNotifications];

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"entered Background");

    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self.imageFetcher saveIndices];
    RDPUser *userCopy=[RDPUserService getUser];
    if (userCopy==nil)
    {
        NSLog(@"No user");
        return;
    }
    [RDPNotificationsManager scheduleNotificationsBasedOnUser:userCopy];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"entering foreground");

    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [self.imageFetcher loadIndices];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"became active");
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"app will terminate");
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self.imageFetcher saveIndices];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    //App already running and in foreground when notification is received
    if (application.applicationState==UIApplicationStateActive)
    {
    
    }
    //App was in background and notification was tapped
    else if (application.applicationState==UIApplicationStateInactive)
    {
        UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"Notification Received while app inactive" message:notification.alertBody delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    application.applicationIconBadgeNumber = 0;

}

@end
