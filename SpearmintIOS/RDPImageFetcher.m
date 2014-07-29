//
//  RDPImageFetcher.m
//  SpearmintIOS
//
//  Created by McElwain, Cori on 7/28/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPImageFetcher.h"

@implementation RDPImageFetcher

- (void) nextImageToDisplayWithBlock:(ImageBlock)block
{
    // Get the next images to display for this user from the server
    // TODO: update this code when REST services are done
    NSURL *imageURL = [NSURL URLWithString:@"http://example.com/demo.jpg"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Pass the image to our image block to update the UI
            block([UIImage imageWithData:imageData]);
        });
    });
}

- (void) nextImage
{
    ImageBlock block = ^(UIImage* nextImage) {
        self.image = nextImage;
    };
    
    [self nextImageToDisplayWithBlock:block];
    
}


@end
