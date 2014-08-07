//
//  RDPInputViewWithImage.m
//  SpearmintIOS
//
//  Created by Chang, Tony on 8/6/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPInputViewWithImage.h"

@implementation RDPInputViewWithImage

+ (id)customView
{
    RDPInputViewWithImage *customView = [[[NSBundle mainBundle] loadNibNamed:@"RDPInputViewWithImage" owner:nil options:nil] lastObject];
    
    // make sure customView is not nil or the wrong class!
    if ([customView isKindOfClass:[RDPInputViewWithImage class]])
        return customView;
    else
        return nil;
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
