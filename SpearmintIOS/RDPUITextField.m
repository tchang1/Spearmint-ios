//
//  RDPUITextField.m
//  SpearmintIOS
//
//  Created by Chang, Tony on 8/4/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPUITextField.h"

@implementation RDPUITextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (!_indentAmount) {
            _indentAmount = 10;
        }
    }
    return self;
}

- (void)setIndentAmount:(CGFloat)indentAmount
{
    _indentAmount = indentAmount;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + self.indentAmount, bounds.origin.y + 8,
                      bounds.size.width - 20, bounds.size.height - 16);
}
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}
@end
