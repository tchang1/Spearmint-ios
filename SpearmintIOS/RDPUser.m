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

@end

@implementation RDPUser

-(id)initWithUsername:(NSString*)username andPassword:(NSString*)password andGoal:(RDPGoal*)goal
{
    self = [super init];
    if (self) {
        [self setUserUsername:username];
        [self setPassword:password];
        [self setGoal:goal];
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

-(RDPUser*)copy
{
    return [[RDPUser alloc] initWithUsername:[self.userUsername copy]
                                 andPassword:[self.userPassword copy]
                                     andGoal:[self.userGoal copy]];
}

@end
