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

@interface RDPImageFetcher : NSObject <NSCoding, RDPHTTPClientDelegate>

@property (nonatomic, strong) NSMutableArray *nextImagesArray;
@property (nonatomic, strong) ImageBlock completionBlock;

@property (nonatomic, assign) int indexOfImageFile;

@property (nonatomic, strong) UIImage *currentBlurredImage;
@property (nonatomic, strong) UIImage *nextBlurredImage;

+ (RDPImageFetcher *)getImageFetcher;

//- (void)setImageWithBlock:(ImageBlock)block;

- (void)blurNextTwoImages;

/**
 Method to be called by the view controller to load the next image for the home screen.
 */
- (void)nextImage;

@end