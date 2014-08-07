//
//  RDPConfig.h
//  SpearmintIOS
//
//  Created by Matthew Ziegler on 8/6/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    RDPSettingMinimumPasswordLength,
    RDPSettingMaximumPasswordLength,
    RDPSettingEmailRegex,
    RDPSettingMinimumGoalNameLength,
    RDPSettingMaximumGoalNameLength
} RDPSettingID;

@interface RDPConfig : NSObject

+(id)settingForID:(RDPSettingID)settingID;
+(NSString*)stringSettingForID:(RDPSettingID)settingID;
+(NSNumber*)numberSettingForID:(RDPSettingID)settingID;

@end
