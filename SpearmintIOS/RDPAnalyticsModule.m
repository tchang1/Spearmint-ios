//
//  RDPAnalyticsModule.m
//  SpearmintIOS
//
//  Created by Chang, Tony on 8/12/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPAnalyticsModule.h"

@implementation RDPAnalyticsModule

static NSArray *_providers=nil;

+(void)initialize
{
    _providers=[[NSArray alloc] init];
}

+(void)initializeAnalyticsProviders:(NSArray *)providers
{
    _providers=providers;
}

+(void)track:(NSString *)eventName
{
    for (id<RDPAnalyticsProvider> provider in _providers) {
        [provider track:eventName];
    }
}

+(void)track:(NSString *)eventName properties:(NSDictionary *)map
{
    for (id<RDPAnalyticsProvider> provider in _providers) {
        [provider track:eventName properties:map];
    }
}

+(void)identifyProfile
{
    for (id<RDPAnalyticsProvider> provider in _providers) {
        [provider identifyProfile];
    }
}

+(void)setProfile:(NSDictionary *)properties
{
    for (id<RDPAnalyticsProvider> provider in _providers) {
        [provider setProfile:properties];
    }
}

+(void)incrementProfile:(NSDictionary *)properties
{
    for (id<RDPAnalyticsProvider> provider in _providers) {
        [provider incrementProfile:properties];
    }
}

@end
