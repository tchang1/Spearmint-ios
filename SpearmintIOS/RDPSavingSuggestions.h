//
//  RDPSavingSuggestions.h
//  SpearmintIOS
//
//  Created by McElwain, Cori on 8/4/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RDPSavingSuggestions : NSObject

@property (nonatomic, strong) NSArray *suggestionMessages;
@property (nonatomic, strong) NSArray *defaultMessages;

-(void)getNextSuggestionMessages;


@end
