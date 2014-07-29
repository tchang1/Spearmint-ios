//
//  RDPSavingEvent.m
//  SpearmintIOS
//
//  Created by Chang, Tony on 7/28/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPSavingEvent.h"

@implementation RDPSavingEvent

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    // model_property_name : json_field_name
    return @{
             @"amount" : @"savingsAmount",
             @"reason" : @"reason",
             @"savingdate" : @"savingdate"
             };
}

- (id)init
{
    self = [super init];
    if (self) {
        self.amount = [NSDecimalNumber zero];;
        self.reason = @"";
        self.savingDate = [NSDate date] ;
    }
    return self;
}
    
@end
