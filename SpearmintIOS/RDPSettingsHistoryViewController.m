//
//  RDPSettingsHistoryViewController.m
//  SpearmintIOS
//
//  Created by Matthew Ziegler on 8/4/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPSettingsHistoryViewController.h"
#import "RDPUserService.h"
#import "NSDate+Utilities.h"

#define kCellXibName                    @"RDPTableViewSavingsCell"
#define kCellReusableIdentifier         @"SavingsCell"

#define kSectionTitleKey                @"title"
#define kEarliestDateKey                @"earliestDate"
#define kLatestDateKey                  @"latestDate"
#define kSavingsEventsKey               @"savingEvents"

#define kAmountKey                      @"amount"
#define kReasonKey                      @"reason"
#define kTimeAndPlaceKey                @"timeAndPlaceKey"
#define kSavingIDKey                    @"savingID"
#define kSavingTagKey                   @"tag"

#define kSavingCellHeight               50
#define kHeaderSectionHeight            40
#define kUndoButtonIndex                1
#define kCancelButtonIndex              0
#define kHeaderSectionLabelMarginX      20
#define kHeaderSectionLabelMarginY      0
#define kHeaderSectionMargin            0
#define kHeaderBorderBottomWidth        2
#define kCellBorderBottomWidth          1
#define kHeaderBorderMargin             10
#define kCellBorderMargin               20


@interface RDPSettingsHistoryViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) NSString* currentSavingID;
@property (strong, nonatomic)NSArray* sortingKey;
@property (nonatomic, strong)NSArray* savings;
@property (nonatomic, weak)UITextField* currentTextField;

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
//    self.tableView.alwaysBounceVertical = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray*) savings
{
    if (!_savings) {
        [self loadSavings];
    }
    
    return _savings;
}

-(void)loadSavings
{
    NSMutableArray* savings = [[NSMutableArray alloc] init];
    NSArray* savingEventsModelBackwards = [[[RDPUserService getUser] getGoal] getSavingEvents];
    NSMutableArray* savingEventsModel = [[NSMutableArray alloc] init];
    for (NSInteger i = [savingEventsModelBackwards count] - 1; i >= 0; i--) {
        [savingEventsModel addObject:[savingEventsModelBackwards objectAtIndex:i]];
    }
    for (NSInteger i = 0; i < [savingEventsModel count]; i++) {
        RDPSavingEvent* savingEvent = [savingEventsModel objectAtIndex:i];
        if (!savingEvent.deleted) {
            NSMutableArray* savingEventsForDay = [[NSMutableArray alloc] init];
            NSMutableDictionary* savingSection = [NSMutableDictionary dictionaryWithDictionary:
                                                  @{kSectionTitleKey: [self stringForDate:savingEvent.date]}
                                                  ];
            [savingEventsForDay addObject:[self savingDictionaryFromSavingEvent:savingEvent andTag:i]];
            while (i+1 < [savingEventsModel count] && [savingEvent.date isEqualToDateIgnoringTime:[[savingEventsModel objectAtIndex:(i+1)] date]]) {
                savingEvent = [savingEventsModel objectAtIndex:(i+1)];
                if (!savingEvent.deleted) {
                    [savingEventsForDay addObject:[self savingDictionaryFromSavingEvent:savingEvent andTag:i]];
                }
                i++;
            }
            [savingSection setObject:[savingEventsForDay copy] forKey:kSavingsEventsKey];
            [savings addObject:savingSection];
        }
    }
    _savings = [savings copy];
}

-(NSDictionary*) savingDictionaryFromSavingEvent:(RDPSavingEvent*)savingEvent andTag:(NSInteger)tag
{
    return @{kAmountKey: [[RDPConfig numberFormatter] stringFromNumber:[savingEvent getAmount]],
             kReasonKey: [savingEvent getReason],
             kTimeAndPlaceKey: [savingEvent.date shortTimeString],
             kSavingIDKey: savingEvent.savingID,
             kSavingTagKey: [NSNumber numberWithInteger:tag]};
}

- (IBAction)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSString*)stringForDate:(NSDate*)date
{
    NSString* dayString;
    if ([date isToday]) {
        dayString = [RDPStrings stringForID:sToday];
    }
    else if ([date isYesterday]) {
        dayString = [RDPStrings stringForID:sYesterday];
    }
    else {
        dayString = [date longDateString];
        NSString* append;
        dayString = [dayString substringWithRange:NSMakeRange(0, dayString.length - 6)];
        NSInteger daySingleDigit = date.day % 10;

        if (daySingleDigit == 1) {
            append = @"st";
        }
        else if (daySingleDigit == 2) {
            append = @"nd";
        }
        else if (daySingleDigit == 3) {
            append = @"rd";
        }
        else {
            append = @"th";
        }
        if (date.day == 11 || date.day == 12 || date.day == 13) {
            append = @"th";
        }
        dayString = [dayString stringByAppendingString:append];
    }
    return dayString;
}

- (NSString*)stringForMonth:(NSDate*)date
{
    NSString* monthString;
    
    if (0 == date.month) {
        monthString = [RDPStrings stringForID:sJanuary];
    }
    else if (1 == date.month) {
        monthString = [RDPStrings stringForID:sFebruary];
    }
    else if (2 == date.month) {
        monthString = [RDPStrings stringForID:sMarch];
    }
    else if (3 == date.month) {
        monthString = [RDPStrings stringForID:sApril];
    }
    else if (4 == date.month) {
        monthString = [RDPStrings stringForID:sMay];
    }
    else if (5 == date.month) {
        monthString = [RDPStrings stringForID:sJune];
    }
    else if (6 == date.month) {
        monthString = [RDPStrings stringForID:sJuly];
    }
    else if (7 == date.month) {
        monthString = [RDPStrings stringForID:sAugust];
    }
    else if (8 == date.month) {
        monthString = [RDPStrings stringForID:sSeptember];
    }
    else if (9 == date.month) {
        monthString = [RDPStrings stringForID:sOctober];
    }
    else if (10 == date.month) {
        monthString = [RDPStrings stringForID:sNovember];
    }
    else if (11 == date.month) {
        monthString = [RDPStrings stringForID:sDecember];
    }
    
    return monthString;
}

-(NSDate*)daysFromToday:(int)days hours:(int)hours
{
    NSDate *today = [[NSDate alloc] init];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setTimeZone:[NSTimeZone defaultTimeZone]];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:days];
    
    NSDate *daysFromToday = [gregorian dateByAddingComponents:components toDate:today options:0];
    NSDateComponents *reminderTimeComponents = [gregorian components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:daysFromToday];
    reminderTimeComponents.hour=hours;
    return [gregorian dateFromComponents:reminderTimeComponents];
}


#pragma mark - Table view data source

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.currentTextField) {
        [self.currentTextField resignFirstResponder];
    }
    CGFloat sectionHeaderHeight = kHeaderSectionHeight;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.savings count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.savings objectAtIndex:section] objectForKey:kSavingsEventsKey] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return [[self.savings objectAtIndex:section] objectForKey:kSectionTitleKey];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kHeaderSectionHeight;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, kHeaderSectionHeight)];
    [headerView setBackgroundColor:kColor_Transparent];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(kHeaderSectionLabelMarginX,
                                                               kHeaderSectionLabelMarginY,
                                                               headerView.frame.size.width - kHeaderSectionLabelMarginX * 2,
                                                               kHeaderSectionHeight - kHeaderSectionLabelMarginY * 2)];
    [label setText:[[self.savings objectAtIndex:section] objectForKey:kSectionTitleKey]];
    [label setTextColor:kColor_WhiteText];
    [label setFont: [RDPFonts fontForID:fSectionHeaderFont]];
    
    UIView* borderBottom = [[UIView alloc] initWithFrame:CGRectMake(kHeaderBorderMargin, kHeaderSectionHeight - kHeaderBorderBottomWidth, tableView.bounds.size.width - (kHeaderBorderMargin * 2), kHeaderBorderBottomWidth)];
    borderBottom.backgroundColor = kColor_TableViewSeparatorColor;
    
    [headerView addSubview:label];
    [headerView addSubview:borderBottom];
    return headerView;
}

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
    
    NSDictionary* cellData = [[[self.savings objectAtIndex:indexPath.section] objectForKey:kSavingsEventsKey] objectAtIndex:indexPath.row];
    
    [cell.container setBackgroundColor:kColor_Transparent];
    cell.amountLabel.text = [cellData objectForKey:kAmountKey];
    [cell.amountLabel setFont:[RDPFonts fontForID:fCurrencyFont]];
    [cell.amountLabel setTextColor: kColor_WhiteText];
    cell.reasonInput.text = [cellData objectForKey:kReasonKey];
    [cell.reasonInput setFont:[RDPFonts fontForID:fLoginFont]];
    [cell.reasonInput setTextColor:kColor_WhiteText];
    cell.timeAndLocationLabel.text = [cellData objectForKey:kTimeAndPlaceKey];
    [cell.timeAndLocationLabel setFont:[RDPFonts fontForID:fSmallText]];
    [cell.timeAndLocationLabel setTextColor:kColor_WhiteText];
    cell.delegate = self;
    cell.reasonInput.delegate = self;
    cell.reasonInput.tag = [[cellData objectForKey:kSavingTagKey] integerValue];
    cell.savingID = [cellData objectForKey:kSavingIDKey];
    
    UIView* borderBottom = [[UIView alloc] initWithFrame:CGRectMake(cell.frame.origin.x + kCellBorderMargin, cell.frame.size.height - kCellBorderBottomWidth, cell.frame.size.width - (kCellBorderMargin * 2), kCellBorderBottomWidth)];
    borderBottom.backgroundColor = kColor_TableViewSeparatorColor;
    [cell addSubview:borderBottom];
    
    return cell;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    for (NSInteger i = 0; i < [self.savings count]; i++) {
        NSArray* savingsArray = [[self.savings objectAtIndex:i] objectForKey:kSavingsEventsKey];
        for (NSInteger j = 0; j < [savingsArray count]; j++) {
            if (textField.tag == [[[savingsArray objectAtIndex:j] objectForKey:kSavingTagKey] integerValue]) {
                [self updatingSavingEventWithID:[[savingsArray objectAtIndex:j] objectForKey:kSavingIDKey] withNewReason:textField.text];
                break;
            }
        }
    }
}

-(void)updatingSavingEventWithID:(NSString*)savingID withNewReason:(NSString*)reason
{
    NSMutableArray* newSavings = [NSMutableArray arrayWithArray:[[[RDPUserService getUser] getGoal] getSavingEvents]];
    for (RDPSavingEvent* savingEvent in newSavings) {
        if ([savingEvent.savingID isEqualToString:savingID]) {
            [savingEvent setReason:reason];
            RDPUser* updatedUser = [RDPUserService getUser];
            [[updatedUser getGoal] setSavingEvents:[newSavings copy]];
            [RDPUserService saveUser:updatedUser withResponse:^(RDPResponseCode response) {
                [self loadSavings];
            }];
            break;
        }
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.currentTextField = textField;
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
