//
//  RDPUser.h
//  SpearmintIOS
//
//  Created by Chang, Tony on 7/28/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "MTLModel.h"
#import "MTLJSONAdapter.h"


@interface RDPUser : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *username;

@property (nonatomic, strong) NSString *password;

@property (nonatomic, strong) NSNumber *notifications;

- (id)initWithName:(NSString *)username andPassword:(NSString *)password;


@end
