//
//  RDPMixpanelAnalyticsProvider.m
//  SpearmintIOS
//
//  Created by Chang, Tony on 8/12/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPMixpanelAnalyticsProvider.h"
#import "Mixpanel.h"

@implementation RDPMixpanelAnalyticsProvider

- (id<RDPAnalyticsProvider>)init
{
    self = [super init];
    if (self) {
        [Mixpanel sharedInstanceWithToken:@"b133e5346052531eec04852182e9ad0f"];
    }
    return self;
}

-(void)track:(NSString *)eventName
{
    [[Mixpanel sharedInstance] track:eventName];
}

-(void)track:(NSString *)eventName properties:(NSDictionary *)map
{
    [[Mixpanel sharedInstance] track:eventName properties:map];
}

-(void)identifyProfile
{
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel identify: mixpanel.distinctId];
}

-(void)setProfile:(NSDictionary *)properties
{
    [[Mixpanel sharedInstance].people set:properties];
}

-(void)incrementProfile:(NSDictionary *)properties
{
    [[Mixpanel sharedInstance].people increment:properties];

}


@end
