//
//  RDPSavingEvent.h
//  SpearmintIOS
//
//  Created by Chang, Tony on 7/28/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "MTLModel.h"
#import "MTLJSONAdapter.h"


@interface RDPSavingEvent : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSDecimalNumber *amount;

@property (nonatomic, strong) NSString *reason;

@property (nonatomic, strong) NSDate *savingDate;

@end
