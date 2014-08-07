//
//  RDPStrings.h
//  SpearnintIOS
//
//  Created by McElwain, Cori on 7/22/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    sPressAndHold,
    sSettings,
    sBack,
    sMyGoal,
    sNotificationSettings,
    sSubmitFeedback,
    sHistory,
    sRateTheApp,
    sLogout,
    sJustKept,
    sGoal,
    sAmount,
    sAmountSaved,
    sIWantTo,
    sDaily,
    sWeeklyReport,
    sWeekly,
    sWhenIReachMyGoal,
    sWhenIDontSaveForThreeDays,
    sEmail,
    sPushNotifications,
    sFeedback,
    sTypeFeedbackHere,
    sUndo,
    sSubmit,
    sSlogan,
    sCoffeeExampleHeader,
    sCoffeeTapAndHold,
    sCoffeeCounterLabel,
    sCoffeeReleaseScreen,
    sAddToGoalInstructions,
    sContinue,
    sLogin,
    SEmailPlaceholder,
    sPasswordPlaceholder,
    sEmailValidation,
    sPasswordValidation,
    sKeepHolding,
    sKeepHolding3,
    sKeepHolding8,
    sBusExmapleHeader,
    sBusTapAndHold,
    sBusCounterLabel,
    sBusReleaseScreen,
    sUseKeepInstructions,
    sSetAGoal,
} RDPStringID;

@interface RDPStrings : NSObject

+ (NSString *)stringForID:(RDPStringID)stringID;

@end
