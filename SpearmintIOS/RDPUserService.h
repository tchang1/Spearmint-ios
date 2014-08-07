//
//  RDPUserService.h
//  SpearmintIOS
//
//  Created by Matthew Ziegler on 8/6/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RDPUser.h"

typedef void(^userBlock)(RDPUser*);
typedef void(^responseBlock)(RDPResponseCode);

@interface RDPUserService : NSObject

+(void)createUserWithUsername:(NSString*)username andPassword:(NSString*)password then:(userBlock)completionBlock failure:(responseBlock)fail;

+(void)loginWithUsername:(NSString*)username andPassword:(NSString*)password then:(userBlock)completionBlock failure:(responseBlock)fail;

+(void)logoutWithResponse:(responseBlock)response;

+(RDPUser*)getUser;

+(void)saveUser:(RDPUser*)user withResponse:(responseBlock)response;

@end
