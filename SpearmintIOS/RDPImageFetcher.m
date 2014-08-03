//
//  RDPImageFetcher.m
//  SpearmintIOS
//
//  Created by McElwain, Cori on 7/28/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPImageFetcher.h"
#import "RDPImageBlur.h"

@interface RDPImageFetcher()

@end

@implementation RDPImageFetcher

static RDPImageFetcher *imageFetcher = nil;

+ (RDPImageFetcher *)getImageFetcher
{
    if (imageFetcher) {
        return imageFetcher;
    }

    imageFetcher = [[RDPImageFetcher alloc] init];
    imageFetcher.indexOfImageFile = 0;
    [imageFetcher blurNextTwoImages];
    //[imageFetcher nextImage];
    return imageFetcher;

}

//- (void)setImageWithBlock:(ImageBlock)block
//{
//    self.completionBlock = block;
//    // If we already have the images, execute the block
//    if (self.nextImagesArray) {
//        UIImage *image = self.nextImagesArray[0];
//        self.completionBlock(image);
//    }
//}

// Add new functions
- (NSMutableArray *)nextImagesArray
{
    
    if (_nextImagesArray != nil) {
        return _nextImagesArray;
    }
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (int i=0; i <10; i++) {
        NSString *imageFileName = [[NSString stringWithFormat:@"%d", i] stringByAppendingString:@".jpg"];
        UIImage *image = [UIImage imageNamed:imageFileName];
        [array addObject:image];
    }
    
    imageFetcher.nextImagesArray = array; 
    
    return array;
}

- (void)blurNextTwoImages
{
    RDPImageBlur *blur = [[RDPImageBlur alloc] init];
    
    // If we don't have the next blurred image then we need to blur two images
    if (_nextBlurredImage == nil) {
        imageFetcher.currentBlurredImage = [blur applyBlurOnImage:self.nextImagesArray[self.indexOfImageFile] withRadius:20];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, (unsigned long)NULL), ^(void) {
            int nextIndex = (imageFetcher.indexOfImageFile +1) % 10;
            imageFetcher.nextBlurredImage = [blur applyBlurOnImage:imageFetcher.nextImagesArray[nextIndex] withRadius:20];
        });
    } else {
        imageFetcher.currentBlurredImage = imageFetcher.nextBlurredImage;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, (unsigned long)NULL), ^{
            int nextIndex = (imageFetcher.indexOfImageFile +1) % 10;
            imageFetcher.nextBlurredImage = [blur applyBlurOnImage:imageFetcher.nextImagesArray[nextIndex] withRadius:20];
        });
    }
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_nextImagesArray    forKey:@"nextImages"];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [self init];
    self.nextImagesArray = [coder decodeObjectForKey:@"nextImages"];
    return self;
}

- (void)nextImageToDisplay:(NSURL *)imageURL
{
    NSURL *nextImageURL = imageURL;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:nextImageURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIImage *image =[UIImage imageWithData:imageData];
            int prevIndex;
            if (self.indexOfImageFile == 0) {
                prevIndex = 9;
            } else {
                prevIndex = self.indexOfImageFile - 1;
            }
            self.nextImagesArray[prevIndex] = image;
        });
    });
}

- (void)nextImage
{
    // Get the next image from the client 
    RDPHTTPClient *client = [RDPHTTPClient sharedRDPHTTPClient];
    client.delegate = self;
    [client getNextImage];
}

-(void)RDPHTTPClient:(RDPHTTPClient *)client didGetImageURLs:(NSArray *)images {
    
    // TODO: load more than one image at a time, but let view display
    // the first image when it is immediately returned
    NSURL *imageURL = images[0];
    [self nextImageToDisplay:imageURL];
}



@end