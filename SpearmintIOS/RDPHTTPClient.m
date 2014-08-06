//
//  RDPHTTPClient.m
//  SpearmintIOS
//
//  Created by Chang, Tony on 7/23/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPHTTPClient.h"
#import "RDPGoal.h"
#import "RDPJSONResponseSerializer.h"

static NSString * const APIURLString = @"http://moment-qa.intuitlabs.com/";

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
    }
    
    return self;

}

-(void)testGETHTTPRequest:(NSString *)path
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [self GET:path parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *response=(NSDictionary *) responseObject;
        NSError *error=nil;
        RDPGoal *goal=[MTLJSONAdapter modelOfClass:RDPGoal.class fromJSONDictionary:response error:&error];
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

-(void)logout
{

    [self GET:@"logoutWithoutRedirect" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self.delegate respondsToSelector:@selector(RDPHTTPClientDidLogOut)]) {
            [self.delegate RDPHTTPClientDidLogOut];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
    }

    ];
    
}

#pragma mark - GOALS

-(void)getMyGoal
{
    [self GET:@"goals/me" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *response=(NSDictionary *) responseObject;
        NSError *error=nil;
        RDPGoal *goal=[MTLJSONAdapter modelOfClass:RDPGoal.class fromJSONDictionary:response error:&error];
        if ([self.delegate respondsToSelector:@selector(RDPHTTPClient:didGetMyGoal:)]) {
            [self.delegate RDPHTTPClient:self didGetMyGoal:goal];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
        
    }];
    
}

-(void)updateMyGoal:(RDPGoal *)goal
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

-(void)postNewGoal:(RDPGoal *)goal
{
    NSDictionary *reqparams=[MTLJSONAdapter JSONDictionaryFromModel:goal];
    [self POST:@"goals" parameters:reqparams success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *response=(NSDictionary *) responseObject;
        NSLog( @"%@", response );
        NSError *error=nil;
        RDPGoal *returnedGoal=[MTLJSONAdapter modelOfClass:RDPGoal.class fromJSONDictionary:response error:&error];
        
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
        RDPGoal *goal=[MTLJSONAdapter modelOfClass:RDPGoal.class fromJSONDictionary:response error:&error];
        
        block(goal);

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
        errorBlock(error);
        
    }];

}
-(void)updateMyGoal:(RDPGoal *)goal withSuccess:(completionBlock)block andFailure:(errorBlock)errorBlock
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
-(void)postNewGoal:(RDPGoal *)goal withSuccess:(goalBlock)block andFailure:(errorBlock)errorBlock
{
    NSDictionary *reqparams=[MTLJSONAdapter JSONDictionaryFromModel:goal];
    [self POST:@"goals" parameters:reqparams success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *response=(NSDictionary *) responseObject;
        NSLog( @"%@", response );
        NSError *error=nil;
        RDPGoal *returnedGoal=[MTLJSONAdapter modelOfClass:RDPGoal.class fromJSONDictionary:response error:&error];
        
        block(returnedGoal);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
        errorBlock(error);
    }];
}

#pragma mark - SAVINGS

-(void)getMySavings
{
    [self GET:@"savings/me" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *response= responseObject;
        NSError *error=nil;
        NSLog( @"%@", response );
        NSArray *savings = [MTLJSONAdapter modelsOfClass:RDPSavingEvent.class fromJSONArray:response error:&error];
        
        NSLog( @"%@", savings );
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSHTTPURLResponse *responseErrorData= [[error userInfo] objectForKey:@"com.alamofire.serialization.response.error.response"];
        NSInteger statusCode=[responseErrorData statusCode];
        NSData *data = [[error userInfo] objectForKey:RDPJSONResponseSerializerKey];
        NSLog(@"%@", error);
        
    }];
}

-(void)postSavings:(RDPSavingEvent *)savings
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

-(void)updateSavings:(RDPSavingEvent *)savings
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
        NSArray *savings = [MTLJSONAdapter modelsOfClass:RDPSavingEvent.class fromJSONArray:response error:&error];
        NSLog( @"%@", savings );

        block(savings);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSHTTPURLResponse *responseErrorData= [[error userInfo] objectForKey:@"com.alamofire.serialization.response.error.response"];
        NSInteger statusCode=[responseErrorData statusCode];
        NSData *data = [[error userInfo] objectForKey:RDPJSONResponseSerializerKey];
        errorBlock(error);
        NSLog(@"%@", error);
        
    }];
}
-(void)updateMySaving:(RDPSavingEvent *)saving withSuccess:(completionBlock)block andFailure:(errorBlock)errorBlock
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
-(void)postNewSaving:(RDPSavingEvent *)saving withSuccess:(savingBlock)block andFailure:(errorBlock)errorBlock
{
    NSDictionary *reqparams=[MTLJSONAdapter JSONDictionaryFromModel:saving];
    [self POST:@"savings" parameters:reqparams success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *response=(NSDictionary *) responseObject;
        NSError *error=nil;
        NSLog( @"%@", response );
        RDPSavingEvent *returnedSaving=[MTLJSONAdapter modelOfClass:RDPSavingEvent.class fromJSONDictionary:response error:&error];
        block(returnedSaving);

        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
        errorBlock(error);
    }];
}


#pragma mark - NOTIFICATIONS

-(void)getMyNotifications
{
    [self GET:@"notifications/me" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *response=(NSDictionary *) responseObject;
        NSLog( @"%@", response );
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
        
    }];
    
}

-(void)updateNotifications:(NSDictionary *)params
{
    [self PUT:@"notifications/me" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *response=(NSDictionary *) responseObject;
        NSLog( @"%@", response );
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
        
    }];
}

#pragma mark - IMAGES

-(void)getNextImage
{
    [self testPOSTHTTPRequest:@""];
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



@end
