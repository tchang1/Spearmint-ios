//
//  RDPValidationService.h
//  SpearmintIOS
//
//  Created by Chang, Tony on 8/7/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RDPValidationService : NSObject


+(BOOL)validateUsername:(NSString *)username;
+(BOOL)validatePassword:(NSString *)password;

@end
