//
//  RDPSettingsHistoryViewController.m
//  SpearmintIOS
//
//  Created by Matthew Ziegler on 8/4/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPSettingsHistoryViewController.h"
#import "RDPUserService.h"

#define kCellXibName                    @"RDPTableViewSavingsCell"
#define kCellReusableIdentifier         @"SavingsCell"

#define kAmountKey                      @"amount"
#define kReasonKey                      @"reason"
#define kTimeAndPlaceKey                @"timeAndPlaceKey"
#define kSavingIDKey                    @"savingID"

#define kSavingCellHeight               50
#define kUndoButtonIndex                1
#define kCancelButtonIndex              0

@interface RDPSettingsHistoryViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) NSString* currentSavingID;

//@property (strong, nonatomic) NSArray* savings;

@end

@implementation RDPSettingsHistoryViewController

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
    UIView* statusBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 340, 20)];
    [statusBackground setBackgroundColor:kColor_SettingPanelHeader];
    [self.view addSubview:statusBackground];
    [[[self.navigationController.view subviews] objectAtIndex:1] setHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[[self.navigationController.view subviews] objectAtIndex:1] setHidden:NO];
}

- (NSArray*) getSavings
{
    NSMutableArray* savings = [[NSMutableArray alloc] init];
    NSArray* savingEventsModel = [[[RDPUserService getUser] getGoal] getSavingEvents];
    for (NSInteger i = 0; i < [savingEventsModel count]; i++) {
        RDPSavingEvent* savingEvent = [savingEventsModel objectAtIndex:i];
        if (!savingEvent.deleted) {
            [savings addObject:@{kAmountKey: [@"$" stringByAppendingString:[[savingEvent getAmount] description]],
                                kReasonKey: [savingEvent getReason],
                                 kTimeAndPlaceKey: [[savingEvent.date description] stringByAppendingString:savingEvent.location],
                                 kSavingIDKey: savingEvent.savingID}];
        }
    }
    
    return [savings copy];
}

- (IBAction)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self getSavings] count];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return kCellHeight;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kSavingCellHeight;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RDPTableViewSavingsCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReusableIdentifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[RDPTableViewSavingsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellReusableIdentifier];
    }
    
    NSDictionary* cellData = [[self getSavings] objectAtIndex:indexPath.row];
    
    [cell.container setBackgroundColor:kColor_PanelColor];
    cell.amountLabel.text = [cellData objectForKey:kAmountKey];
    [cell.amountLabel setFont:[RDPFonts fontForID:fCurrencyFont]];
    [cell.amountLabel setTextColor: kColor_DarkText];
    cell.reasonLabel.text = [cellData objectForKey:kReasonKey];
    [cell.reasonLabel setFont:[RDPFonts fontForID:fMenuFont]];
    [cell.reasonLabel setTextColor:kColor_DarkText];
    cell.timeAndLocationLabel.text = [cellData objectForKey:kTimeAndPlaceKey];
    [cell.timeAndLocationLabel setFont:[RDPFonts fontForID:fSmallText]];
    [cell.timeAndLocationLabel setTextColor:kColor_DarkText];
    cell.undoButton.titleLabel.text = [RDPStrings stringForID:sUndo];
    [cell.undoButton.titleLabel setFont:[RDPFonts fontForID:fMenuFont]];
    [cell.undoButton.titleLabel setTextColor:kColor_WarningRed];
    cell.delegate = self;
    cell.savingID = [cellData objectForKey:kSavingIDKey];
    
    return cell;
}

-(void)undoSelectedForCellWithIdentifier:(NSString*)savingID
{
    self.currentSavingID = savingID;
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:[RDPStrings stringForID:sUndoSavingBodyMessage]
                                                   delegate:(id)self
                                          cancelButtonTitle:[RDPStrings stringForID:sUndoSavingCancelButton]
                                          otherButtonTitles:[RDPStrings stringForID:sUndoSavingUndoButton], nil];
    alert.delegate = self;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (kUndoButtonIndex == buttonIndex) {
        RDPUser* editedUser = [RDPUserService getUser];
        for (NSInteger i = 0; i < [[[editedUser getGoal] getSavingEvents] count]; i++) {
            if ([self.currentSavingID isEqualToString:[[[[editedUser getGoal] getSavingEvents] objectAtIndex:i] savingID]]) {
                [[[[editedUser getGoal] getSavingEvents] objectAtIndex:i] deleteSavingEvent];
                [RDPUserService saveUser:editedUser withResponse:^(RDPResponseCode response) {
                    [self.tableView reloadData];
                }];
                break;
            }
        }
    }
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
