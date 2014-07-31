//
//  RDPImageFetcher.m
//  SpearmintIOS
//
//  Created by McElwain, Cori on 7/28/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPImageFetcher.h"

@implementation RDPImageFetcher

static RDPImageFetcher *imageFetcher = nil;

+ (RDPImageFetcher *)getImageFetcher
{
    if (imageFetcher) {
        return imageFetcher;
    }

    imageFetcher = [[RDPImageFetcher alloc] init];
    [imageFetcher nextImage];
    return imageFetcher;

}

- (void)setImageWithBlock:(ImageBlock)block
{
    self.completionBlock = block;
    // If we already have the images, execute the block
    if (self.nextImagesArray) {
        UIImage *image = self.nextImagesArray[0];
        self.completionBlock(image);
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
            // Pass the image to our image block to update the UI
            UIImage *image =[UIImage imageWithData:imageData];
            self.nextImagesArray = @[image];
            if (self.completionBlock) {
                self.completionBlock(image);
            }
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