//
//  RDPImageFetcher.h
//  SpearmintIOS
//
//  Created by McElwain, Cori on 7/28/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RDPImageFetcherDelegate.h"
#import "RDPHTTPClient.h"

typedef void(^ImageBlock)(UIImage*);

@interface RDPImageFetcher : NSObject <RDPHTTPClientDelegate>

@property (nonatomic, weak) id<RDPImageFetcherDelegate> delegate;

/**
 Method to be called by the view controller to load the next image for the home screen.
 */
- (void)nextImage;

@end