//
//  RDPSavingSuggestions.m
//  SpearmintIOS
//
//  Created by McElwain, Cori on 8/4/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPSavingSuggestions.h"
#import "RDPHTTPClient.h"

NSString * const kSuggestion1 = @"Skipped the coffee?";
NSString * const kSuggestion2 = @"Had a date night in?";
NSString * const kSuggestion3 = @"Skipped a round of drinks?";
NSString * const kSuggestion4 = @"Saw a free concert?";
NSString * const kSuggestion5 = @"Biked to work?";

@implementation RDPSavingSuggestions

-(id)init
{
    self=[super init];
    if (self) {
        
    }
    return self;
}
- (NSArray *)suggestionMessages
{
    if (_suggestionMessages != nil) {
        return _suggestionMessages;
    }
    
    else return self.defaultMessages;

}

-(void)getNextSuggestionMessages
{
    [[RDPHTTPClient sharedRDPHTTPClient] getSuggestions:@5 withSuccess:^(NSArray *suggestions) {
        _suggestionMessages=suggestions;
        //DevNSLog(@"Got server suggestions");
    } andFailure:^(NSError *error) {
        _suggestionMessages=self.defaultMessages;
    }];
}

- (NSArray *)defaultMessages
{
    if (_defaultMessages != nil) {
        return _defaultMessages;
    }
    
    return @[kSuggestion1, kSuggestion2, kSuggestion3, kSuggestion4, kSuggestion5];
}

@end
