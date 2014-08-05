//
//  RDPSavingEvent.m
//  SpearmintIOS
//
//  Created by Chang, Tony on 7/28/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPSavingEvent.h"
#import "MTLValueTransformer.h"

@implementation RDPSavingEvent

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    // model_property_name : json_field_name
    return @{
             @"amount" : @"savingsAmount",
             @"goalid" : @"goalid",
             @"savingid" : @"_id"
             };
}



- (id)init
{
    self = [super init];
    if (self) {
        self.amount = [[NSDecimalNumber alloc] initWithString:@"0"];
        //self.reason = @"";
        //self.savingDate = [[NSDate alloc] init];
    }
    return self;
}
    
@end
