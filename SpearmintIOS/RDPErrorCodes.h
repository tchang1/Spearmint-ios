//
//  RDPErrorCodes.h
//  SpearmintIOS
//
//  Created by Matthew Ziegler on 8/6/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    RDPResponseCodeOK,
    RDPErrorCodeUnknown,
    RDPErrorCodeNilObject,
    RDPErrorCodeInvalidPassword,
    RDPErrorCodeInvalidUsername,
    RDPErrorCodeInvalidGoalName,
    RDPErrorCodeNegativeAmount,
    RDPErrorCodeObjectIsWrongType
} RDPResponseCode;

@interface RDPErrorCodes : NSObject

@end
