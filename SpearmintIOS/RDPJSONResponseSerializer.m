//
//  RDPJSONResponseSerializer.m
//  SpearmintIOS
//
//  Created by Chang, Tony on 8/3/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPJSONResponseSerializer.h"


@implementation RDPJSONResponseSerializer

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
	id JSONObject = [super responseObjectForResponse:response data:data error:error];
	if (*error != nil) {
		NSMutableDictionary *userInfo = [(*error).userInfo mutableCopy];
		if (data == nil) {
            //			// NOTE: You might want to convert data to a string here too, up to you.
            			userInfo[RDPJSONResponseSerializerWithDataKey] = @"";
			userInfo[RDPJSONResponseSerializerKey] = [NSData data];
		} else {
            //			// NOTE: You might want to convert data to a string here too, up to you.
            userInfo[RDPJSONResponseSerializerWithDataKey] = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
			userInfo[RDPJSONResponseSerializerKey] = data;
		}
		NSError *newError = [NSError errorWithDomain:(*error).domain code:(*error).code userInfo:userInfo];
		(*error) = newError;
	}
    
	return (JSONObject);
}

@end
