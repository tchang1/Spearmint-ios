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

@property (nonatomic, assign) int indexOfImageFile;
@property (nonatomic, assign) int indexOfImageArray;
@property (nonatomic, assign) int numImages;

+ (RDPImageFetcher *)getImageFetcher;

/**
 Method to return the current blurred image for the settings screens to use as the background image
 */
- (UIImage *)getCurrentBlurredImage;
- (UIImage *)getCurrentImage;

/**
 Method to be called by the view controller to load the next image for the home screen.
 */
- (void)nextImage;

/**
 Methods to save and load the indices for the images arrays 
 */
-(void)saveIndices;
-(void)loadIndices;

@end