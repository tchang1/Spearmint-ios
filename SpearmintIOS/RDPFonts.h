//
//  RDPFonts.h
//  SpearmintIOS
//
//  Created by Matthew Ziegler on 8/4/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    fMenuFont,
    fSectionHeaderFont,
    fNavigationHeaderFont,
    fNavigationButtonFont,
    fSmallText,
    fCurrencyFont,
    fLoginFont,
    fLoginPlaceholderFont,
    fReachGoalLine1,
    fReachGoalLine2,
    fLargeButtonFont,
    fNullStateFont
} RDPFontID;

@interface RDPFonts : NSObject

+(UIFont*)fontForID:(RDPFontID) fontID;

@end
