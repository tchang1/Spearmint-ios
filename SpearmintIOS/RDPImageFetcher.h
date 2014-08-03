//
//  RDPImageFetcher.h
//  SpearmintIOS
//
//  Created by McElwain, Cori on 7/28/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RDPHTTPClient.h"

typedef void(^ImageBlock)(UIImage*);

@interface RDPImageFetcher : NSObject <RDPHTTPClientDelegate>

@property (nonatomic, strong) NSMutableArray *clearImagesArray;
@property (nonatomic, strong) NSMutableArray *blurredImagesArray;

@property (atomic, assign) int indexOfImageFile;
@property (atomic, assign) int indexOfImageArray; 
@property (atomic, assign) int numImages;

+ (RDPImageFetcher *)getImageFetcher;

/**
 Method to return the current blurred image for the settings screens to use as the background image
 */
- (UIImage *)getCurrentBlurredImage;

/**
 Method to be called by the view controller to load the next image for the home screen.
 */
- (void)nextImage;

@end