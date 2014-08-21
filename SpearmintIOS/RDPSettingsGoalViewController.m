//
//  RDPSettingsGoalViewController.m
//  SpearmintIOS
//
//  Created by Matthew Ziegler on 8/4/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPSettingsGoalViewController.h"
#import "RDPTableViewCellWithInput.h"
#import "RDPUserService.h"
#import "RDPImageFetcher.h"
#import "RDPDataHolder.h"
#import "RDPAnalyticsModule.h"

#define kCellXibName                    @"RDPTableViewCellWithInput"
#define kCellReusableIdentifier         @"InputCell"

#define kGoalNameIdentifier             @"goalName"
#define kGoalAmountIdentifier           @"goalAmount"
#define kGoalAmountSavedIdentifier      @"goalAmountSaved"

#define kNameKey                        @"name"
#define kIdentifierKey                  @"identifier"
#define kPlaceholderKey                 @"placeholder"

#define kCellHeight                     62

#define kGoalNameTag                    1
#define kGoalTargetAmountTag            2
#define kGoalAmountSavedTag             3

@interface RDPSettingsGoalViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray* goalOptions;
@property (strong, nonatomic) RDPUser* modifiedUser;
@property (strong, nonatomic) NSNumberFormatter* numberFormatter;

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
    UIImage* backgroundImage = [[RDPImageFetcher getImageFetcher] getCurrentBlurredImage];
    
    backgroundImage = [UIImage imageWithCGImage:backgroundImage.CGImage
                                          scale:backgroundImage.scale
                                    orientation:UIImageOrientationUpMirrored];
    
    UIImageView* imageView = [[UIImageView alloc] initWithImage:backgroundImage];
    
    [self.navigationController.view insertSubview:imageView atIndex:2];
    imageView.frame = CGRectMake(self.navigationController.view.frame.origin.x,
                                 self.navigationController.view.frame.origin.y,
                                 self.navigationController.view.frame.size.width,
                                 self.navigationController.view.frame.size.height);
    imageView.contentMode = UIViewContentModeScaleToFill;
    
    [self setNavigationBarColor:kColor_SettingPanelHeader];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.tableView registerNib:[UINib nibWithNibName:kCellXibName bundle:nil] forCellReuseIdentifier:kCellReusableIdentifier];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setBackgroundColor:kColor_Transparent];
    self.tableView.alwaysBounceVertical = NO;
    self.modifiedUser = [RDPUserService getUser];
    self.numberFormatter = [[NSNumberFormatter alloc] init];
    // Get the reference to the current toolbar buttons
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
    
    NSDictionary* goalInfo = [self.goalOptions objectAtIndex:indexPath.row];
    
    [cell.inputView.label setText:[goalInfo objectForKey:kNameKey]];
    [cell.inputView.label setFont:[RDPFonts fontForID:fSectionHeaderFont]];
    [cell.inputView.label setTextColor:kColor_DarkText];
    cell.backgroundColor = kColor_Transparent;
    [cell.inputView setBackgroundColor:kColor_PanelColor];
    [cell.inputView.input setBackgroundColor:kColor_Transparent];
    cell.inputView.input.textFieldColor = kColor_InputFieldColor;
    cell.inputView.input.borderRadius = 4;
    cell.inputView.input.parentColor = kColor_PanelColor;
    cell.inputView.input.indentAmount = 10;
    [cell.inputView.input setPlaceholder:[goalInfo objectForKey:kPlaceholderKey]];
    [cell.inputView.input setTextColor:kColor_WhiteText];
    [cell.contentView setBackgroundColor:kColor_Transparent];
    cell.inputView.input.delegate = self;
    [cell.inputView.input addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
    
    if ([[goalInfo objectForKey:kIdentifierKey] isEqualToString:kGoalNameIdentifier]) {
        cell.inputView.input.text = [[[RDPUserService getUser] getGoal] getGoalName];
        cell.inputView.input.tag = kGoalNameTag;
    }
    else if ([[goalInfo objectForKey:kIdentifierKey]  isEqualToString: kGoalAmountIdentifier]) {
        cell.inputView.input.text = [[[[RDPUserService getUser] getGoal] getTargetAmount] description];
        [cell.inputView.input setKeyboardType:UIKeyboardTypeNumberPad];
        cell.inputView.input.tag = kGoalTargetAmountTag;
    }
    else if ([[goalInfo objectForKey:kIdentifierKey]  isEqualToString: kGoalAmountSavedIdentifier]) {
        cell.inputView.input.text = [[[[RDPUserService getUser] getGoal] getCurrentAmount] description];
        [cell.inputView.input setKeyboardType:UIKeyboardTypeNumberPad];
        cell.inputView.input.tag = kGoalAmountSavedTag;
    }
    
    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    RDPResponseCode status;
    BOOL dirty = NO;
    BOOL valid = YES;
    
    if (kGoalNameTag == textField.tag) {
        if (![[[[RDPUserService getUser] getGoal] getGoalName] isEqualToString:textField.text]) {
            dirty = YES;
            status = [[self.modifiedUser getGoal] setGoalName:textField.text];
            if (RDPResponseCodeOK != status) {
                valid = NO;
            }
        }
    }
    
    if (dirty && valid) {
        [RDPUserService saveUser:self.modifiedUser withResponse:^(RDPResponseCode response) {
            if (RDPResponseCodeOK == response) {
                [RDPDataHolder getDataHolder].reachedGoal = NO;
                self.modifiedUser = [RDPUserService getUser];
            }
        }];
    }
    if (valid) {
        [RDPAnalyticsModule track:@"Settings" properties:@{@"action" : @"editGoal"}];
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (BOOL)textFieldDidChange:(UITextField *)textField
{
    BOOL dirty = NO;
    BOOL valid = YES;
    RDPResponseCode status;
    NSString* value = textField.text;
    
    if (kGoalNameTag == textField.tag) {
        if (![[[[RDPUserService getUser] getGoal] getGoalName] isEqualToString:textField.text]) {
            dirty = YES;
            status = [[self.modifiedUser getGoal] setGoalName:textField.text];
            if (RDPResponseCodeOK != status) {
                valid = NO;
            }
        }
    }
    else if (kGoalTargetAmountTag == textField.tag) {
        if (![[[[[RDPUserService getUser] getGoal] getTargetAmount] description] isEqualToString:textField.text]) {
            dirty = YES;
            if ([value isEqualToString:@""]) {
                value = @"0";
            }
            status = [[self.modifiedUser getGoal] setTargetAmount:[self.numberFormatter numberFromString:value]];
            if (RDPResponseCodeOK != status) {
                valid = NO;
            }
        }
    }
    else if (kGoalAmountSavedTag == textField.tag) {
        if (![[[[[RDPUserService getUser] getGoal] getCurrentAmount] description] isEqualToString:textField.text]) {
            dirty = YES;
            if ([value isEqualToString:@""]) {
                value = @"0";
            }
            status = [[self.modifiedUser getGoal] setCurrentAmount:[self.numberFormatter numberFromString:textField.text]];
            if (RDPResponseCodeOK != status) {
                valid = NO;
            }
        }
    }
    return YES;
}


- (IBAction)cancelPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [RDPUserService saveUser:self.modifiedUser withResponse:^(RDPResponseCode response) {
        if (RDPResponseCodeOK == response) {
            [RDPDataHolder getDataHolder].reachedGoal = NO;
        }
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
