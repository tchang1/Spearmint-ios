//
//  RDPQuotes.m
//  SpearmintIOS
//
//  Created by Chang, Tony on 8/13/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPQuotes.h"

static NSArray const* quotes;

@implementation RDPQuotes

+(const NSArray*)quotes
{
    if (!quotes) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"quotes" ofType:@"plist"];
        quotes = [[NSArray alloc] initWithContentsOfFile:path];
    }
    return quotes;
}

+(NSArray *)getRandomQuotes:(int)num
{
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:[self quotes]];
    NSUInteger count = [mutableArray count];
    // See http://en.wikipedia.org/wiki/Fisher–Yates_shuffle
    if (count > 1) {
        for (NSUInteger i = count - 1; i > 0; --i) {
            [mutableArray exchangeObjectAtIndex:i withObjectAtIndex:arc4random_uniform((int32_t)(i + 1))];
        }
    }
    NSRange range;
    range.location=0;
    range.length=num;
    NSArray *randomArray = [mutableArray subarrayWithRange:range];
    return randomArray;
}


@end
