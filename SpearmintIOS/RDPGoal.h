//
//  RDPGoal.h
//  SpearnintIOS
//
//  Created by McElwain, Cori on 7/22/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RDPGoal : NSObject

@property (nonatomic, strong) NSString *goalName;

@property (nonatomic, strong) NSDecimalNumber *targetAmount;

@property (nonatomic, strong) NSDecimalNumber *amountSaved;

- (id)initWithName:(NSString *)goalName andTarget:(NSDecimalNumber *)targetAmount;

// Adds the specified amount to the amount saved so far for this goal
- (void)addToSavings:(NSDecimalNumber *)amount;

@end
