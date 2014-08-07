//
//  RDPGoal.h
//  SpearmintIOS
//
//  Created by Matthew Ziegler on 8/6/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RDPSavingEvent.h"

@interface RDPGoal : NSObject

@property (strong, nonatomic, readonly)NSString* goalID;

-(id)initWithName:(NSString*)name andTagetAmount:(NSNumber*)targetAmount andCurrentAmount:(NSNumber*)currentAmount andSavingEvents:(NSArray*)savingEvents andGoalID:(NSString*)goalID;

-(NSString*)getGoalName;
-(RDPResponseCode)setGoalName:(NSString*)goalName;
-(NSNumber*)getTargetAmount;
-(RDPResponseCode)setTargetAmount:(NSNumber*)amount;
-(NSNumber*)getCurrentAmount;
-(RDPResponseCode)setCurrentAmount:(NSNumber*)amount;
-(NSArray*)getSavingEvents;
-(RDPResponseCode)setSavingEvents:(NSArray*)savingEvents;
-(RDPResponseCode)addSavingEvent:(RDPSavingEvent*)savingEvent;

-(id)copy;

@end
