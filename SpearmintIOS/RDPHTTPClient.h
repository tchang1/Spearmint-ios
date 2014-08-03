//
//  RDPHTTPClient.h
//  SpearmintIOS
//
//  Created by Chang, Tony on 7/23/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "RDPGoal.h"
#import "RDPSavingEvent.h"

@protocol RDPHTTPClientDelegate;


@interface RDPHTTPClient : AFHTTPSessionManager

@property (nonatomic,weak) id<RDPHTTPClientDelegate>delegate;

+(RDPHTTPClient *)sharedRDPHTTPClient;
-(instancetype)initWithBaseURL:(NSURL *)url;
-(void)testGETHTTPRequest:(NSString *)path;
-(void)testPOSTHTTPRequest:(NSString *)path;
//User
-(void)loginWithUsername:(NSString *)username andPassword:(NSString *)password;
//Goals
-(void)getMyGoal;
-(void)updateMyGoal:(RDPGoal *)goal;
-(void)postNewGoal:(RDPGoal *)goal;
//Savings
-(void)getMySavings;
-(void)updateSavings:(RDPSavingEvent *)saving;
-(void)postSavings:(RDPSavingEvent *)saving;
//Notifications
-(void)getMyNotifications;
-(void)updateNotifications:(NSDictionary *)params;
//Images
-(void)getNextImage;


@end

@protocol RDPHTTPClientDelegate <NSObject>

@optional
-(void)RDPHTTPClient:(RDPHTTPClient *)client didGetImageURLs:(NSArray *)images;
-(void)RDPHTTPClient:(RDPHTTPClient *)client didGetMyGoal:(RDPGoal *)goal;
-(void)RDPHTTPClient:(RDPHTTPClient *)client didGetMySavings:(NSArray *)savings;
-(void)RDPHTTPClient:(RDPHTTPClient *)client did:(RDPGoal *)goal;



@end

