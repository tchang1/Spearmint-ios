//
//  RDPSavingEvent.m
//  SpearmintIOS
//
//  Created by Chang, Tony on 7/28/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPSavingEventModel.h"
#import "MTLValueTransformer.h"

@implementation RDPSavingEventModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    // model_property_name : json_field_name
    return @{
             @"amount" : @"savingsAmount",
             @"goalid" : @"goalid",
             @"savingid" : @"_id",
             @"deleted" : @"softDeleted",
             @"reason" : @"reason"
             };
}



- (id)init
{
    self = [super init];
    if (self) {
        self.amount = [[NSNumber alloc] initWithDouble:0];
        //self.reason = @"";
        //self.savingDate = [[NSDate alloc] init];
    }
    return self;
}

- (void)setAmount:(NSNumber *)amount
{
    if ([amount isKindOfClass:[NSString class]]) {
        _amount = [[RDPConfig numberFormatter] numberFromString:(NSString*)amount];
    }
    else {
        _amount = amount;
    }
}

-(void)setReason:(NSString *)reason
{
    if (!reason) {
        _reason = @"";
    }
    else {
        _reason = reason;
    }
}

@end
