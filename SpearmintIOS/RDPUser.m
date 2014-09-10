//
//  RDPCompleteUser.m
//  SpearmintIOS
//
//  Created by Matthew Ziegler on 8/6/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPUser.h"

@interface RDPUser()

@property (strong, nonatomic) NSString* userUsername;
@property (strong, nonatomic) NSString* userPassword;
@property (strong, nonatomic) RDPGoal* userGoal;
@property (nonatomic, assign) BOOL notifications;

@end

@implementation RDPUser

-(id)initWithUsername:(NSString*)username andPassword:(NSString*)password andGoal:(RDPGoal*)goal andNotificationsEnabled:(BOOL)notificationsEnabled
{
    self = [super init];
    if (self) {
        [self setUserUsername:username];
        [self setPassword:password];
        [self setGoal:goal];
        [self setNotificationsEnabled:notificationsEnabled];
    }
    return self;
}

-(NSString*)getPassword
{
    return self.userPassword;
}

-(RDPResponseCode)setPassword:(NSString *)password
{
    RDPResponseCode responseCode = RDPResponseCodeOK;
    if (!password) {
        responseCode = RDPErrorCodeNilObject;
    }
    else if (password.length < [[RDPConfig numberSettingForID:RDPSettingMinimumPasswordLength] integerValue] ||
             password.length > [[RDPConfig numberSettingForID:RDPSettingMaximumPasswordLength] integerValue]){
        responseCode = RDPErrorCodeInvalidPassword;
    }
    else {
        self.userPassword = password;
    }
    return responseCode;
}

-(NSString*)getUsername
{
    return self.userUsername;
}

-(RDPResponseCode)setUsername:(NSString *)username
{
    RDPResponseCode responseCode = RDPResponseCodeOK;
    if (!username) {
        responseCode = RDPErrorCodeNilObject;
    }
    else {
        NSString* regex = [RDPConfig stringSettingForID:RDPSettingEmailRegex];
        NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regex options:NSRegularExpressionCaseInsensitive error:nil];
        NSUInteger regExMatches = [regEx numberOfMatchesInString:username options:0 range:NSMakeRange(0, [username length])];
        
        if (regExMatches == 0) {
            responseCode = RDPErrorCodeInvalidUsername;
        } else {
            self.userUsername = username;
        }
    }
    return responseCode;
}

-(RDPGoal*)getGoal
{
    return self.userGoal;
}

-(RDPResponseCode)setGoal:(RDPGoal *)goal
{
    RDPResponseCode responseCode = RDPResponseCodeOK;
    if (!goal) {
        responseCode = RDPErrorCodeNilObject;
    }
    else {
        self.userGoal = goal;
    }
    return responseCode;
}

-(BOOL) isNotificationsEnabled
{
    UIUserNotificationSettings *currentSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
    
    if (currentSettings.types == UIUserNotificationTypeNone) {
        return NO;
    }
    else {
        return self.notifications;
    } 
}

-(RDPResponseCode) setNotificationsEnabled:(BOOL)enabled
{
    self.notifications = enabled;
    return RDPResponseCodeOK;
}

-(BOOL)isEqualToUser:(RDPUser*)other
{
    BOOL equal = YES;
    
    if (![self.userUsername isEqualToString:[other getUsername]]) {
        equal = NO;
    }
    if (![self.userPassword isEqualToString:[other userPassword]]) {
        equal = NO;
    }
    if (self.notifications != [other isNotificationsEnabled]) {
        equal = NO;
    }
    
    return equal;
}

-(RDPUser*)copy
{
    return [[RDPUser alloc] initWithUsername:[self.userUsername copy]
                                 andPassword:[self.userPassword copy]
                                     andGoal:[self.userGoal copy]
                     andNotificationsEnabled:self.notifications];
}

@end
