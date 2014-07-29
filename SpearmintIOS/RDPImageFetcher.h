//
//  RDPImageFetcher.h
//  SpearmintIOS
//
//  Created by McElwain, Cori on 7/28/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ImageBlock)(UIImage*);

@interface RDPImageFetcher : NSObject

@property (nonatomic,strong) UIImage *image;

- (void) nextImage;

@end
