//
//  RDPTableViewSavingsCell.m
//  SpearmintIOS
//
//  Created by Matthew Ziegler on 8/4/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPTableViewSavingsCell.h"

@implementation RDPTableViewSavingsCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)undoSelected:(id)sender {
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(undoSelectedForCellWithIdentifier:)]) {
            [self.delegate undoSelectedForCellWithIdentifier:self.savingID];
        }
    }
}

@end
