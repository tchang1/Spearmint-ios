//
//  RDPHTTPClient.h
//  SpearmintIOS
//
//  Created by Chang, Tony on 7/23/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "RDPGoalModel.h"
#import "RDPUserModel.h"
#import "RDPSavingEventModel.h"
#import "RDPUserModel.h"

typedef void (^completionBlock)(void);
typedef void (^errorBlock)(NSError*);
typedef void (^goalBlock)(RDPGoalModel*);
typedef void (^userModelBlock)(RDPUserModel*);
typedef void (^arrayBlock)(NSArray*);
typedef void (^savingBlock)(RDPSavingEventModel*);
typedef void (^stringBlock)(NSString*);



@protocol RDPHTTPClientDelegate;


@interface RDPHTTPClient : AFHTTPSessionManager

@property (nonatomic,weak) id<RDPHTTPClientDelegate>delegate;

+(RDPHTTPClient *)sharedRDPHTTPClient;
-(instancetype)initWithBaseURL:(NSURL *)url;
//-(void)testGETHTTPRequest:(NSString *)path;
//Logs in with a test account
//-(void)testPOSTHTTPRequest:(NSString *)path;
//User
//-(void)loginWithUsername:(NSString *)username andPassword:(NSString *)password;
-(void)loginWithUsername:(NSString *)username andPassword:(NSString *)password andCompletionBlock:(completionBlock)block andFailureBlock:(errorBlock)errorBlock;
-(void)signupWithUsername:(NSString *)username andPassword:(NSString *)password andCompletionBlock:(completionBlock)block andFailureBlock:(errorBlock)errorBlock;
-(void)getMyUserWithSuccess:(userModelBlock)block andFailure:(errorBlock)errorBlock;
-(void)logoutWithCompletionBlock:(completionBlock)block andFailureBlock:(errorBlock)errorBlock;

//Goals
/*
-(void)getMyGoal;
-(void)updateMyGoal:(RDPGoalModel *)goal;
-(void)postNewGoal:(RDPGoalModel *)goal;
*/
-(void)getMyGoalWithSuccess:(goalBlock)block andFailure:(errorBlock)errorBlock;
-(void)updateMyGoal:(RDPGoalModel *)goal withSuccess:(completionBlock)block andFailure:(errorBlock)errorBlock;
-(void)postNewGoal:(RDPGoalModel *)goal withSuccess:(goalBlock)block andFailure:(errorBlock)errorBlock;

//Savings
-(void)getMySavings;
//-(void)updateSavings:(RDPSavingEventModel *)saving;
//-(void)postSavings:(RDPSavingEventModel *)saving;

-(void)getMySavingsWithSuccess:(arrayBlock)block andFailure:(errorBlock)errorBlock;
-(void)updateMySaving:(RDPSavingEventModel *)saving withSuccess:(completionBlock)block andFailure:(errorBlock)errorBlock;
-(void)postNewSaving:(RDPSavingEventModel *)goal withSuccess:(savingBlock)block andFailure:(errorBlock)errorBlock;

//Notifications
-(void)getMyNotificationsWithSuccess:(stringBlock)block andFailure:(errorBlock)errorBlock;
-(void)updateNotificationsWithPreference:(NSString*)preference withSuccess:(completionBlock)block andFailure:(errorBlock)error;

//-(void)getMyNotificationsWithSuccess;

//Images
-(void)getNextImage:(NSString *)goalid;
//-(void)getNextImageWithSuccess:(arrayBlock)imageURLs andFailure:(errorBlock)errorBlock;

//Messages
-(void)getSuggestions:(NSNumber *)limit withSuccess:(arrayBlock)block andFailure:(errorBlock)errorBlock;
-(void)getCongratulations:(NSNumber *)limit withSuccess:(arrayBlock)block andFailure:(errorBlock)errorBlock;

//Feedback
-(void)postFeedback:(NSString*)feedback withSuccess:(completionBlock)block andFailure:(errorBlock)errorBlock;



@end

@protocol RDPHTTPClientDelegate <NSObject>

@optional
-(void)RDPHTTPClientDidLogIn;


-(void)RDPHTTPClient:(RDPHTTPClient *)client didGetImageURLs:(NSArray *)images;
-(void)RDPHTTPClient:(RDPHTTPClient *)client didGetMyGoal:(RDPGoalModel *)goal;
-(void)RDPHTTPClient:(RDPHTTPClient *)client didPostNewGoal:(RDPGoalModel *)goal;
-(void)RDPHTTPClientDidUpdateMyGoal;


-(void)RDPHTTPClient:(RDPHTTPClient *)client didGetMySavings:(NSArray *)savings;
-(void)RDPHTTPClient:(RDPHTTPClient *)client didPostSavings:(RDPSavingEventModel *)saving;
-(void)RDPHTTPClient:(RDPHTTPClient *)client didUpdateSavings:(RDPSavingEventModel *)saving;


-(void)RDPHTTPClientDidReceiveNotAuthorizedResponse;


@end

