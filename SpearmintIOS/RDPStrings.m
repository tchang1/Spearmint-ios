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
        case sUndoSavingBodyMessage:
            result = @"Are you sure?";
            break;
        case sUndoSavingUndoButton:
            result = @"Undo";
            break;
        case sUndoSavingCancelButton:
            result = @"Cancel";
            break;
        case sSubmitFeedbackAlertText:
            result = @"Than you for the feedback! We are working hard to make Keep better.";
            break;
        case sSubmitFeedbackAlertDismissButton:
            result = @"Dismiss";
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
            result = @"Keep is a way to save for your \ngoals by recording good \nspending decisions";
            break;
        case sCoffeeExampleHeader:
            result = @"When you decide to \n skip the $3 coffee that \n you usually buy...";
            break;
        case sCoffeeTapAndHold:
            result = @"Tap and hold \nto keep the $3 \nfor your goal instead";
            break;
        case sCoffeeCounterLabel:
            result = @"When the timer \nreaches $3, \nrelease the screen";
            break;
        case sCoffeeReleaseScreen:
            result = @"Release the screen";
            break;
        case sAddToGoalInstructions:
            result = @"Each time you record \nsomething in Keep we \nwill add it to your goal.";
            break;
        case sContinue:
            result = @"Continue";
            break;
	case sLogin:
            result = @"Login";
            break;
        case SEmailPlaceholder:
            result = @"Email";
            break;
        case sPasswordPlaceholder:
            result = @"Password";
            break;
        case sEmailValidation:
            result = @"Please enter a valid email address";
            break;
        case sPasswordValidation:
            result = @"Passwords must be at least 6 characters";
            break;
	case sKeepHolding:
            result = @"Keep holding";
            break;
        case sKeepHolding3:
            result = @"Keep holding until \nyou reach $3";
            break;
        case sKeepHolding8:
            result = @"Keep holding until \nyou reach $8";
            break;
        case sBusExmapleHeader:
            result = @"When you decide to take a \n$2 bus over a $10 cab...";
            break;
        case sBusTapAndHold:
            result = @"Tap and hold \nto keep the \n difference";
            break;
        case sBusCounterLabel:
            result = @"Everytime you \nrecord something in \nKeep you'll get to \nsee a new photo.";
            break;
        case sBusReleaseScreen:
            result = @"When the timer reaches \n the amount you Kept \nrelease the screen";
            break;
        case sUseKeepInstructions:
            result = @"Use Keep to record \neverytime you make a \ngood spending decision.";
            break;
        case sSetAGoal:
            result = @"Set a goal";
            break;    
}
    
    return result;
}

@end
