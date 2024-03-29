//
//  RDPCompleteUser.h
//  SpearmintIOS
//
//  Created by Matthew Ziegler on 8/6/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RDPGoal.h"

@interface RDPUser : NSObject

-(id)initWithUsername:(NSString*)username andPassword:(NSString*)password andGoal:(RDPGoal*)goal andNotificationsEnabled:(BOOL)notificationsEnabled;

-(NSString*) getUsername;
-(RDPResponseCode) setUsername:(NSString*)username;
-(NSString*) getPassword;
-(RDPResponseCode) setPassword:(NSString*)password;
-(RDPGoal*) getGoal;
-(RDPResponseCode) setGoal:(RDPGoal*)goal;
-(BOOL) isNotificationsEnabled;
-(RDPResponseCode) setNotificationsEnabled:(BOOL)enabled;

-(BOOL)isEqualToUser:(RDPUser*)other;
-(RDPUser*) copy;

@end
