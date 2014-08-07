//
//  RDPUser.m
//  SpearmintIOS
//
//  Created by Chang, Tony on 7/28/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPUserModel.h"

@implementation RDPUserModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    // model_property_name : json_field_name
    return @{
             @"username" : @"username",
             @"password" : @"password",
             @"notifications" : @"notifications"
             };
}

- (id)init
{
    self = [super init];
    if (self) {
        self.username = @"";
        self.password = @"";
        self.notifications = @YES ;
    }
    return self;
}

- (id)initWithName:(NSString *)username andPassword:(NSString *)password
{
    self = [super init];
    if (self) {
        self.username = username;
        self.password = password;
        self.notifications = @YES;
    }
    return self;
}


@end
