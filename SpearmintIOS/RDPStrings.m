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
            result = @"Tap and hold \n to keep the savings";
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
            result = @"Notifications";
            break;
        case sSubmitFeedback:
            result = @"Feedback";
            break;
        case sRateTheApp:
            result = @"Rate the app";
            break;
        case sJustKept:
            result = @"You just kept ";
            break;
        case sGoal:
            result = @"GOAL";
            break;
        case sAmount:
            result = @"AMOUNT";
            break;
        case sAmountSaved:
            result = @"AMOUNT SAVED";
            break;
        case sIWantTo:
            result = @"I want to...";
            break;
        case sDaily:
            result = @"Daily";
            break;
        case sWeekly:
            result = @"Weekly";
            break;
        case sWeeklyReport:
            result = @"Weekly Report";
            break;
        case sWhenIReachMyGoal:
            result = @"When I Reach My Goal";
            break;
        case sWhenIDontSaveForThreeDays:
            result = @"When I don't save for 3 days";
            break;
        case sEmail:
            result = @"EMAIL";
            break;
        case sPushNotifications:
            result = @"PUSH NOTIFICATIONS";
            break;
        case sFeedback:
            result = @"Feedback";
            break;
        case sTypeFeedbackHere:
            result = @"Type feedback here...";
            break;
        case sUndo:
            result = @"Undo";
            break;
        case sSubmit:
            result = @"Submit";
            break;
        case sSlogan:
            result = @"Keep is a way to save for your \n goals by recording good \n spending decisions";
            break;
        case sCoffeeExampleHeader:
            result = @"When you decide to \n skip the $3 coffee that \n you usually buy...";
            break;
        case sCoffeeTapAndHold:
            result = @"Tap and hold \n to keep the $3 \n for your goal instead";
            break;
        case sCoffeeCounterLabel:
            result = @"When the timer \n reaches $3, \n release the screen";
            break;
        case sAddToGoalInstructions:
            result = @"Each time you record \n something in Keep we \n will add it to your goal.";
            break;
        case sContinue:
            result = @"Continue";
            break;
    }
    
    return result;
}

@end
