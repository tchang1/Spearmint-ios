//
//  RDPHTTPClient.m
//  SpearmintIOS
//
//  Created by Chang, Tony on 7/23/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPHTTPClient.h"
#import "RDPGoalModel.h"
#import "RDPUserModel.h"
#import "RDPJSONResponseSerializer.h"

static NSString * const APIURLString = @"http://moment-qa.intuitlabs.com/";
static NSString* const notificationsKey = @"notifications";
static NSString* const feedbackURL = @"/feedback";
static NSString* const feedbackKey = @"feedback";

@implementation RDPHTTPClient

+(RDPHTTPClient *)sharedRDPHTTPClient
{
    static RDPHTTPClient *_sharedRDPHTTPClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedRDPHTTPClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:APIURLString]];
    });
    
    return _sharedRDPHTTPClient;
    
}

-(instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (self) {
        self.responseSerializer = [RDPJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.responseSerializer.acceptableContentTypes = [self.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    }
    
    return self;

}

-(void)testGETHTTPRequest:(NSString *)path
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [self GET:path parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *response=(NSDictionary *) responseObject;
        NSError *error=nil;
        RDPGoalModel *goal=[MTLJSONAdapter modelOfClass:RDPGoalModel.class fromJSONDictionary:response error:&error];
        NSLog( @"%@", goal );

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"error");

    }];
    
}

-(void)testPOSTHTTPRequest:(NSString *)path
{
    NSDictionary *parameters = @{@"username": @"iostest@trykeep.com",
                                        @"password": @"test"};
    [self POST:@"login" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *response=(NSDictionary *) responseObject;
        NSLog( @"%@", response );


    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);

    }];
    
}

#pragma mark - USERS
-(void)loginWithUsername:(NSString *)username andPassword:(NSString *)password
{
    NSDictionary *parameters = @{@"username": username,
                                 @"password": password};
    [self POST:@"login" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *response=(NSDictionary *) responseObject;
        NSLog( @"%@", response );
        if ([self.delegate respondsToSelector:@selector(RDPHTTPClientDidLogIn)]) {
            [self.delegate RDPHTTPClientDidLogIn];
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
        
    }];
    
}

-(void)loginWithUsername:(NSString *)username andPassword:(NSString *)password andCompletionBlock:(completionBlock)block
andFailureBlock:(errorBlock)errorBlock
{
    NSDictionary *parameters = @{@"username": username,
                                 @"password": password};
    [self POST:@"login" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *response=(NSDictionary *) responseObject;
        NSLog( @"%@", response );
        block();
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
        errorBlock(error);
    }];
    
}

-(void)signupWithUsername:(NSString *)username andPassword:(NSString *)password andCompletionBlock:(completionBlock)block
         andFailureBlock:(errorBlock)errorBlock
{
    NSDictionary *parameters = @{@"username": username,
                                 @"password": password,
                                 @"notifications":@"Y"};
    [self POST:@"users" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *response=(NSDictionary *) responseObject;
        NSLog( @"%@", response );
        block();
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
        errorBlock(error);
    }];
}

-(void)getMyUserWithSuccess:(userModelBlock)block andFailure:(errorBlock)errorBlock
{
    [self GET:@"users/me" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *response=(NSDictionary *) responseObject;
        NSError *error=nil;
        RDPUserModel *user=[MTLJSONAdapter modelOfClass:RDPUserModel.class fromJSONDictionary:response error:&error];
        
        block(user);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
        errorBlock(error);
        
    }];
    
}


-(void)logoutWithCompletionBlock:(completionBlock)block andFailureBlock:(errorBlock)errorBlock
{

    [self GET:@"logoutWithoutRedirect" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        block();
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
        errorBlock(error);
    }

    ];
    
}

#pragma mark - GOALS

-(void)getMyGoal
{
    [self GET:@"goals/me" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *response=(NSDictionary *) responseObject;
        NSError *error=nil;
        RDPGoalModel *goal=[MTLJSONAdapter modelOfClass:RDPGoalModel.class fromJSONDictionary:response error:&error];
        if ([self.delegate respondsToSelector:@selector(RDPHTTPClient:didGetMyGoal:)]) {
            [self.delegate RDPHTTPClient:self didGetMyGoal:goal];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
        
    }];
    
}

-(void)updateMyGoal:(RDPGoalModel *)goal
{
    NSDictionary *reqparams=[MTLJSONAdapter JSONDictionaryFromModel:goal];
    [self PUT:@"goals/me" parameters:reqparams success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *response=(NSDictionary *) responseObject;
        NSLog( @"%@", response );
        
        if ([self.delegate respondsToSelector:@selector(RDPHTTPClientDidUpdateMyGoal)]) {
            [self.delegate RDPHTTPClientDidUpdateMyGoal];
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
    }];
}

-(void)postNewGoal:(RDPGoalModel *)goal
{
    NSDictionary *reqparams=[MTLJSONAdapter JSONDictionaryFromModel:goal];
    [self POST:@"goals" parameters:reqparams success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *response=(NSDictionary *) responseObject;
        NSLog( @"%@", response );
        NSError *error=nil;
        RDPGoalModel *returnedGoal=[MTLJSONAdapter modelOfClass:RDPGoalModel.class fromJSONDictionary:response error:&error];
        
        if ([self.delegate respondsToSelector:@selector(RDPHTTPClient:didPostNewGoal:)]) {
            [self.delegate RDPHTTPClient:self didPostNewGoal:returnedGoal];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
    }];
}

-(void)getMyGoalWithSuccess:(goalBlock)block andFailure:(errorBlock)errorBlock
{
    [self GET:@"goals/me" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *response=(NSDictionary *) responseObject;
        NSError *error=nil;
        RDPGoalModel *goal=[MTLJSONAdapter modelOfClass:RDPGoalModel.class fromJSONDictionary:response error:&error];
        
        block(goal);

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
        errorBlock(error);
        
    }];

}
-(void)updateMyGoal:(RDPGoalModel *)goal withSuccess:(completionBlock)block andFailure:(errorBlock)errorBlock
{
    NSDictionary *reqparams=[MTLJSONAdapter JSONDictionaryFromModel:goal];
    [self PUT:@"goals/me" parameters:reqparams success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *response=(NSDictionary *) responseObject;
        NSLog( @"%@", response );
        block();
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
    }];
}
-(void)postNewGoal:(RDPGoalModel *)goal withSuccess:(goalBlock)block andFailure:(errorBlock)errorBlock
{
    NSDictionary *reqparams=[MTLJSONAdapter JSONDictionaryFromModel:goal];
    [self POST:@"goals" parameters:reqparams success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *response=(NSDictionary *) responseObject;
        NSLog( @"%@", response );
        NSError *error=nil;
        RDPGoalModel *returnedGoal=[MTLJSONAdapter modelOfClass:RDPGoalModel.class fromJSONDictionary:response error:&error];
        
        block(returnedGoal);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
        errorBlock(error);
    }];
}

#pragma mark - SAVINGS

-(void)getMySavings
{
    [self getMySavingsWithSuccess:nil andFailure:nil];
}

-(void)postSavings:(RDPSavingEventModel *)savings
{
    NSDictionary *reqparams=[MTLJSONAdapter JSONDictionaryFromModel:savings];
    [self POST:@"savings" parameters:reqparams success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *response=(NSDictionary *) responseObject;
        NSLog( @"%@", response );
        if ([self.delegate respondsToSelector:@selector(RDPHTTPClient:didPostSavings:)]) {
            [self.delegate RDPHTTPClient:self didPostSavings:savings];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
    }];
}

-(void)updateSavings:(RDPSavingEventModel *)savings
{
    NSDictionary *reqparams=[MTLJSONAdapter JSONDictionaryFromModel:savings];
    [self PUT:@"savings" parameters:reqparams success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *response=(NSDictionary *) responseObject;
        NSLog( @"%@", response );
        if ([self.delegate respondsToSelector:@selector(RDPHTTPClient:didUpdateSavings:)]) {
            [self.delegate RDPHTTPClient:self didUpdateSavings:savings];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
    }];
}

-(void)getMySavingsWithSuccess:(arrayBlock)block andFailure:(errorBlock)errorBlock
{
    [self GET:@"savings/me" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *response= responseObject;
        NSError *error=nil;
        NSLog( @"%@", response );
        NSArray *savings = [MTLJSONAdapter modelsOfClass:RDPSavingEventModel.class fromJSONArray:response error:&error];
        NSLog( @"%@", savings );
        
        block(savings);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        errorBlock(error);
        NSLog(@"%@", error);
        
    }];
}
-(void)updateMySaving:(RDPSavingEventModel *)saving withSuccess:(completionBlock)block andFailure:(errorBlock)errorBlock
{
    NSDictionary *reqparams=[MTLJSONAdapter JSONDictionaryFromModel:saving];
    [self PUT:@"savings" parameters:reqparams success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *response=(NSDictionary *) responseObject;
        NSLog( @"%@", response );
        block();
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
        errorBlock(error);
    }];
}
-(void)postNewSaving:(RDPSavingEventModel *)saving withSuccess:(savingBlock)block andFailure:(errorBlock)errorBlock
{
    NSDictionary *reqparams=[MTLJSONAdapter JSONDictionaryFromModel:saving];
    [self POST:@"savings" parameters:reqparams success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *response=(NSDictionary *) responseObject;
        NSError *error=nil;
        NSLog( @"%@", response );
        RDPSavingEventModel *returnedSaving=[MTLJSONAdapter modelOfClass:RDPSavingEventModel.class fromJSONDictionary:response error:&error];
        block(returnedSaving);

        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
        errorBlock(error);
    }];
}


#pragma mark - NOTIFICATIONS

-(void)getMyNotificationsWithSuccess:(stringBlock)block andFailure:(errorBlock)errorBlock
{
    [self GET:@"notifications/me" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *response=(NSDictionary *) responseObject;
        NSString *notifications=[response objectForKey:@"notifications"];
            block(notifications);
        NSLog( @"%@", response );
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
        errorBlock(error);
        
    }];

    
}

-(void)updateNotificationsWithPreference:(NSString*)preference withSuccess:(completionBlock)block andFailure:(errorBlock)errorBlock
{
    NSDictionary* params = @{notificationsKey : preference};
    [self PUT:@"notifications/me" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *response=(NSDictionary *) responseObject;
        NSLog( @"%@", response );
        block();
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
        errorBlock(error);
    }];
}

#pragma mark - FEEDBACK

-(void)postFeedback:(NSString*)feedback withSuccess:(completionBlock)block andFailure:(errorBlock)errorBlock
{
    feedback = (!feedback) ? @"" : feedback;
    NSDictionary* params = @{feedbackKey : feedback};
    [self POST:feedbackURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *response=(NSDictionary *) responseObject;
        NSLog( @"%@", response );
        block();
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
        errorBlock(error);
    }];
}

#pragma mark - IMAGES

-(void)getNextImage
{
    NSDictionary *params = @{@"goalid":@"53d2bf28c5fb963e0717d8c8", @"categoryid":@"0"};
    [self GET:@"images/me" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *responseArray= responseObject;
        NSString *qaURL = @"http://moment-qa.intuitlabs.com/images/";
        NSURL *imageurl1 = [NSURL URLWithString:[qaURL stringByAppendingString:[responseArray[0] objectForKey:@"uri"]]];
        NSURL *imageurl2 = [NSURL URLWithString:[qaURL stringByAppendingString:[responseArray[1] objectForKey:@"uri"]]];
        NSArray *urlArray = @[imageurl1,imageurl2];
        if ([self.delegate respondsToSelector:@selector(RDPHTTPClient:didGetImageURLs:)]) {
            [self.delegate RDPHTTPClient:self didGetImageURLs:urlArray];
        }
        //NSLog( @"%@", urlArray );
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark - MESSAGES

-(void)getSuggestions:(NSNumber *)limit withSuccess:(arrayBlock)block andFailure:(errorBlock)errorBlock
{
    NSDictionary *param=@{@"limit":limit};
    [self GET:@"suggestions" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *response= responseObject;
        
        NSLog( @"%@", response );
        block(response);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
        errorBlock(error);
        
    }];
}


-(void)getCongratulations:(NSNumber *)limit withSuccess:(arrayBlock)block andFailure:(errorBlock)errorBlock
{
    NSDictionary *param=@{@"limit":limit};
    [self GET:@"congratulations" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *response= responseObject;
        
        NSLog( @"%@", response );
        block(response);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
        errorBlock(error);
        
    }];
}


@end
