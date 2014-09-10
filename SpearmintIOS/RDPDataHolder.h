//
//  RDPDataHolder.h
//  SpearmintIOS
//
//  Created by McElwain, Cori on 8/14/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RDPViewController.h"

@interface RDPDataHolder : NSObject

// Bool and amount for whether user has saved recently in the app
@property (nonatomic, assign) BOOL hasJustSaved;
@property (nonatomic, strong) NSNumber *amountJustSaved;
@property (nonatomic, assign) BOOL reachedGoal;
@property (nonatomic, weak) RDPViewController* homeController;
@property (nonatomic, assign) BOOL firstTime; 

+ (RDPDataHolder *)getDataHolder;

@end
