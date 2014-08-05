//
//  RDPFonts.m
//  SpearmintIOS
//
//  Created by Matthew Ziegler on 8/4/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPFonts.h"

@implementation RDPFonts

+(UIFont*)fontForID:(RDPFontID) fontID
{
    UIFont* font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    switch(fontID) {
        case fMenuFont:
            font = [UIFont fontWithName:@"Helvetica-Light" size:16];
            break;
        case fSectionHeaderFont:
            font = [UIFont fontWithName:@"Helvetica" size:12];
            break;
        case fNavigationHeaderFont:
            font = [UIFont fontWithName:@"Helvetica-Light" size:16];
            break;
        case fNavigationButtonFont:
            font = [UIFont fontWithName:@"Helvetica-Light" size:14];
            break;
        case fSmallText:
            font = [UIFont fontWithName:@"Helvetica-Light" size:10];
            break;
        case fCurrencyFont:
            font = [UIFont fontWithName:@"Helvetica-Light" size:20];
            break;
    }
    
    return font;
}

@end
