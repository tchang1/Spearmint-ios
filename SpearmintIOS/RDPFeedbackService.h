//
//  RDPFeedbackService.h
//  SpearmintIOS
//
//  Created by Ziegler, Matthew on 8/18/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RDPFeedbackService : NSObject

+(void)postFeedback:(NSString*)feedback;

@end
