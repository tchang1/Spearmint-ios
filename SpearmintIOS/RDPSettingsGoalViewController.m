//
//  RDPSettingsGoalViewController.m
//  SpearmintIOS
//
//  Created by Matthew Ziegler on 8/4/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPSettingsGoalViewController.h"
#import "RDPTableViewCellWithInput.h"

#define kCellXibName                    @"RDPTableViewCellWithInput"
#define kCellReusableIdentifier         @"InputCell"

#define kGoalNameIdentifier             @"goalName"
#define kGoalAmountIdentifier           @"goalAmount"
#define kGoalAmountSavedIdentifier      @"goalAmountSaved"

#define kNameKey                        @"name"
#define kIdentifierKey                  @"identifier"
#define kPlaceholderKey                 @"placeholder"

#define kCellHeight                     62

@interface RDPSettingsGoalViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray* goalOptions;

@end

@implementation RDPSettingsGoalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:kCellXibName bundle:nil] forCellReuseIdentifier:kCellReusableIdentifier];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setBackgroundColor:kColor_Transparent];
    self.tableView.alwaysBounceVertical = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray*)goalOptions
{
    if (!_goalOptions) {
        _goalOptions = @[@{kNameKey : [RDPStrings stringForID:sGoal],
                           kIdentifierKey : kGoalNameIdentifier,
                           kPlaceholderKey : [RDPStrings stringForID:sIWantTo]
                           },
                         @{kNameKey : [RDPStrings stringForID:sAmount],
                           kIdentifierKey : kGoalAmountIdentifier,
                           kPlaceholderKey : @"0"
                           },
                         @{kNameKey : [RDPStrings stringForID:sAmountSaved],
                           kIdentifierKey : kGoalAmountSavedIdentifier,
                           kPlaceholderKey : @"0"
                           }];
    }
    return _goalOptions;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.goalOptions count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RDPTableViewCellWithInput *cell = [tableView dequeueReusableCellWithIdentifier:kCellReusableIdentifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[RDPTableViewCellWithInput alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellReusableIdentifier];
    }
    
    [cell.inputView.label setText:[[self.goalOptions objectAtIndex:indexPath.row] objectForKey:kNameKey]];
    [cell.inputView.label setFont:[RDPFonts fontForID:fSectionHeaderFont]];
    [cell.inputView.label setTextColor:kColor_DarkText];
    [cell.inputView setBackgroundColor:kColor_PanelColor];
    [cell.inputView setInputBackgroundColor:kColor_InputFieldColor];
    [cell.inputView.input setPlaceholder:[[self.goalOptions objectAtIndex:indexPath.row] objectForKey:kPlaceholderKey]];
    [cell.contentView setBackgroundColor:kColor_Transparent];
    
    if ([[[self.goalOptions objectAtIndex:indexPath.row]objectForKey:kIdentifierKey]  isEqualToString: kGoalAmountIdentifier] ||
        [[[self.goalOptions objectAtIndex:indexPath.row]objectForKey:kIdentifierKey]  isEqualToString: kGoalAmountSavedIdentifier])
    {
        [cell.inputView.input setKeyboardType:UIKeyboardTypeDecimalPad];
    }
    
    return cell;
}

- (IBAction)cancelPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)savePressed:(id)sender {
}


//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    SEL selector = NSSelectorFromString([[self.menuItems objectAtIndex:indexPath.row] objectForKey:kKeySelector]);
//    if (selector) {
//        //        [self performSelector:selector];
//        ((void (*)(id, SEL))[self methodForSelector:selector])(self, selector);
//    }
//}

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
