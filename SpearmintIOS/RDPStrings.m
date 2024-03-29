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
        case sPressAndHOldTheScreen:
            result = @"Tap and hold the screen";
            break;
        case sPressAndHold:
            result = @"Tap and hold \n anywhere to save";
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
            result = @"Thank you for the feedback! We are working hard to make Keep better.";
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
            result = [NSString stringWithFormat:@"When you decide to \n skip the %@ coffee that \n you usually buy...", [[RDPConfig numberFormatter] stringFromNumber:[NSNumber numberWithDouble:3]]];
            break;
        case sCoffeeTapAndHold:
            result = [NSString stringWithFormat:@"the screen to keep %@ for your goal", [[RDPConfig numberFormatter] stringFromNumber:[NSNumber numberWithDouble:3]]];
            break;
        case sCoffeeCounterLabel:
            result = [NSString stringWithFormat:@"When the timer reaches %@, \nrelease the screen.", [[RDPConfig numberFormatter] stringFromNumber:[NSNumber numberWithDouble:3]]];
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
            result = [NSString stringWithFormat:@"Keep holding until \nyou reach %@", [[RDPConfig numberFormatter] stringFromNumber:[NSNumber numberWithDouble:3]]];
            break;
        case sKeepHolding8:
            result = [NSString stringWithFormat:@"Keep holding until \nyou reach %@", [[RDPConfig numberFormatter] stringFromNumber:[NSNumber numberWithDouble:8]]];
            break;
        case sBusExmapleHeader:
            result = [NSString stringWithFormat:@"When you decide to take a \n%@ bus over a %@ cab...", [[RDPConfig numberFormatter] stringFromNumber:[NSNumber numberWithDouble:2]], [[RDPConfig numberFormatter] stringFromNumber:[NSNumber numberWithDouble:10]]];
            break;
        case sBusTapAndHold:
            result = @"anywhere to keep the difference";
            break;
        case sBusCounterLabel:
            result = @"Everytime you record something \nin Keep you'll see a new photo.";
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
            result = @"I kept %@ by...";
            break;
        case sSaveSome:
            result = @"It's your money, keep it!";
            break;
        case sRecord:
            result = @"Describe what you kept";
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
        case sLoginUnauthorized:
            result = @"Invalid credentials";
            break;
        case sLoginGeneralError:
            result = @"Error. Try again later";
            break;
        case sSignupUsernameError:
            result = @"Invalid email";
            break;
        case sSignupGeneralError:
            result = @"Unable to signup. Try later.";
            break;
        case sTapRecord:
            result = @"Tap to add description";
            break;
        case sWelcomeTitle:
            result = @"Welcome to Keep!";
            break;
        case sWelcomeMessage:
            result = @"\nWe want you to reach your goal as much as you do.\n \nTurn on notifications so we can help?";
            break;
        case sNoNotifications:
            result = @"No, thanks";
            break;
        case sYesNotifications:
            result = @"Yes";
            break;
        case sSignUpToSave:
            result = @"Sign up to start saving!";
            break;
        case sPrivacyPolicy:
            result = @"Privacy Policy";
            break;
        case slegalLinks:
            result = @"By tapping Sign up, you agree to our Terms of Service and Privacy Policy.";
            break;
        case sTermsOfService:
            result = @"Terms Of Service";
            break;
        case sThirdPartyNotices:
            result = @"Third Party Notices";
            break;
        
}
    
    return result;
}

@end
