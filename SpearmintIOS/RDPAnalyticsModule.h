//
//  RDPAnalyticsModule.h
//  SpearmintIOS
//
//  Created by Chang, Tony on 8/12/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RDPAnalyticsModule : NSObject

+(void)initializeAnalyticsProviders:(NSArray *)providers;

+(void)track:(NSString *)eventName;

+(void)track:(NSString *)eventName properties:(NSDictionary *)map;

+(void)identifyProfile;

+(void)setProfile:(NSDictionary *)properties;

+(void)incrementProfile:(NSDictionary *)properties;


@end

@protocol RDPAnalyticsProvider <NSObject>


-(void)track:(NSString *)eventName;

-(void)track:(NSString *)eventName properties:(NSDictionary *)map;

-(void)identifyProfile;

-(void)setProfile:(NSDictionary *)properties;

-(void)incrementProfile:(NSDictionary *)properties;

@end
