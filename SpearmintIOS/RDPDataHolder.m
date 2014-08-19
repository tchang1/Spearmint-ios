//
//  RDPDataHolder.m
//  SpearmintIOS
//
//  Created by McElwain, Cori on 8/14/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPDataHolder.h"

@implementation RDPDataHolder

static RDPDataHolder *savingData = nil;

- (id)init
{
    self = [super init];
    if (self) {
        self.hasJustSaved = NO;
        self.amountJustSaved = [NSNumber numberWithInt:-1];
    }
    return self;
}

+ (RDPDataHolder *)getDataHolder
{
    if (savingData) {
        return savingData;
    }
    
    savingData = [[self alloc] init];
    return savingData;
}

//- (id)getObjectForKey(NSString *)key
//{
//    
//}
//
//- (void)saveObject(id)object witKey:(NSString *)key
//{
//    
//}

@end
