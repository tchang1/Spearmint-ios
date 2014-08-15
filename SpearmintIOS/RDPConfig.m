//
//  RDPConfig.m
//  SpearmintIOS
//
//  Created by Matthew Ziegler on 8/6/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPConfig.h"

#define kSettingsFileName       @"settings"
#define kSettingsFileType       @"plist"

static NSDictionary* settings;
static NSNumberFormatter* numberFormatter;

@implementation RDPConfig

+(NSDictionary*)settings
{
    if (!settings) {
        NSString *path = [[NSBundle mainBundle] pathForResource:kSettingsFileName ofType:kSettingsFileType];
        settings = [[NSDictionary alloc] initWithContentsOfFile:path];
    }
    return settings;
}

+(id)settingForID:(RDPSettingID)settingID
{
    id setting;
    
    switch (settingID) {
        case RDPSettingEmailRegex:
            setting = [[RDPConfig settings] objectForKey:@"emailRegex"];
            break;
        case RDPSettingMaximumGoalNameLength:
            setting = [[RDPConfig settings] objectForKey:@"maximumGoalNameLength"];
            break;
        case RDPSettingMinimumGoalNameLength:
            setting = [[RDPConfig settings] objectForKey:@"minimumGoalNameLength"];
            break;
        case RDPSettingMaximumPasswordLength:
            setting = [[RDPConfig settings] objectForKey:@"maximumPasswordLength"];
            break;
        case RDPSettingMinimumPasswordLength:
            setting = [[RDPConfig settings] objectForKey:@"minimumPasswordLength"];
            break;
    }
    
    return setting;
}

+(NSString*)stringSettingForID:(RDPSettingID)settingID
{
    return (NSString*)[RDPConfig settingForID:settingID];
}

+(NSNumber*)numberSettingForID:(RDPSettingID)settingID
{
    return (NSNumber*)[RDPConfig settingForID:settingID];
}

+(NSNumberFormatter*)numberFormatter
{
    if (!numberFormatter) {
        numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [numberFormatter setMaximumFractionDigits:0];
    }
    return numberFormatter;
}

@end
