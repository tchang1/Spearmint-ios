//
//  RDPCongratulations.m
//  SpearmintIOS
//
//  Created by McElwain, Cori on 8/4/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPCongratulations.h"
#import "RDPHTTPClient.h"

NSString * const kCongrats1 = @"Amazing!";
NSString * const kCongrats2 = @"Exceptional!";
NSString * const kCongrats3 = @"Unbelievable!";
NSString * const kCongrats4 = @"Truly amazing!";
NSString * const kCongrats5 = @"Great work!";

@implementation RDPCongratulations

- (NSString *)congratsMessage
{
    if (_congratsMessage != nil) {
        return _congratsMessage;
    }
    
    _defaultMessageIndex = 0;
    
    NSString *message;
    
    // Get a message from the server
    BOOL success = NO;
    if (success) { // TODO: have success be dependant on return from server
        // TODO: get message
    } else {
        message = self.defaultMessages[_defaultMessageIndex];
    }
    
    return message;
}

- (NSArray *)defaultMessages
{
    if (_defaultMessages != nil) {
        return _defaultMessages;
    }
    
    return @[kCongrats1, kCongrats2, kCongrats3, kCongrats4, kCongrats5];
}

- (void)getNextCongratsMessage
{
    // Get a message from the server
    BOOL success = NO;
    if (success) { // TODO: have success be dependant on return from server
        // TODO: get message
    } else {
        self.defaultMessageIndex = (self.defaultMessageIndex + 1) % 5;
        self.congratsMessage = self.defaultMessages[self.defaultMessageIndex];
    }
}

@end
