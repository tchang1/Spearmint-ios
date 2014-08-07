//
//  RDPSavings.m
//  SpearmintIOS
//
//  Created by Matthew Ziegler on 8/6/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPSavingEvent.h"

@interface RDPSavingEvent()

@property (strong, nonatomic) NSNumber* savingAmount;
@property (strong, nonatomic) NSString* savingReason;

@end

@implementation RDPSavingEvent

-(RDPSavingEvent*)initWithAmount:(NSNumber*)amount
                       andReason:(NSString*)reason
                         andDate:(NSDate*)date
                     andLocation:(NSString*)location
                           andID:(NSString*)savingID
{
    self = [super init];
    if (self) {
        _savingID = savingID;
        _location = location;
        _date = date;
        [self setSavingAmount:amount];
        [self setReason:reason];
    }
    
    return self;
}

-(NSNumber*)getAmount {
    return self.savingAmount;
}

-(RDPResponseCode)setAmount:(NSNumber*)amount
{
    RDPResponseCode responseCode = RDPResponseCodeOK;
    
    if (!amount) {
        responseCode = RDPErrorCodeNilObject;
    }
    else if ([amount doubleValue] < 0) {
        responseCode = RDPErrorCodeNegativeAmount;
    }
    else {
        self.savingAmount = amount;
    }
    
    return responseCode;
}

-(NSString*)getReason
{
    return self.savingReason;
}

-(RDPResponseCode)setReason:(NSString*)reason
{
    RDPResponseCode responseCode = RDPResponseCodeOK;
    
    if (!reason) {
        responseCode = RDPErrorCodeNilObject;
    }
    else {
        self.savingReason = reason;
    }
    
    return responseCode;
}

-(void)deleteSavingEvent
{
    _deleted = YES;
}

-(BOOL)object:(id)myObject isEqualTo:(id)theirObject
{
    if (!myObject && theirObject) {
        return NO;
    }
    else if (myObject && !theirObject) {
        return NO;
    }
    else if (myObject && theirObject) {
        return [myObject isEqualToString:theirObject];
    }
    else {
        return YES;
    }
}

-(BOOL)isEqualTo:(RDPSavingEvent*)other
{
    BOOL isEqual = YES;
    @try {
        if (![self object:[self getAmount] isEqualTo:[other getAmount]]) {
            isEqual = NO;
        }
        if (![self object:[self getReason] isEqualTo:[other getReason]]) {
            isEqual = NO;
        }
        if (![self.date isEqualToDate:other.date]) {
            isEqual = NO;
        }
        if (![self.location isEqualToString:other.location]) {
            isEqual = NO;
        }
        if (self.deleted != other.deleted) {
            isEqual = NO;
        }
        
    }
    @catch (NSException * e) {
        isEqual = YES;
    }
    
    return isEqual;
}

-(RDPSavingEvent*)copy
{
    return [[RDPSavingEvent alloc] initWithAmount:[self.savingAmount copy]
                                        andReason:[self.savingReason copy]
                                          andDate:[self.date copy]
                                      andLocation:[self.location copy]
                                            andID:[self.savingID copy]];
}

@end
