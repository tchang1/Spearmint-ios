//
//  RDPDataHolder.m
//  SpearmintIOS
//
//  Created by McElwain, Cori on 8/14/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPDataHolder.h"

@implementation RDPDataHolder

static RDPDataHolder *dataHolder = nil;

- (id)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

+ (RDPDataHolder *)getDataHolder
{
    if (dataHolder) {
        return dataHolder;
    }
    
    dataHolder = [[self alloc] init];
    return dataHolder;
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
