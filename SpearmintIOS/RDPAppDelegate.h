//
//  RDPAppDelegate.h
//  SpearnintIOS
//
//  Created by McElwain, Cori on 7/21/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDPImageFetcher.h"

@interface RDPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) RDPImageFetcher *imageFetcher; 

@end
