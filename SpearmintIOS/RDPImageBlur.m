//
//  RDPImageBlur.m
//  SpearmintIOS
//
//  Created by McElwain, Cori on 7/29/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPImageBlur.h"

@implementation RDPImageBlur

- (UIImage *)applyBlurOnImage: (UIImage *)imageToBlur withRadius:(CGFloat)blurRadius
{
    GPUImageGaussianBlurFilter *blurFilter = [[GPUImageGaussianBlurFilter alloc] init];
    blurFilter.blurRadiusInPixels = blurRadius;
    return [blurFilter imageByFilteringImage: imageToBlur];
}

@end
