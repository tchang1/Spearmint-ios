//
//  RDPCongratulations.h
//  SpearmintIOS
//
//  Created by McElwain, Cori on 8/4/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RDPCongratulations : NSObject

@property (nonatomic, strong) NSString *congratsMessage;
@property (nonatomic, strong) NSArray *defaultMessages;

@property (atomic, assign) int defaultMessageIndex;

- (void)getNextCongratsMessage; 

@end
