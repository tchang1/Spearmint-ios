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
        case sPressAndHoldOnly:
            result = @"Tap and hold";
            break;
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
        case sNext:
            result = @"Next";
            break;
        case sHistory:
            result = @"History";
            break;
        case sToday:
            result = @"Today";
            break;
        case sYesterday:
            result = @"Yesterday";
            break;
        case sMonday:
            result = @"Monday";
            break;
        case sTuesday:
            result = @"Tuesday";
            break;
        case sWednesday:
            result = @"Wednesday";
            break;
        case sThursday:
            result = @"Thursday";
            break;
        case sFriday:
            result = @"Friday";
            break;
        case sSaturday:
            result = @"Saturday";
            break;
        case sSunday:
            result = @"Sunday";
            break;
        case sLastWeek:
            result = @"Last Week";
            break;
        case sTwoWeeksAgo:
            result = @"Two Weeks Ago";
            break;
        case sThreeWeeksAgo:
            result = @"Three Weeks Ago";
            break;
        case sLastMonth:
            result = @"Last Month";
            break;
        case sJanuary:
            result = @"January";
            break;
        case sFebruary:
            result = @"February";
            break;
        case sMarch:
            result = @"March";
            break;
        case sApril:
            result = @"April";
            break;
        case sMay:
            result = @"May";
            break;
        case sJune:
            result = @"June";
            break;
        case sJuly:
            result = @"July";
            break;
        case sAugust:
            result = @"August";
            break;
        case sSeptember:
            result = @"September";
            break;
        case sOctober:
            result = @"October";
            break;
        case sNovember:
            result = @"November";
            break;
        case sDecember:
            result = @"December";
            break;
        case sLastYear:
            result = @"Last Year";
            break;
        case sOlder:
            result = @"Older";
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
            result = @"Daily Notifications";
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
            result = @"FEEDBACK";
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
            result = @"to keep the $3 \nfor your goal instead";
            break;
        case sCoffeeCounterLabel:
            result = @"When the timer reaches $3, \nrelease the screen.";
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
            result = @"to keep the \n difference";
            break;
        case sBusCounterLabel:
            result = @"Everytime you record something \nin Keep you'll get to see a new photo.";
            break;
        case sBusReleaseScreen:
            result = @"When the timer reaches \n the amount you Kept \nrelease the screen.";
            break;
        case sUseKeepInstructions:
            result = @"Use Keep to record \neverytime you make a \ngood spending decision.";
            break;
        case sSetAGoal:
            result = @"Set a goal";
            break;
        case sGoalAmount:
            result = @"Goal Amount";
            break;
        case sIwant:
            result = @"I want to...";
            break;
        case sWillCost:
            result = @"This will cost..";
            break;
        case sVacation:
            result = @"Go on\n vacation";
            break;
        case sDebt:
            result = @"Pay off\n debt";
            break;
        case sRainy:
            result = @"Rainy day\n fund";
            break;
        case sComputer:
            result = @"Buy a\n computer";
            break;
        case sWeekend:
            result = @"Weekend\n away";
            break;
        case sSchool:
            result = @"Textbooks";
            break;
        case sReleaseMessage1:
            result = @"Release the screen";
            break;
        case sReleaseMessage2:
            result = @"When the timer reaches\n the amount you Kept\n release the screen";
            break;
        case sGoalCaps:
            result = @"GOAL ";
            break;
        case sKeptCaps:
            result = @"KEPT ";
            break;
        case sSavedBy:
            result = @"I saved %@ by...";
            break;
        case sSaveSome:
            result = @"It's your money, keep it!";
            break;
        case sRecord:
            result = @"Record what you kept";
            break;
        case sLoading:
            result = @"Verifying User...";
            break;
        case sReachedGoalLine1:
            result = @"You made it!";
            break;
        case sReachedGoalLine2:
            result = @"Go enjoy it.";
            break;
        case sReachedGoalButtonText:
            result = @"Set another goal";
            break;
        case sMyProgressNullState:
            result = @"You haven't kept anything yet...";
            break;
}
    
    return result;
}

@end
