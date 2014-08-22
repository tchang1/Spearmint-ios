//
//  RDPSettingsNotificationsViewController.m
//  SpearmintIOS
//
//  Created by Matthew Ziegler on 8/4/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPSettingsNotificationsViewController.h"
#import "RDPTableViewCellWithToggle.h"
#import "RDPUserService.h"
#import "RDPAnalyticsModule.h"

#define kCellXibName                    @"RDPTableViewCellWithToggle"
#define kCellReusableIdentifier         @"ToggleCell"

#define kSectionHeaderKey               @"sectionHeader"
#define kOptionArrayKey                 @"optionArray"
#define kNameKey                        @"name"
#define kIdentifierKey                  @"identifier"


#define kEmailDailyIdentifier           @"dailyEmail"
#define kEmailWeeklyIdentifier          @"weeklyEmail"
#define kEmailReachGoalIdentifier       @"reachGoalEmail"
#define kNotificationDaily              @"dailyNotification"
#define kNotificationWeekly             @"weeklyNotification"
#define kNotificationInactive3Days      @"threeDayInactiveNotification"

#define kHeaderSectionMargin            2
#define kHeaderSectionHeight            30
#define kHeaderSectionLabelMarginX      15
#define kHeaderSectionLabelMarginY      0
#define kCellHeight                     55

@interface RDPSettingsNotificationsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray* sections;

@end

@implementation RDPSettingsNotificationsViewController

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

- (NSArray*)sections
{
    if (!_sections) {
        _sections = @[@{kNameKey : [RDPStrings stringForID:sDaily],
                                        kIdentifierKey : kNotificationDaily}];
    }
    
    return _sections;
}

- (IBAction)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return [self.sections count];
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.sections count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return kHeaderSectionHeight;
//}

//- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, kHeaderSectionHeight)];
//    [headerView setBackgroundColor:kColor_Transparent];
//    UIView *headerInnerView = [[UIView alloc] initWithFrame:CGRectMake(headerView.frame.origin.x,
//                                                                       kHeaderSectionMargin,
//                                                                       headerView.frame.size.width,
//                                                                       headerView.frame.size.height - kHeaderSectionMargin)];
//    [headerInnerView setBackgroundColor:kColor_PanelColor];
//    
//    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(kHeaderSectionLabelMarginX,
//                                                               kHeaderSectionLabelMarginY,
//                                                               headerView.frame.size.width - kHeaderSectionLabelMarginX * 2,
//                                                               kHeaderSectionHeight - kHeaderSectionLabelMarginY * 2)];
//    [label setText:[[self.sections objectAtIndex:section] objectForKey:kSectionHeaderKey]];
//    [label setTextColor:kColor_DarkText];
//    [label setFont: [RDPFonts fontForID:fSectionHeaderFont]];
//    
//    [headerInnerView addSubview:label];
//    [headerView addSubview:headerInnerView];
//    return headerView;
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RDPTableViewCellWithToggle *cell = [tableView dequeueReusableCellWithIdentifier:kCellReusableIdentifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[RDPTableViewCellWithToggle alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellReusableIdentifier];
    }
    
    NSDictionary* cellInfo = [self.sections objectAtIndex:indexPath.row];
    
    [cell.label setText:[cellInfo objectForKey:kNameKey]];
    [cell.label setFont:[RDPFonts fontForID:fMenuFont]];
    [cell.label setTextColor:kColor_DarkText];
    [cell.innerContent setBackgroundColor:kColor_Transparent];
    [cell.contentView setBackgroundColor:kColor_PanelColor];
    [cell.toggle setOn:[[RDPUserService getUser] isNotificationsEnabled] animated:NO];
    [cell.toggle addTarget:self action:@selector(updateNotificationPreference:) forControlEvents:UIControlEventValueChanged];

    return cell;
}

- (void)updateNotificationPreference:(id)sender
{
    BOOL preference = [sender isOn];
    [RDPAnalyticsModule track:@"Settings" properties:@{@"action" : @"toggleNotifications", @"value": [NSString stringWithFormat:@"%@",preference ? @"On" : @"Off"]}];
    RDPUser* modifiedUser = [RDPUserService getUser];
    [modifiedUser setNotificationsEnabled:preference];
    [RDPUserService saveUser:modifiedUser withResponse:^(RDPResponseCode response) {
        //
    }];
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
