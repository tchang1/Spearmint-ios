//
//  RDPTableViewSavingsCell.h
//  SpearmintIOS
//
//  Created by Matthew Ziegler on 8/4/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RDPTableViewSavingsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *reasonLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeAndLocationLabel;
@property (nonatomic) NSInteger identifier;
@property (weak, nonatomic) IBOutlet UIButton *undoButton;
@property (weak) id delegate;
@property (weak, nonatomic) IBOutlet UIView *container;

@end
