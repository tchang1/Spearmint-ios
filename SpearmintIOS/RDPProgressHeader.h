//
//  RDPProgressHeader.h
//  SpearmintIOS
//
//  Created by McElwain, Cori on 8/13/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RDPProgressHeader : UIView

@property (weak, nonatomic) IBOutlet UILabel *goalTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *goalAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *keptAmountLabel;

@end
