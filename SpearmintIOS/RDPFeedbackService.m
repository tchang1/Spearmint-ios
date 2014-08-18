//
//  RDPFeedbackService.m
//  SpearmintIOS
//
//  Created by Ziegler, Matthew on 8/18/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPFeedbackService.h"
#import "RDPHTTPClient.h"

@implementation RDPFeedbackService

+(void)postFeedback:(NSString*)feedback
{
    // We don't actually care if the feedback was successful or not. Even if the feedback was unsuccessful we
    // want to show the success state to the user. 
    [[RDPHTTPClient sharedRDPHTTPClient] postFeedback:feedback withSuccess:^{
        
    } andFailure:^(NSError *error) {
        
    }];
}

@end
