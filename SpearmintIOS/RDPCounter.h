//
//  RDPCounterView.h
//  SpearmintIOS
//
//  Created by Matthew Ziegler on 7/24/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RDPCounter : UIView

// Array of colors to cycle through
@property (nonatomic, strong) NSArray* colors;

// Width of the circle bar
@property (nonatomic) double lineWidth;

// Padding between the frame and the outer edge of the circle bar
@property (nonatomic) double padding;

// Currency symbol to use (in case we want to globalize)
@property (nonatomic, strong) NSString* currencySymbol;

// Currency value
@property (nonatomic, strong) NSNumber* currencyValue;

// The rotations-per-second of the circle bar
@property (nonatomic) double rotationsPerSecond;

// The max value of the circle loader. Cannot set above 99
@property (nonatomic) double maxValue;

// How much the circle will increment every revolution
@property (nonatomic) double incrementAmount;

// Name of font to use for text in the circle loader
@property (nonatomic, strong) NSString* fontName;

// Size of text for the main currency number
@property (nonatomic) NSInteger fontSize;

/**
 Starts the timer. By default the timer will not start incrementing when it is created. The timer
 must be started to begin.
 */
- (void)start;

/**
 Stops the timer in its place.
 */
- (void)stop;

/**
 Hides the timer. Note that the timer will still be taking up space, but it will not be visible.
 */
- (void)hide;

/**
 Shows the timer.
 */
- (void)show;

@end
