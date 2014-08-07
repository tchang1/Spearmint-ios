//
//  RDPSavings.h
//  SpearmintIOS
//
//  Created by Matthew Ziegler on 8/6/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RDPSavingEvent : NSObject

@property (strong, readonly, nonatomic) NSDate* date;
@property (strong, readonly, nonatomic) NSString* location;
@property (strong, readonly, nonatomic) NSString* savingID;
@property (readonly, nonatomic) BOOL deleted;

-(RDPSavingEvent*)initWithAmount:(NSNumber*)amount
                       andReason:(NSString*)reason
                         andDate:(NSDate*)date
                     andLocation:(NSString*)location
                           andID:(NSString*)savingID;

-(NSNumber*)getAmount;
-(RDPResponseCode)setAmount:(NSNumber*)amount;
-(NSString*)getReason;
-(RDPResponseCode)setReason:(NSString*)reason;
-(void)deleteSavingEvent;

-(BOOL)isEqualTo:(RDPSavingEvent*)other;

-(RDPSavingEvent*) copy;

@end
