//
//  RDPQuotes.m
//  SpearmintIOS
//
//  Created by Chang, Tony on 8/13/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPQuotes.h"

static NSArray *quotes;
static NSArray *shortQuotes;

@implementation RDPQuotes

+(NSArray*)quotes
{
    if (!quotes) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"quotes" ofType:@"plist"];
        quotes = [[NSArray alloc] initWithContentsOfFile:path];
    }
    return quotes;
}

+(NSArray*)shortQuotes
{
    if (!shortQuotes) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"shortQuote" ofType:@"plist"];
        shortQuotes = [[NSArray alloc] initWithContentsOfFile:path];
    }
    return shortQuotes;
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
    if (num>=count)
    {
        num=count;
    }
    NSRange range;
    range.location=0;
    range.length=num;
    NSArray *randomArray = [mutableArray subarrayWithRange:range];
    return randomArray;
}

+(NSArray *)getRandomShortQuotes
{
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:[self shortQuotes]];
    NSUInteger count = [mutableArray count];
    // See http://en.wikipedia.org/wiki/Fisher–Yates_shuffle
    if (count > 1) {
        for (NSUInteger i = count - 1; i > 0; --i) {
            [mutableArray exchangeObjectAtIndex:i withObjectAtIndex:arc4random_uniform((int32_t)(i + 1))];
        }
    }
    return mutableArray;
}


@end
