//
//  RDPAsyncProgressTracker.h
//  SpearmintIOS
//
//  Created by Matthew Ziegler on 8/6/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RDPAsyncProgressTracker : NSObject

@property (nonatomic) NSInteger progress;
@property (nonatomic) NSInteger totalAsyncOperations;
@property (nonatomic) BOOL isComplete;
@property (nonatomic) RDPResponseCode response;

-(void)asyncOperationFinished;

-(void)addOperation;

@end
