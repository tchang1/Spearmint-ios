//
//  RDPGoal.m
//  SpearmintIOS
//
//  Created by Matthew Ziegler on 8/6/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPGoal.h"

@interface RDPGoal()

@property (strong, nonatomic) NSString* userGoalName;
@property (strong, nonatomic) NSNumber* userTargetAmount;
@property (strong, nonatomic) NSNumber* userCurrentAmount;
@property (strong, nonatomic) NSArray* userSavingEvents;

@end

@implementation RDPGoal

-(void)setEmptyState
{
    self.userGoalName = @"";
    self.userTargetAmount = [[NSNumber alloc] initWithDouble:0];
    self.userCurrentAmount = [[NSNumber alloc] initWithDouble:0];
    self.userSavingEvents = @[];
}

-(id)initWithName:(NSString*)name andTagetAmount:(NSNumber*)targetAmount andCurrentAmount:(NSNumber*)currentAmount andSavingEvents:(NSArray*)savingEvents andGoalID:(NSString*)goalID
{
    self = [super init];
    if (self) {
        [self setEmptyState];
        [self setGoalName:name];
        [self setTargetAmount:targetAmount];
        [self setCurrentAmount:currentAmount];
        [self setSavingEvents:savingEvents];
        _goalID = goalID;
    }
    return self;
}

-(id)init
{
    self = [super init];
    if (self) {
        [self setEmptyState];
    }
    return self;
}

-(NSArray*)userSavingEvents
{
    if (!_userSavingEvents){
        _userSavingEvents = [[NSArray alloc] init];
    }
    return _userSavingEvents;
}

-(NSString*)getGoalName
{
    return self.userGoalName;
}

-(RDPResponseCode)setGoalName:(NSString*)goalName
{
    RDPResponseCode responseCode = RDPResponseCodeOK;
    if (!goalName) {
        responseCode = RDPErrorCodeNilObject;
    }
    else if (goalName.length < [[RDPConfig numberSettingForID:RDPSettingMinimumGoalNameLength] integerValue] ||
             goalName.length > [[RDPConfig numberSettingForID:RDPSettingMaximumGoalNameLength] integerValue]) {
        responseCode = RDPErrorCodeInvalidGoalName;
    }
    else {
        self.userGoalName = goalName;
    }
    
    return responseCode;
}

-(NSNumber*)getTargetAmount
{
    return self.userTargetAmount;
}

-(RDPResponseCode)setTargetAmount:(NSNumber*)amount
{
    RDPResponseCode responseCode = RDPResponseCodeOK;
    if ([amount doubleValue] < 0)
    {
        responseCode = RDPErrorCodeNegativeAmount;
    }
    else {
        self.userTargetAmount = amount;
    }
    
    return responseCode;
}

-(NSNumber*)getCurrentAmount
{
    return self.userCurrentAmount;
}

-(RDPResponseCode)setCurrentAmount:(NSNumber*)amount
{
    RDPResponseCode responseCode = RDPResponseCodeOK;
    if ([amount doubleValue] < 0)
    {
        responseCode = RDPErrorCodeNegativeAmount;
    }
    else {
        self.userCurrentAmount = amount;
    }
    return responseCode;
}

-(NSArray*)getSavingEvents
{
    return self.userSavingEvents;
}

-(RDPResponseCode)setSavingEvents:(NSArray*)savingEvents
{
    RDPResponseCode responseCode = RDPResponseCodeOK;
    if (!savingEvents) {
        responseCode = RDPErrorCodeNilObject;
    }
    else {
        BOOL valid = YES;
        for (NSInteger i = 0; i < [savingEvents count]; i++) {
            if (![[savingEvents objectAtIndex:i] isKindOfClass:[RDPSavingEvent class]])
            {
                valid = NO;
                break;
            }
        }
        if (valid) {
            self.userSavingEvents = savingEvents;
        }
        else {
            responseCode = RDPErrorCodeObjectIsWrongType;
        }
    }
    return responseCode;
}

-(RDPResponseCode)addSavingEvent:(RDPSavingEvent*)savingEvent
{
    RDPResponseCode responseCode = RDPResponseCodeOK;
    if (!savingEvent)
    {
        responseCode = RDPErrorCodeNilObject;
    }
    else if (![savingEvent isKindOfClass:[RDPSavingEvent class]]) {
        responseCode = RDPErrorCodeObjectIsWrongType;
    }
    else {
        self.userSavingEvents = [self.userSavingEvents arrayByAddingObject:savingEvent];
    }
    return responseCode;
}

-(RDPGoal*)copy
{
    NSMutableArray* copyArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < [self.userSavingEvents count]; i++)
    {
        [copyArray addObject:[[self.userSavingEvents objectAtIndex:i] copy]];
    }
    return [[RDPGoal alloc] initWithName:[self.userGoalName copy]
                          andTagetAmount:[self.userTargetAmount copy]
                        andCurrentAmount:[self.userCurrentAmount copy]
                         andSavingEvents:[copyArray copy]
                               andGoalID:[self.goalID copy]];
}

@end
