//
//  RDPHTTPClient.m
//  SpearmintIOS
//
//  Created by Chang, Tony on 7/23/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPHTTPClient.h"
#import "RDPGoal.h"

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
        self.responseSerializer = [AFJSONResponseSerializer serializer];
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

//USERS
-(void)loginWithUsername:(NSString *)username andPassword:(NSString *)password
{
    NSDictionary *parameters = @{@"username": username,
                                 @"password": password};
    [self POST:@"login" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *response=(NSDictionary *) responseObject;
        NSLog( @"%@", response );
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
        
    }];
    
}

//GOALS

-(void)getMyGoal
{
    [self GET:@"goals/me" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *response=(NSDictionary *) responseObject;
        NSError *error=nil;
        RDPGoal *goal=[MTLJSONAdapter modelOfClass:RDPGoal.class fromJSONDictionary:response error:&error];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
        
    }];
    
}

-(void)updateMyGoal:(NSDictionary *)goal
{
    [self PUT:@"goals/me" parameters:goal success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *response=(NSDictionary *) responseObject;
        NSLog( @"%@", response );
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
    }];
}

-(void)postNewGoal:(NSDictionary *)goal
{
    [self POST:@"goals" parameters:goal success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *response=(NSDictionary *) responseObject;
        NSLog( @"%@", response );
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
    }];
}

//SAVINGS

-(void)getMySavings
{
    [self GET:@"savings/me" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *response=(NSDictionary *) responseObject;
        NSLog( @"%@", response );
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
        
    }];
}

-(void)postSavings:(NSDictionary *)savings
{
    [self POST:@"savings" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *response=(NSDictionary *) responseObject;
        NSLog( @"%@", response );
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
    }];
}

-(void)updateSavings:(NSDictionary *)savings
{
    [self PUT:@"savings" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *response=(NSDictionary *) responseObject;
        NSLog( @"%@", response );
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
    }];
}

//NOTIFICATIONS

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

//IMAGES

-(void)getNextImage
{
    NSDictionary *params = @{@"goalid":@"53d2bf28c5fb963e0717d8c8", @"categoryid":@"0"};
    [self GET:@"images/me" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *responseArray= responseObject;
        NSURL *imageurl1 = [NSURL URLWithString:[responseArray[0] objectForKey:@"uri"] relativeToURL:[NSURL URLWithString:@"http://moment-qa.intuitlabs.com/"]];
        NSURL *imageurl2 = [NSURL URLWithString:[responseArray[1] objectForKey:@"uri"] relativeToURL:[NSURL URLWithString:@"http://moment-qa.intuitlabs.com/"]];
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
