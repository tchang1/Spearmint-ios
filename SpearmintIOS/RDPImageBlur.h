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
 @param blurRadius : The radius of the gaussian blur to apply.
 */
+ (UIImage *)applyBlurOnImage: (UIImage *)imageToBlur;

@end
