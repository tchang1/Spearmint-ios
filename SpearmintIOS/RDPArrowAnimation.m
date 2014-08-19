//
//  RDPArrowAnimation.m
//  SpearmintIOS
//
//  Created by Ziegler, Matthew on 8/19/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPArrowAnimation.h"
#import "RDPTimerManager.h"

#define numberOfImages          69
#define fileExtension           @".png"
#define kUpdateBlockName        @"animatedArrowBlock"

@interface RDPArrowAnimation()

@property (nonatomic, strong) NSArray* images;
@property (nonatomic) NSInteger currentIndex;
@property (nonatomic) NSInteger numberOfLoops;

@end

@implementation RDPArrowAnimation

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpAnimation];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setUpAnimation];
}

- (void)setUpAnimation
{
    self.currentIndex = 0;
    NSMutableArray* images = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < numberOfImages; i++) {

            [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%li%@", (long)i, fileExtension]]];

    }
    self.animationRepeatCount = 2;
    self.image = [images objectAtIndex:0];
    self.images = [images copy];
}

- (void)startAnimating
{
    [RDPTimerManager clearUpdateBlockWithName:kUpdateBlockName];
    self.numberOfLoops = 0;
    [RDPTimerManager registerUpdateBlock:^(NSInteger milliseconds) {
        if (0 == self.animationRepeatCount || self.numberOfLoops < self.animationRepeatCount) {
            self.currentIndex++;
        }
        if (self.currentIndex >= numberOfImages) {
            self.currentIndex = 0;
            self.numberOfLoops++;
        }
        self.image = [self.images objectAtIndex:self.currentIndex];
        [self setNeedsDisplay];
    } withName:kUpdateBlockName];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
