//
//  RDPGoal.m
//  SpearnintIOS
//
//  Created by McElwain, Cori on 7/22/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPGoal.h"

@implementation RDPGoal

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    // model_property_name : json_field_name
    return @{
             @"goalID" : @"_id",
             @"goalName" : @"name",
             @"targetAmount" : @"targetAmount",
             @"amountSaved" : @"amountSaved"
             };
}

- (id)init
{
    self = [super init];
    if (self) {
        // Create an empty goal with target amount that is not a number
        self.goalName = @"";
        self.targetAmount = [NSDecimalNumber notANumber];
        self.amountSaved = [NSDecimalNumber zero];
    }
    return self;
}

- (id)initWithName:(NSString *)goalName andTarget:(NSDecimalNumber *)targetAmount
{
    self = [super init];
    if (self) {
        self.goalName = goalName;
        self.targetAmount = targetAmount;
        self.amountSaved = [NSDecimalNumber zero];
    }
    return self;
}

- (void)addToSavings:(NSDecimalNumber *)amount
{
    self.amountSaved = [self.amountSaved decimalNumberByAdding:amount];
}

@end
