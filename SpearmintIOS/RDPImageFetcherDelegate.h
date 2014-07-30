//
//  RDPImageFetcherDelegate.h
//  SpearmintIOS
//
//  Created by McElwain, Cori on 7/29/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RDPImageFetcherDelegate <NSObject>
/**
 Lets the view controller know when an image has been loaded and is 
 ready to be displayed to the user 
 
 @param image : The image that has been returned from the server
 */
- (void)imageHasLoaded:(UIImage*)image;

@end

