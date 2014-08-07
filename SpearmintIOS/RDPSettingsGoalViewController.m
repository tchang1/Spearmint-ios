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
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (strong, nonatomic) RDPUser* modifiedUser;

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
    self.modifiedUser = [RDPUserService getUser];
    // Get the reference to the current toolbar buttons
    [self hideSaveButton];
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
    [cell.inputView setBackgroundColor:kColor_PanelColor];
    [cell.inputView setInputBackgroundColor:kColor_InputFieldColor];
    [cell.inputView.input setPlaceholder:[goalInfo objectForKey:kPlaceholderKey]];
    [cell.contentView setBackgroundColor:kColor_Transparent];
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
            status = [[self.modifiedUser getGoal] setTargetAmount:[[RDPConfig numberFormatter] numberFromString:value]];
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
            status = [[self.modifiedUser getGoal] setCurrentAmount:[[RDPConfig numberFormatter] numberFromString:textField.text]];
            if (RDPResponseCodeOK != status) {
                valid = NO;
            }
        }
    }
    
    if (dirty && valid) {
        [self showSaveButton];
    }
    else {
        [self hideSaveButton];
    }
    return YES;
}

- (void)hideSaveButton
{
    NSMutableArray *toolbarButtons = [self.navigationItem.rightBarButtonItems mutableCopy];
    [toolbarButtons removeObject:self.saveButton];
    [self.navigationItem setRightBarButtonItems:toolbarButtons animated:YES];
}

- (void)showSaveButton
{
    NSMutableArray *toolbarButtons = [self.navigationItem.rightBarButtonItems mutableCopy];
    // This is how you add the button to the toolbar and animate it
    if (![toolbarButtons containsObject:self.saveButton]) {
        // The following line adds the object to the end of the array.
        // If you want to add the button somewhere else, use the `insertObject:atIndex:`
        // method instead of the `addObject` method.
        [toolbarButtons addObject:self.saveButton];
        [self.navigationItem setRightBarButtonItems:toolbarButtons animated:YES];
    }
}

- (IBAction)cancelPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)savePressed:(id)sender {
    [RDPUserService saveUser:self.modifiedUser withResponse:^(RDPResponseCode response) {
        if (RDPResponseCodeOK == response) {
            self.modifiedUser = [RDPUserService getUser];
            [self hideSaveButton];
            
        }
    }];
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
