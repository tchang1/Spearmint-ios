//
//  RDPImageFetcher.m
//  SpearmintIOS
//
//  Created by McElwain, Cori on 7/28/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPImageFetcher.h"

@implementation RDPImageFetcher

- (void)nextImageToDisplayWithBlock:(ImageBlock)block andImageURL:(NSURL *)imageURL
{
    NSURL *nextImageURL = imageURL;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:nextImageURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Pass the image to our image block to update the UI
            block([UIImage imageWithData:imageData]);
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
    // Create block to tell the view controller when image has been fully loaded
    ImageBlock block = ^(UIImage* nextImage) {
        if ([self.delegate respondsToSelector:@selector(imageHasLoaded:)]) {
            [self.delegate imageHasLoaded:nextImage];
        }
        
    };
    
    // TODO: load more than one image at a time, but let view display
    // the first image when it is immediately returned
    NSURL *imageURL = images[0];
    [self nextImageToDisplayWithBlock:block andImageURL:imageURL];
}



@end