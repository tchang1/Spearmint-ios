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

- (id)init
{
    self = [super init];
    if (self) {
        self.congratsMessage = @"";
        self.defaultMessageIndex = 0;
    }
    return self;
}

- (NSString *)congratsMessage
{
    if (_congratsMessage != nil) {
        return _congratsMessage;
    }
    
    else return self.defaultMessages[_defaultMessageIndex];

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
    RDPHTTPClient *client = [RDPHTTPClient sharedRDPHTTPClient];
    // Get a message from the server
    [client getCongratulations:@1 withSuccess:^(NSArray *congrats) {
        self.congratsMessage=congrats[0];
    } andFailure:^(NSError *error) {
        self.defaultMessageIndex = (self.defaultMessageIndex + 1) % 5;
        self.congratsMessage = self.defaultMessages[self.defaultMessageIndex];
    }];

}

@end
