//
//  RDPHomeViewController.m
//  SpearmintIOS
//
//  Created by McElwain, Cori on 7/29/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPHomeViewController.h"
#import "RDPImageBlur.h"
#import "RDPHTTPClient.h"
#import "RDPStrings.h"
#import "RDPSavingEvent.h"
#import "RDPUser.h"
#import "RDPUserService.h"
#import "RDPAnalyticsModule.h"
#import "RDPProgressHeader.h"
#import "NSDate+Utilities.h"
#import "RDPTableViewSavingsCell.h"

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

#define kScreenHeight  [UIScreen mainScreen].bounds.size.height
#define kScreenWidth 320
#define kTextInputHeight 60
#define kProgressHeaderHeight 80
#define kContentHeight  (kScreenHeight * 2) + kTextInputHeight

#define kArrowImage @"DownArrow.png"
#define kProgressHeaderNib @"RDPProgressHeader"

#define kIndentAmount 10
#define kBorderRadius 5

#define kSuggestionDisplayDuration 4
#define kShowCongratsDuration 2500
#define kWaitTimeToHideTextField 1000

#define kMinimumPressDuration 0.2

#define kFadeLabelsTime 0.75
#define kFadeImagesTime 0.75

#define kImageTransitionTime 3.0f

@interface RDPHomeViewController ()
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic)NSArray* sortingKey;
@property (nonatomic, strong)NSArray* savings;
@property (nonatomic, weak)UITextField* currentTextField;
@property (nonatomic, weak)RDPProgressHeader* progressHeader;
@property (nonatomic, assign)CGFloat keyboardHeight;
@property (nonatomic, assign)BOOL shouldDismissKeyboardWhenScrolling;

//@property (strong, nonatomic) NSArray* savings;

@end

@implementation RDPHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    self.keyboardHeight = 216;
    self.shouldDismissKeyboardWhenScrolling = YES;
    [center addObserver:self selector:@selector(keyboardOnScreen:) name:UIKeyboardDidShowNotification object:nil];
    // Initialize the minimum press duration to be short so it seems more responsive
    self.pressAndHoldGestureRecognizer.minimumPressDuration = kMinimumPressDuration;
    
    // Disable the tap gesture recognizer
    self.tapGestureRecognizer.enabled = NO;
    //self.tapGestureRecognizer.delegate = self;
    
    // Get the clear and blurred image from the image fetcher
    self.imageFetcher = [RDPImageFetcher getImageFetcher];
    int index = self.imageFetcher.indexOfImageArray;
    self.clearImageView.image = self.imageFetcher.clearImagesArray[index];
    self.blurredImageView.image = self.imageFetcher.blurredImagesArray[index];
    
    // Setup the scroll view
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setContentSize:CGSizeMake(kScreenWidth, kContentHeight)];
    CGPoint point = CGPointMake(0, kTextInputHeight);
    [self.scrollView setContentOffset:point];
    self.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
    self.screenMode = OnSaveScreen;
    self.scrollView.delegate = self;
    
    // Setup the cut out view with text field
    self.serverHasUpdatedSavingsEvents = YES;
    self.savingReason = @""; 
    self.hasJustSaved = NO; // TODO: get this from the persisted data
    //self.amountJustSaved = get this from persisted data
    self.savingsTextField.delegate = self;
    self.savingsTextField.indentAmount = kIndentAmount;
    self.cutOutView.innerView = self.savingsTextField;
    self.savingsTextField.borderRadius = kBorderRadius;
    self.savingsTextField.parentColor = self.cutOutView.backgroundColor;
    if (self.hasJustSaved) {
        [self updatePlaceHolderForTextField];
    }
    else {
        self.cutOutView.hidden = YES;
    }
    
    // Add the down arrow to the bottom of the screen
    UIImage *arrowImage = [UIImage imageNamed:kArrowImage];
    UIImageView *downArrowView = [[UIImageView alloc] initWithImage:arrowImage];
    [downArrowView setContentMode:UIViewContentModeCenter];
    CGRect  arrowViewRect = CGRectMake(0, kScreenHeight+kTextInputHeight - downArrowView.bounds.size.height - 10, kScreenWidth, downArrowView.bounds.size.height);
    [downArrowView setFrame:arrowViewRect];
    
    [self.pressAndHoldView addSubview:downArrowView];
    
    // Setup the progress view within scroll view
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:kProgressHeaderNib owner:self options:nil];
    self.progressHeader = [topLevelObjects objectAtIndex:0];
    self.progressHeader.goalTitleLabel.text = [[[RDPUserService getUser] getGoal] getGoalName];
    
    NSString *targetAmount = [[RDPConfig numberFormatter] stringFromNumber:[[[RDPUserService getUser] getGoal] getTargetAmount]];
    NSString *keptAmount = [[RDPConfig numberFormatter] stringFromNumber:[[[RDPUserService getUser] getGoal] getCurrentAmount]];
    self.progressHeader.goalAmountLabel.text = [[RDPStrings stringForID:sGoalCaps] stringByAppendingString:targetAmount];
    self.progressHeader.keptAmountLabel.text = [[RDPStrings stringForID:sKeptCaps] stringByAppendingString:keptAmount];
    
    CGRect  viewRect = CGRectMake(0, kScreenHeight, kScreenWidth, self.progressHeader.bounds.size.height);
    [self.progressHeader setFrame:viewRect];
    [self.scrollView addSubview:self.progressHeader];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                   kScreenHeight + kTextInputHeight + kProgressHeaderHeight,
                                                                   kScreenWidth,
                                                                   kScreenHeight - kProgressHeaderHeight)];
    [self.scrollView addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:kCellXibName bundle:nil] forCellReuseIdentifier:kCellReusableIdentifier];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setBackgroundColor:kColor_Transparent];
    self.tableView.alwaysBounceVertical = NO;
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    self.tableView.allowsSelection = NO;
    
    // Hide the counter
    self.counterView.hidden = YES;
    
    // Set the "tap and hold to save" label
    self.pressAndHoldLabel.text = [RDPStrings stringForID:sPressAndHold];
    
    // Prepare the congratulations message
    self.congratulations = [[RDPCongratulations alloc] init];
    [self.congratulations getNextCongratsMessage];
    self.congratsLabel.text = self.congratulations.congratsMessage;
    [self.recordButton setTitle:[RDPStrings stringForID:sRecord] forState:UIControlStateNormal];
    self.congratsView.hidden = YES;
    
    // Setup the saving suggestion messages
    self.suggestionIndex = 0;
    self.suggestions = [[RDPSavingSuggestions alloc] init];
    [self.suggestions getNextSuggestionMessages];
    self.suggestionLabel.text = self.suggestions.suggestionMessages[self.suggestionIndex];
    [self startSuggestionsTimer];
}

-(void)keyboardOnScreen:(NSNotification *)notification
{
    NSDictionary *info  = notification.userInfo;
    NSValue      *value = info[UIKeyboardFrameEndUserInfoKey];
    
    CGRect rawFrame      = [value CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
    
    self.keyboardHeight = keyboardFrame.size.height;
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

# pragma mark - Suggestion Timer

- (void)startSuggestionsTimer
{
    self.suggestionTimer = [NSTimer scheduledTimerWithTimeInterval:kSuggestionDisplayDuration target:self selector:@selector(displayNextSuggestion) userInfo:nil repeats:YES];
}

- (void)stopSuggestionsTimer
{
    [self.suggestionTimer invalidate];
    self.suggestionTimer = nil;
}

- (void)displayNextSuggestion
{
    NSArray *messages = self.suggestions.suggestionMessages;
    
    // Get next index for messages
    self.suggestionIndex += 1;
    if (self.suggestionIndex > ([messages count]-1)) {
        self.suggestionIndex = 0;
    }
    
    void (^fadeInBlock)(void) = ^{
        // animate the new label into view
        [UIView animateWithDuration:kFadeLabelsTime animations:^{
            self.suggestionLabel.alpha = 1.0;
        }];
    };
    
    [UIView animateWithDuration:kFadeLabelsTime animations:^{
        self.suggestionLabel.alpha = 0.0;
    }
                     completion:^(BOOL finished){
                         self.suggestionLabel.text = messages[self.suggestionIndex];
                         fadeInBlock();
                     }];
    
}

# pragma mark - Scroll View Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.shouldDismissKeyboardWhenScrolling = YES;
    if (self.tableView != scrollView) {
        [self scrollToNextPoint];
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.shouldDismissKeyboardWhenScrolling = YES;
    if (scrollView != self.tableView) {
        if (!decelerate) {
            [self scrollToNextPoint];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        if (self.currentTextField) {
            if (self.shouldDismissKeyboardWhenScrolling) {
                [self.currentTextField resignFirstResponder];
            }
        }
        CGFloat sectionHeaderHeight = kHeaderSectionHeight;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

#pragma mark - Table view data source

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString* savingID = [[[[self.savings objectAtIndex:indexPath.section] objectForKey:kSavingsEventsKey] objectAtIndex:indexPath.row] objectForKey:kSavingIDKey];
        RDPUser* editedUser = [RDPUserService getUser];
        for (NSInteger i = 0; i < [[[editedUser getGoal] getSavingEvents] count]; i++) {
            if ([savingID isEqualToString:[[[[editedUser getGoal] getSavingEvents] objectAtIndex:i] savingID]]) {
                RDPSavingEvent* savingEvent = [[[editedUser getGoal] getSavingEvents] objectAtIndex:i];
                if (!savingEvent.deleted) {
                    NSNumber* newNumber = [[editedUser getGoal] getCurrentAmount];
                    double newValue = [newNumber doubleValue] - [[savingEvent getAmount] doubleValue];
                    if (newValue < 0) {
                        newValue = 0;
                    }
                    newNumber = [NSNumber numberWithDouble:newValue];
                    [[editedUser getGoal] setCurrentAmount:newNumber];
                }
                [savingEvent deleteSavingEvent];
                [RDPUserService saveUser:editedUser withResponse:^(RDPResponseCode response) {
                    [self loadSavings];
                    [self.tableView reloadData];
                    NSString *keptAmount = [[RDPConfig numberFormatter] stringFromNumber:[[[RDPUserService getUser] getGoal] getCurrentAmount]];
                    self.progressHeader.keptAmountLabel.text = [[RDPStrings stringForID:sKeptCaps] stringByAppendingString:keptAmount];
                }];
                break;
            }
        }
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
    cell.reasonInput.tintColor = kColor_WhiteText;
    cell.savingID = [cellData objectForKey:kSavingIDKey];
    
    UIView* borderBottom = [[UIView alloc] initWithFrame:CGRectMake(cell.frame.origin.x + kCellBorderMargin, cell.frame.size.height - kCellBorderBottomWidth, cell.frame.size.width - (kCellBorderMargin * 2), kCellBorderBottomWidth)];
    borderBottom.backgroundColor = kColor_TableViewSeparatorColor;
    [cell addSubview:borderBottom];
    
    return cell;
}


# pragma mark - Display a View

- (void)scrollToNextPoint
{
    CGFloat breakPointTop = 0;
    CGFloat breakPointMiddle = kTextInputHeight + (kScreenHeight/4);
    CGFloat breakPointBottom = kTextInputHeight + (3*kScreenHeight/4);
    
    if (self.screenMode == OnRecordScreen && self.scrollView.contentOffset.y > 0) { // At record view any scroll should take us to saving screen
        [self goToSaveView];
    }
    else if (self.screenMode == OnSaveScreen) {
        if (self.scrollView.contentOffset.y <= breakPointTop && self.hasJustSaved) {
            [self goToRecordView];
        }
        else if (self.scrollView.contentOffset.y < breakPointMiddle) {
            [self goToSaveView];
        }
        else {
            [self goToProgressView];
        }
    }
    else if (self.screenMode == OnProgressView) {
        if (self.scrollView.contentOffset.y < breakPointBottom) {
            [self goToSaveView];
        }
        else {
            [self goToProgressView];
        }
    }
}

- (IBAction)recordReason:(id)sender
{
    [self goToRecordView];
}


- (void)goToSaveView
{
    self.pressAndHoldGestureRecognizer.enabled = YES;
    [self.scrollView setContentOffset:CGPointMake(0, kTextInputHeight) animated:YES];
    [self.savingsTextField resignFirstResponder];
    if (self.suggestionTimer == nil) {
        [self startSuggestionsTimer];
    }
    self.settingsButton.hidden = NO;
    self.screenMode = OnSaveScreen;
}

- (void)goToRecordView
{
    self.pressAndHoldGestureRecognizer.enabled = NO;
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    [self.savingsTextField becomeFirstResponder];
    self.tapGestureRecognizer.enabled = YES;
    self.scrollView.scrollEnabled = NO;
    [self stopSuggestionsTimer];
    self.settingsButton.hidden = YES;
    self.screenMode = OnRecordScreen;
}

- (void)goToProgressView
{
    self.pressAndHoldGestureRecognizer.enabled = NO;
    [self.scrollView setContentOffset:CGPointMake(0, kScreenHeight + kTextInputHeight) animated:YES];
    self.screenMode = OnProgressView;
}

# pragma mark - Gesture Recognizers 

- (IBAction)homeViewTapped:(UITapGestureRecognizer *)tapGesture
{
    [self enterSavingReason];
    self.tapGestureRecognizer.enabled = NO;
}


- (IBAction)pressAndHold:(UIGestureRecognizer *)recognizer
{
    switch (recognizer.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            self.scrollView.scrollEnabled = NO;
            
            [UIView animateWithDuration:kFadeImagesTime animations:^{
                
                self.blurredImageView.alpha = 0.0;
                
            }];
            self.counterView.hidden = NO;
            [self.counterView start];
            
            // Stop timer
            [self stopSuggestionsTimer];
            
            self.pressAndHoldView.hidden = YES;
            self.suggestionView.hidden = YES;
        }
            break;
            
        case UIGestureRecognizerStateChanged:
        {
            self.blurredImageView.alpha = 0.0;
        }
            break;
            
        case UIGestureRecognizerStateEnded:
        {
            self.scrollView.scrollEnabled = YES;
            
            // disable the gesture recognizer while animations and transitions occur
            self.pressAndHoldGestureRecognizer.enabled = NO;
            
            NSNumber *amountSaved = self.counterView.currencyValue;
            NSLog(@"GestureStateEnded amount: %@",amountSaved);
            BOOL amountHasBeenSaved = ![amountSaved isEqualToNumber:[NSNumber numberWithInt:0]];
            [RDPAnalyticsModule track:@"User saved" properties:@{@"amount" : amountSaved}];
            
            if (!amountHasBeenSaved) {
                self.pressAndHoldView.hidden = NO;
                self.pressAndHoldView.duration = kFadeLabelsTime;
                self.pressAndHoldView.type     = CSAnimationTypeFadeIn;
                [self.pressAndHoldView startCanvasAnimation];
                
                // Show suggestions
                self.suggestionView.hidden = NO;
                self.suggestionView.duration = kFadeLabelsTime;
                self.suggestionView.type     = CSAnimationTypeFadeIn;
                [self.suggestionView startCanvasAnimation];
                if (self.screenMode == OnSaveScreen) {
                    if (self.suggestionTimer == nil) {
                        [self startSuggestionsTimer];
                    }
                }
            } else {
                NSString *symbol = self.counterView.currencySymbol;
                NSString *justKept = [RDPStrings stringForID:sJustKept];
                NSString *amount = [symbol stringByAppendingString:[amountSaved stringValue]];
                self.amountKeptLabel.text = [justKept stringByAppendingString:amount];
                
                self.congratsLabel.text = self.congratulations.congratsMessage;
                [self.congratulations getNextCongratsMessage];
                
                self.congratsView.hidden = NO;
                
                self.congratsView.duration = kFadeLabelsTime;
                self.congratsView.type     = CSAnimationTypeFadeIn;
                [self.congratsView startCanvasAnimation];
                
                self.cutOutView.hidden = NO;
                self.easterEgg.hidden = YES;
                self.amountJustSaved = amountSaved;
                self.hasJustSaved = YES;
                [self updatePlaceHolderForTextField];
            }
            
            [UIView animateWithDuration:kFadeImagesTime animations:^{
                
                self.blurredImageView.alpha = 1.0;
            }
                             completion:^(BOOL finished){
                                 if (amountHasBeenSaved) {
                                     [self createSavingEventForAmount:amountSaved];
                                     [self showCongratsMessage];
                                     
                                 } else {
                                     if (self.screenMode == OnSaveScreen) {
                                         self.pressAndHoldGestureRecognizer.enabled = YES;
                                     }
                                 }
                             }];
            
            [self.counterView stop];
            self.counterView.hidden = YES;
            // Reset the counter
            [self.counterView reset];
            
        }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        default:
            break;
    }
}

- (void)createSavingEventForAmount:(NSNumber *)amountSaved
{
    self.serverHasUpdatedSavingsEvents = NO;
    
    RDPSavingEvent* savingEvent = [[RDPSavingEvent alloc] initWithAmount:amountSaved andReason:@"" andDate:[NSDate date] andLocation:@"" andID:nil];
    RDPUser* modifiedUser = [RDPUserService getUser];
    [[modifiedUser getGoal] addSavingEvent:savingEvent];
    double amountSavedDouble = [amountSaved doubleValue];
    double currentAmountDouble = [[[modifiedUser getGoal] getCurrentAmount] doubleValue];
    [[modifiedUser getGoal] setCurrentAmount:[NSNumber numberWithDouble:(amountSavedDouble + currentAmountDouble)]];
    [RDPUserService saveUser:modifiedUser withResponse:^(RDPResponseCode response) {
        [self loadSavings];
        NSLog(@"SavingEvent returned with response %i", response);
        self.serverHasUpdatedSavingsEvents = YES;
        
        if (![self.savingReason isEqualToString:@""]) {
            NSArray *savingEvents = [[[RDPUserService getUser] getGoal] getSavingEvents];
            RDPSavingEvent *mostRecentEvent = [savingEvents objectAtIndex:(savingEvents.count - 1)];
            [self updatingSavingEventWithID:mostRecentEvent.savingID withNewReason:self.savingReason];
            self.savingReason = @""; // clear the saving reason 
        }
    }];
}

- (void)showCongratsMessage
{
    void (^transitionBlock)(void) = ^{
        if (self.screenMode == OnSaveScreen) {
            self.congratsView.duration = 1;
            self.congratsView.type     = CSAnimationTypeFadeOut;
            [self.congratsView startCanvasAnimation];
            
            [self transitionImagesWithSaveAmount];
        }
    };
    

    [RDPTimerManager pauseFor:kShowCongratsDuration millisecondsThen:transitionBlock];

}

- (void)transitionImagesWithSaveAmount
{
    // Switch out the clear image that is behind the blurred image
    int nextIndex = (self.imageFetcher.indexOfImageArray + 1) % self.imageFetcher.numImages;
    self.clearImageView.image = self.imageFetcher.clearImagesArray[nextIndex];
    
    // Slowly transition to the next blurred image
    UIImage * toImage = self.imageFetcher.blurredImagesArray[nextIndex];
    [UIView transitionWithView:self.blurredImageView
                      duration:kImageTransitionTime
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.blurredImageView.image = toImage;
                    } completion:^(BOOL finished){
                        self.pressAndHoldView.hidden = NO;
                        self.pressAndHoldView.duration = kFadeLabelsTime;
                        self.pressAndHoldView.type     = CSAnimationTypeFadeIn;
                        [self.pressAndHoldView startCanvasAnimation];
                        
                        // Show suggestions
                        self.suggestionView.hidden = NO;
                        self.suggestionView.duration = kFadeLabelsTime;
                        self.suggestionView.type     = CSAnimationTypeFadeIn;
                        [self.suggestionView startCanvasAnimation];
                        
                        if (self.screenMode == OnSaveScreen) {
                            self.pressAndHoldGestureRecognizer.enabled = YES;
                            if (self.suggestionTimer == nil) {
                                [self startSuggestionsTimer];
                            }
                        }
                    }];
    
    // Update the index for the images array
    self.imageFetcher.indexOfImageArray = nextIndex;
    
    // Get new images from the server
    [self.imageFetcher nextImage];

}

# pragma mark - Record Savings Text Field

- (void)updatePlaceHolderForTextField
{
    NSString *justSavedAmount = [[RDPConfig numberFormatter] stringFromNumber:self.amountJustSaved];
    NSString *savedBy = [NSString stringWithFormat:[RDPStrings stringForID:sSavedBy], justSavedAmount];
    self.savingsTextField.attributedPlaceholder = [[NSAttributedString alloc]
                                                   initWithString:savedBy
                                                   attributes:@{NSForegroundColorAttributeName: kColor_halfWhiteText,
                                                                NSFontAttributeName : [RDPFonts fontForID:fLoginPlaceholderFont]}];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.currentTextField) {
        UITableViewCell* cell = (UITableViewCell *) textField.superview.superview.superview.superview;
//        [self.tableView scrollToRowAtIndexPath:[self.tableView indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        [self.tableView scrollRectToVisible:CGRectMake(cell.frame.origin.x, cell.frame.origin.y -1, cell.frame.size.width, cell.frame.size.height) animated:YES];
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
//    else if (textField == self.savingsTextField) {
//        [self enterSavingReason];
//        if (self.congratsView.alpha == 1.0) { // if we are still on congrats view
//            self.congratsView.duration = 1;
//            self.congratsView.type     = CSAnimationTypeFadeOut;
//            [self.congratsView startCanvasAnimation];
//            
//            [self transitionImagesWithSaveAmount];
//        }
//    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (self.savingsTextField == textField) {
        [self enterSavingReason];
    }
    
    return YES;
}

- (void)enterSavingReason
{
    if (![self.savingsTextField.text isEqualToString:@""]) {
        
        if (self.serverHasUpdatedSavingsEvents) {
            NSArray *savingEvents = [[[RDPUserService getUser] getGoal] getSavingEvents];
            RDPSavingEvent *mostRecentEvent = [savingEvents objectAtIndex:(savingEvents.count - 1)];
            [self updatingSavingEventWithID:mostRecentEvent.savingID withNewReason:self.savingsTextField.text];
        }
        else {
            self.savingReason = self.savingsTextField.text;
        }
        
        
        self.hasJustSaved = NO;
        
        void (^transitionBlock)(void) = ^{
            self.cutOutView.hidden = YES;
            self.easterEgg.hidden = NO;
            self.savingsTextField.text = @"";
        };
        
        
        [RDPTimerManager pauseFor:kWaitTimeToHideTextField millisecondsThen:transitionBlock];
    }
    
    if (self.congratsView.alpha == 1.0) { // if we are still on congrats view
        self.congratsView.duration = 1;
        self.congratsView.type     = CSAnimationTypeFadeOut;
        [self.congratsView startCanvasAnimation];
        
        [self transitionImagesWithSaveAmount];
    }
    
    self.scrollView.scrollEnabled = YES;
    [self goToSaveView];
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

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField != self.savingsTextField) {
        self.currentTextField = textField;
        UITableViewCell* cell = (UITableViewCell *) textField.superview.superview.superview.superview;
        CGFloat scrollHeight = 0;
        if (cell.frame.origin.x + cell.frame.size.height > kScreenHeight - self.keyboardHeight) {
            scrollHeight = (cell.frame.origin.x + cell.frame.size.height) - self.keyboardHeight;
        }
        self.shouldDismissKeyboardWhenScrolling = NO;
        CGFloat sectionHeaderHeight = kHeaderSectionHeight;
        if (self.tableView.contentOffset.y<=sectionHeaderHeight&&self.tableView.contentOffset.y>=0) {
            self.tableView.contentInset = UIEdgeInsetsMake(-self.tableView.contentOffset.y, 0, self.keyboardHeight + kSavingCellHeight, 0);
        } else if (self.tableView.contentOffset.y>=sectionHeaderHeight) {
            self.tableView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, self.keyboardHeight + kSavingCellHeight, 0);
        }
        else {
            self.tableView.contentInset =  UIEdgeInsetsMake(0, 0, self.keyboardHeight + kSavingCellHeight, 0);
        }
//        [self.tableView scrollToRowAtIndexPath:[self.tableView indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
//        self.tableView.contentInset =  UIEdgeInsetsMake(0, 0, self.keyboardHeight + kSavingCellHeight, 0);
        
    }
}

# pragma mark - Status Bar

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
