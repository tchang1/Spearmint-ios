//
//  RDPTableViewCellWithInput.h
//  SpearmintIOS
//
//  Created by Matthew Ziegler on 8/4/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDPInputViewWithLabel.h"


@interface RDPTableViewCellWithInput : UITableViewCell
@property (weak, nonatomic) IBOutlet RDPInputViewWithLabel *inputView;

@end
