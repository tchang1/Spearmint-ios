//
//  RDPValidationService.m
//  SpearmintIOS
//
//  Created by Chang, Tony on 8/7/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPValidationService.h"

@implementation RDPValidationService

+(BOOL)validateUsername:(NSString *)username {
    NSString *emailRegex=@"^[_a-z0-9-]+(\\.[_a-z0-9-]+)*@[a-z0-9-]+(\\.[a-z0-9-]+)*(\\.[a-z]{2,4})$";
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:emailRegex options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:username options:0 range:NSMakeRange(0, [username length])];
    
    NSLog(@"%lu", (unsigned long)regExMatches);
    if (regExMatches == 0) {
        return NO;
    } else {
        return YES;
    }
}

+(BOOL)validatePassword:(NSString *)password {
    return [password length]>=4;
}

@end
