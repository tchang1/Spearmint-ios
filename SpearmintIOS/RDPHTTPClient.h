//
//  RDPHTTPClient.h
//  SpearmintIOS
//
//  Created by Chang, Tony on 7/23/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@protocol RDPHTTPClientDelegate;


@interface RDPHTTPClient : AFHTTPSessionManager

@property (nonatomic,weak) id<RDPHTTPClientDelegate>delegate;

+(RDPHTTPClient *)sharedRDPHTTPClient;
-(instancetype)initWithBaseURL:(NSURL *)url;
-(void)testGETHTTPRequest:(NSString *)path;
-(void)testPOSTHTTPRequest:(NSString *)path;
-(void)loginWithUsername:(NSString *)username andPassword:(NSString *)password;
-(void)getMyGoal;
-(void)getMySavings;
-(void)postSavings:(NSDictionary *)savings;
-(void)getMyNotifications;
-(void)updateNotifications:(NSDictionary *)params;
-(void)getNextImage;


@end

@protocol RDPHTTPClientDelegate <NSObject>

@optional
-(void)RDPHTTPClient:(RDPHTTPClient *)client didGetImageURLs:(NSArray *)images;

@end

