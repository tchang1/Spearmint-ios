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

typedef void (^completionBlock)(void);
typedef void (^errorBlock)(NSError*);
typedef void (^goalBlock)(RDPGoal*);
typedef void (^arrayBlock)(NSArray*);
typedef void (^savingBlock)(RDPSavingEvent*);


@protocol RDPHTTPClientDelegate;


@interface RDPHTTPClient : AFHTTPSessionManager

@property (nonatomic,weak) id<RDPHTTPClientDelegate>delegate;

+(RDPHTTPClient *)sharedRDPHTTPClient;
-(instancetype)initWithBaseURL:(NSURL *)url;
-(void)testGETHTTPRequest:(NSString *)path;
//Logs in with a test account
-(void)testPOSTHTTPRequest:(NSString *)path;
//User
-(void)loginWithUsername:(NSString *)username andPassword:(NSString *)password;
-(void)loginWithUsername:(NSString *)username andPassword:(NSString *)password andCompletionBlock:(completionBlock)block andFailureBlock:(errorBlock)errorBlock;
-(void)logout;
-(void)logoutWithCompletionBlock:(completionBlock)block andFailureBlock:(errorBlock)errorBlock;

//Goals
-(void)getMyGoal;
-(void)updateMyGoal:(RDPGoal *)goal;
-(void)postNewGoal:(RDPGoal *)goal;

-(void)getMyGoalWithSuccess:(goalBlock)block andFailure:(errorBlock)errorBlock;
-(void)updateMyGoal:(RDPGoal *)goal withSuccess:(completionBlock)block andFailure:(errorBlock)errorBlock;
-(void)postNewGoal:(RDPGoal *)goal withSuccess:(goalBlock)block andFailure:(errorBlock)errorBlock;

//Savings
-(void)getMySavings;
-(void)updateSavings:(RDPSavingEvent *)saving;
-(void)postSavings:(RDPSavingEvent *)saving;

-(void)getMySavingsWithSuccess:(arrayBlock)block andFailure:(errorBlock)errorBlock;
-(void)updateMySaving:(RDPSavingEvent *)saving withSuccess:(completionBlock)block andFailure:(errorBlock)errorBlock;
-(void)postNewSaving:(RDPSavingEvent *)goal withSuccess:(savingBlock)block andFailure:(errorBlock)errorBlock;

//Notifications
-(void)getMyNotifications;
-(void)updateNotifications:(NSDictionary *)params;

-(void)getMyNotificationsWithSuccess;

//Images
-(void)getNextImage;
-(void)getNextImageWithSuccess:(arrayBlock)imageURLs andFailure:(errorBlock)errorBlock;



@end

@protocol RDPHTTPClientDelegate <NSObject>

@optional
-(void)RDPHTTPClientDidLogOut;
-(void)RDPHTTPClientDidLogIn;


-(void)RDPHTTPClient:(RDPHTTPClient *)client didGetImageURLs:(NSArray *)images;
-(void)RDPHTTPClient:(RDPHTTPClient *)client didGetMyGoal:(RDPGoal *)goal;
-(void)RDPHTTPClient:(RDPHTTPClient *)client didPostNewGoal:(RDPGoal *)goal;
-(void)RDPHTTPClientDidUpdateMyGoal;


-(void)RDPHTTPClient:(RDPHTTPClient *)client didGetMySavings:(NSArray *)savings;
-(void)RDPHTTPClient:(RDPHTTPClient *)client didPostSavings:(RDPSavingEvent *)saving;
-(void)RDPHTTPClient:(RDPHTTPClient *)client didUpdateSavings:(RDPSavingEvent *)saving;


-(void)RDPHTTPClientDidReceiveNotAuthorizedResponse;


@end

