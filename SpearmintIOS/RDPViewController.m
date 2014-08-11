//
//  RDPViewController.m
//  SpearnintIOS
//
//  Created by Matthew Ziegler on 7/21/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface RDPViewController ()

@property (nonatomic, strong)UIView* statusBarBackground;

@end

@implementation RDPViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setNavigationBarColor:(UIColor*)color
{
    if (!self.statusBarBackground) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                      forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = [UIImage new];
        self.navigationController.navigationBar.translucent = YES;
        
        self.statusBarBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 340, 20)];

        [self.navigationController.view addSubview:self.statusBarBackground];
        self.statusBarBackground.layer.zPosition = MAXFLOAT;
    }
    
    [self.statusBarBackground setBackgroundColor:color];
    [self.navigationController.navigationBar setBackgroundColor:color];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
