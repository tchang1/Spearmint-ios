//
//  RDPImageBlur.m
//  SpearmintIOS
//
//  Created by McElwain, Cori on 7/29/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPImageBlur.h"
#import "UIImage+ImageEffects.h"

@implementation RDPImageBlur

// The following method is from blog.bubbly.net/tag/gpu-image/#sJRpXftgd4fm0vbE.99
- (UIImage *)applyBlurOnImage: (UIImage *)imageToBlur withRadius:(CGFloat)blurRadius
{
    return [imageToBlur applyBlurWithRadius:blurRadius];
}


@end
