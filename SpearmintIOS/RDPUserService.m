//
//  RDPUserService.m
//  SpearmintIOS
//
//  Created by Matthew Ziegler on 8/6/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPUserService.h"
#import "RDPUser.h"
#import "RDPGoal.h"
#import "RDPSavingEvent.h"
#import "RDPUserModel.h"
#import "RDPGoalModel.h"
#import "RDPSavingEventModel.h"
#import "RDPHTTPClient.h"
#import "RDPAsyncProgressTracker.h"

static RDPUser* storedUser;

@implementation RDPUserService

+(RDPUser*)createUserObjectWithUsername:(NSString*)username andPassword:(NSString*)password andGoalModel:(RDPGoalModel*)goalModel andSavingEvents:(NSArray*)savingEventModels andNotifications:(BOOL)notifications
{
    RDPUser* user;
    RDPGoal* goal;
    NSMutableArray* savings = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < [savingEventModels count]; i++) {
        RDPSavingEventModel* savingEventModel = (RDPSavingEventModel*)[savingEventModels objectAtIndex:i];
        [savings addObject:[RDPUserService savingEventFromSavingEventModel:savingEventModel]];
    }
    
    goal = [RDPUserService goalFromGoalModel:goalModel andSavingEvents:savings];
    user = [[RDPUser alloc] initWithUsername:username andPassword:password andGoal:goal andNotificationsEnabled:notifications];
    
    return user;
}

+(RDPSavingEvent*)savingEventFromSavingEventModel:(RDPSavingEventModel*)savingEventModel
{
    unsigned long long result;
    [[NSScanner scannerWithString:[savingEventModel.savingid substringToIndex:8]] scanHexLongLong:&result];
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:result];
    RDPSavingEvent* savingEvent = [[RDPSavingEvent alloc] initWithAmount:savingEventModel.amount andReason:savingEventModel.reason andDate:date andLocation:@"" andID:savingEventModel.savingid];
    return savingEvent;
}

+(RDPGoal*)goalFromGoalModel:(RDPGoalModel*)goalModel andSavingEvents:(NSArray*)savingEvents{
    RDPGoal* goal = [[RDPGoal alloc] initWithName:goalModel.goalName andTagetAmount:goalModel.targetAmount andCurrentAmount:goalModel.amountSaved andSavingEvents:[savingEvents copy] andGoalID:goalModel.goalID];
    return goal;
}

+(void)constructUserFromUsername:(NSString*)username andPassword:(NSString*)password then:(userBlock)block failure:(responseBlock)fail
{
    [[RDPHTTPClient sharedRDPHTTPClient] getMyGoalWithSuccess:^(RDPGoalModel* goalModel){
        [[RDPHTTPClient sharedRDPHTTPClient] getMySavingsWithSuccess:^(NSArray* savingsModels) {
            if (!savingsModels) {
                savingsModels = [[NSArray alloc] init];
            }
            
            [[RDPHTTPClient sharedRDPHTTPClient] getMyNotificationsWithSuccess:^(NSString *notifications) {
                BOOL notificationsEnabled = NO;
                if ([notifications isEqualToString:@"Y"]) {
                    notificationsEnabled = YES;
                }
                block([RDPUserService createUserObjectWithUsername:username andPassword:password andGoalModel:goalModel andSavingEvents:savingsModels andNotifications:notificationsEnabled]);
            } andFailure:^(NSError *error) {
                fail([RDPUserService handleError:error]);
            }];
        }
        andFailure:^(NSError* error) {
            fail([RDPUserService handleError:error]);
        }];
    }
    andFailure:^(NSError* error){
        fail([RDPUserService handleError:error]);
    }];
}

+(void)createUserWithUsername:(NSString*)username andPassword:(NSString*)password andGoal:(RDPGoal*)goal then:(userBlock)completionBlock failure:(responseBlock)fail
{
    [[RDPHTTPClient sharedRDPHTTPClient] signupWithUsername:username andPassword:password andCompletionBlock:^{
        NSLog(@"signup to server completed");
        storedUser=[[RDPUser alloc]initWithUsername:username andPassword:password andGoal:nil andNotificationsEnabled:YES];

        [RDPUserService saveGoalModel:goal withResponse:^(RDPResponseCode code) {
            NSLog(@"save goal to server completed");
            completionBlock([storedUser copy]);
        }];
    } andFailureBlock:^(NSError *error) {
        fail([RDPUserService handleError:error]);
    }];
}

+(void)loginWithUsername:(NSString*)username andPassword:(NSString*)password then:(userBlock)completionBlock failure:(responseBlock)fail
{
    [[RDPHTTPClient sharedRDPHTTPClient] loginWithUsername:username andPassword:password andCompletionBlock:^{
        [RDPUserService constructUserFromUsername:username andPassword:password then:^(RDPUser* user) {
            storedUser = user;
            completionBlock([user copy]);
        } failure:^(RDPResponseCode failCode) {
            fail(failCode);
        }];
        
    }
    andFailureBlock:^(NSError* error){
        fail([RDPUserService handleError:error]);
    }];
}

+(void)loginWithCookie:(userBlock)completionBlock failure:(responseBlock)fail
{
    [[RDPHTTPClient sharedRDPHTTPClient] getMyUserWithSuccess:^(RDPUserModel *userModel) {
        [RDPUserService constructUserFromUsername:userModel.username andPassword:userModel.password then:^(RDPUser *user) {
            storedUser=user;
            completionBlock([user copy]);
        } failure:^(RDPResponseCode failCode) {
            fail(failCode);
        }];
    } andFailure:^(NSError *error) {
        fail([RDPUserService handleError:error]);
    }];
}

+(void)logoutWithResponse:(responseBlock)response
{
    storedUser = nil;
    [[RDPHTTPClient sharedRDPHTTPClient] logoutWithCompletionBlock:^{
        response(RDPResponseCodeOK);
    } andFailureBlock:^(NSError *error) {
        response(RDPErrorCodeUnknown);
    }];
}

+(RDPUser*)getUser
{
    return [storedUser copy];
}

+(void)asyncOperationFinishedWithCode:(RDPResponseCode)responseCode andTracker:(RDPAsyncProgressTracker*)progressTracker withUser:(RDPUser*)user andCallbackBlock:(responseBlock)block
{
    if (responseCode != RDPResponseCodeOK) {
        progressTracker.response = responseCode;
    }
    [progressTracker asyncOperationFinished];
    if ([progressTracker isComplete]) {
        if (progressTracker.response == RDPResponseCodeOK) {
            storedUser = user;
        }
        block(progressTracker.response);
    }
}

+(void)saveUser:(RDPUser*)user withResponse:(responseBlock)response
{
    BOOL userNeedsUpdating = NO;
    BOOL goalNeedsUpdating = YES;
    
    RDPAsyncProgressTracker* asyncProgressTracker = [[RDPAsyncProgressTracker alloc] init];
    asyncProgressTracker.response = RDPResponseCodeOK;
    
    if (![user isEqualToUser:storedUser]) {
        userNeedsUpdating = YES;
    }
    if (userNeedsUpdating) {
        [asyncProgressTracker addOperation];
        [RDPUserService saveUserModel:user withResponse:^(RDPResponseCode responseCode) {
            [RDPUserService asyncOperationFinishedWithCode:responseCode andTracker:asyncProgressTracker withUser:user andCallbackBlock:response];
        }];
    }
    
    //Check if goal needs updating
    if ([[[user getGoal] getCurrentAmount] isEqual: [[storedUser getGoal] getCurrentAmount]] &&
        [[[user getGoal] getTargetAmount] isEqual: [[storedUser getGoal] getTargetAmount]] &&
        [[[user getGoal] getGoalName] isEqualToString: [[storedUser getGoal] getGoalName]]) {
        goalNeedsUpdating = NO;
    }
    if (goalNeedsUpdating) {
        [asyncProgressTracker addOperation];
        [RDPUserService saveGoalModel:[user getGoal] withResponse:^(RDPResponseCode responseCode) {
            [RDPUserService asyncOperationFinishedWithCode:responseCode andTracker:asyncProgressTracker withUser:user andCallbackBlock:response];
        }];
    }
    
    NSMutableArray* savingEventsToUpdate = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < [[[user getGoal] getSavingEvents] count]; i++) {
        RDPSavingEvent* savingEvent = [[[user getGoal] getSavingEvents] objectAtIndex:i];
        if (savingEvent.savingID) {
            for (NSInteger j = 0; j < [[[storedUser getGoal] getSavingEvents] count]; j++) {
                RDPSavingEvent* storedSavingEvent = [[[storedUser getGoal] getSavingEvents] objectAtIndex:j];
                if (savingEvent.savingID && [storedSavingEvent.savingID isEqualToString:savingEvent.savingID]) {
                    if (![storedSavingEvent isEqualTo:savingEvent]) {
                        [savingEventsToUpdate addObject:savingEvent];
                    }
                }
            }
        }
        else {
            [savingEventsToUpdate addObject:savingEvent];
        }
    }
    
    for (NSInteger i = 0; i < [savingEventsToUpdate count]; i++) {
        [asyncProgressTracker addOperation];
        [RDPUserService saveSavingEvent:[savingEventsToUpdate objectAtIndex:i] withGoalID:[user getGoal].goalID forUser:user withResponse:^(RDPResponseCode responseCode) {
            [RDPUserService asyncOperationFinishedWithCode:responseCode andTracker:asyncProgressTracker withUser:user andCallbackBlock:response];
        }];
    }
}

+(void)saveUserModel:(RDPUser*)user withResponse:(responseBlock)response
{
    [[RDPHTTPClient sharedRDPHTTPClient] updateNotificationsWithPreference:([user isNotificationsEnabled]) ? @"Y" : @"N" withSuccess:^{
        response(RDPResponseCodeOK);
    } andFailure:^(NSError *error) {
        response([self handleError:error]);
    }];
    
}

+(void)saveGoalModel:(RDPGoal*)goal withResponse:(responseBlock)response
{
    RDPGoalModel* goalModel = [[RDPGoalModel alloc]init];
    goalModel.goalID = goal.goalID;
    goalModel.goalName = [goal getGoalName];
    goalModel.targetAmount = [NSDecimalNumber decimalNumberWithDecimal:[[goal getTargetAmount] decimalValue]];
    goalModel.amountSaved = [NSDecimalNumber decimalNumberWithDecimal:[[goal getCurrentAmount] decimalValue]];
    goalModel.isDefined = ([[goal getGoalName] isEqualToString:@""]) ? 1 : 0;
    if(goalModel.goalID) {
        [[RDPHTTPClient sharedRDPHTTPClient] updateMyGoal:goalModel withSuccess:^{
            response(RDPResponseCodeOK);
        } andFailure:^(NSError *error) {
            response([RDPUserService handleError:error]);
        }];
    }
    else {
        [[RDPHTTPClient sharedRDPHTTPClient] postNewGoal:goalModel withSuccess:^(RDPGoalModel *goalModel) {
            [storedUser setGoal:[RDPUserService goalFromGoalModel:goalModel andSavingEvents:@[]]];
            response(RDPResponseCodeOK);
        } andFailure:^(NSError *error) {
            response([RDPUserService handleError:error]);
        }];
    }
}

+(void)saveSavingEvent:(RDPSavingEvent*)savingEvent withGoalID:(NSString*)goalID forUser:(RDPUser*)user withResponse:(responseBlock)response
{
    RDPSavingEventModel* savingEventModel = [[RDPSavingEventModel alloc] init];
    savingEventModel.amount = [NSDecimalNumber decimalNumberWithDecimal:[[savingEvent getAmount] decimalValue]];
    savingEventModel.goalid = goalID;
    savingEventModel.savingid = savingEvent.savingID;
    savingEventModel.reason = [savingEvent getReason];
    savingEventModel.deleted = (savingEvent.deleted) ? @"T" : @"F";
    if (savingEventModel.savingid) {
        [[RDPHTTPClient sharedRDPHTTPClient] updateMySaving:savingEventModel withSuccess:^(void) {
            response(RDPResponseCodeOK);
            
        } andFailure:^(NSError *error) {
            response([RDPUserService handleError:error]);
        }];
    }
    else {
        [[RDPHTTPClient sharedRDPHTTPClient] postNewSaving:savingEventModel withSuccess:^(RDPSavingEventModel *savingEventModel) {
            NSMutableArray* newSavings = [[NSMutableArray alloc] initWithArray:[[user getGoal] getSavingEvents]];
            for (NSInteger j = 0; j < [newSavings count]; j++) {
                if ([newSavings objectAtIndex:j] == savingEvent) {
                    [newSavings removeObjectAtIndex:j];
                    [newSavings insertObject:[RDPUserService savingEventFromSavingEventModel:savingEventModel] atIndex:j];
                    [[user getGoal] setSavingEvents:[newSavings copy]];
                    break;
                }
            }
            response(RDPResponseCodeOK);
            
        } andFailure:^(NSError *error) {
            response([RDPUserService handleError:error]);
        }];
    }
    
}

+(RDPResponseCode)handleError:(NSError*)error {
    NSHTTPURLResponse *responseErrorData= [[error userInfo] objectForKey:@"com.alamofire.serialization.response.error.response"];
    NSInteger statusCode=[responseErrorData statusCode];
    NSDictionary *body=[[error userInfo] objectForKey:@"RDPJSONResponseSerializerWithDataKey"];
    
    switch (statusCode) {
        case 400:
        if ([[body objectForKey:@"error"] isEqualToString:@"Invalid username"])
        {
            return RDPErrorCodeInvalidUsername;
        }
        case 401:
        if ([[body objectForKey:@"result"] isEqualToString:@"loginFailed"])
        {
            return RDPErrorCodeUnauthorized;
        }

        break;
            
    }
    
    
    return RDPErrorCodeUnknown;
}

@end
