//
//  RDPImageBlur.h
//  SpearmintIOS
//
//  Created by McElwain, Cori on 7/29/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RDPImageBlur : NSObject

/**
 Creates a UIImage that is a blurred version of the imageToBlur
 
 @param imageToBlur : The original image to blur.
 */
+ (UIImage *)applyBlurOnImage: (UIImage *)imageToBlur;

/**
 Creates a UIImage that is a blurred version of the imageToBlur without tint
 
 @param imageToBlur : The original image to blur.
 */
+ (UIImage *)applyBlurOnFTUImage: (UIImage *)imageToBlur;

@end
