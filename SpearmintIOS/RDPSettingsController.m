//
//  RDPSettingsController.m
//  SpearmintIOS
//
//  Created by Matthew Ziegler on 8/3/14.
//  Copyright (c) 2014 Spearmint. All rights reserved.
//

#import "RDPSettingsController.h"
#import "RDPViewController.h"
#import "RDPTableViewCellWithName.h"
#import "UINavigationController+Retro.h"
#import "RDPPushAnimation.h"


#define kKeyName                    @"name"
#define kKeySelector                @"selector"

#define kCellReusableIdentifier     @"settingsCell"
#define kCellXibName                @"RDPTableViewCellWithName"

#define kSegueToMyGoal              @"segueToMyGoal"
#define kSegueToNotifications       @"segueToNotifications"
#define kSegueToHistory             @"segueToHistory"
#define kSegueToFeedback            @"segueToFeedback"

#define kStoryboard                 @"Main"

#define kMyGoalIdentifier           @"settingsMyGoal"
#define kNotificationsIdentifier    @"settingsNotifications"
#define kHistoryIdentifier          @"settingsHistory"
#define kFeedbackIdentifier         @"settingsFeedback"

@interface RDPSettingsController ()

@property (nonatomic, strong) NSArray* menuItems;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UIView *statusBarBackground;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RDPSettingsController

- (NSArray*)menuItems
{
    if (!_menuItems) {
        _menuItems = @[@{kKeyName : [RDPStrings stringForID:sMyGoal],
                         kKeySelector : NSStringFromSelector(@selector(goalsTapped))
                         },
                       @{kKeyName : [RDPStrings stringForID:sNotificationSettings],
                         kKeySelector : NSStringFromSelector(@selector(notificationsTapped))
                         },
                       @{kKeyName : [RDPStrings stringForID:sHistory],
                         kKeySelector : NSStringFromSelector(@selector(historyTapped))
                         },
                       @{kKeyName : [RDPStrings stringForID:sSubmitFeedback],
                         kKeySelector : NSStringFromSelector(@selector(feedbackTapped))
                         },
                       @{kKeyName : [RDPStrings stringForID:sRateTheApp],
                         kKeySelector : NSStringFromSelector(@selector(rateTapped))
                         }
                       ];
    }
    return _menuItems;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    myNavController.view insertSubview:myImageView atIndex:0
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"5_blur.jpg"]];
    [self.navigationController.view insertSubview:imageView atIndex:0];
    [self.navigationController.navigationBar setBackgroundColor:kColor_SettingPanelHeader];
    [self.logoutButton setTitle:[RDPStrings stringForID:sLogout] forState:UIControlStateNormal];
    [self.logoutButton setBackgroundColor:kColor_LogoutButtonPanelColor];
    [self.logoutButton setTintColor:kColor_LightText];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.navigationController.delegate = self;
    [self.view setBackgroundColor:kColor_Transparent];
    [self.tableView setBackgroundColor:kColor_Transparent];
    self.tableView.alwaysBounceVertical = NO;
    [self.tableView registerNib:[UINib nibWithNibName:kCellXibName bundle:nil] forCellReuseIdentifier:kCellReusableIdentifier];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                             forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    [self.statusBarBackground setBackgroundColor:kColor_SettingPanelHeader];
    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [RDPFonts fontForID:fNavigationHeaderFont],
      NSFontAttributeName, nil]];
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.menuItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RDPTableViewCellWithName *cell = [tableView dequeueReusableCellWithIdentifier:kCellReusableIdentifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[RDPTableViewCellWithName alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellReusableIdentifier];
    }
    
    [cell.cellLabel setText:[[self.menuItems objectAtIndex:indexPath.row] objectForKey:kKeyName]];
    [cell.cellLabel setFont:[RDPFonts fontForID:fMenuFont]];
    [cell.cellLabel setTextColor:kColor_DarkText];
    [cell setBackgroundColor:kColor_Transparent];
    [cell.contentView setBackgroundColor:kColor_PanelColor];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SEL selector = NSSelectorFromString([[self.menuItems objectAtIndex:indexPath.row] objectForKey:kKeySelector]);
    if (selector) {
//        [self performSelector:selector];
        ((void (*)(id, SEL))[self methodForSelector:selector])(self, selector);
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    
    RDPPushAnimation* pushAnimation = [RDPPushAnimation new];
    pushAnimation.navigationControllerOperation = operation;
    return pushAnimation;
}

#pragma mark tap handlers
                       
-(void)goalsTapped
{
    UIViewController *viewController =
    [[UIStoryboard storyboardWithName:kStoryboard
                               bundle:NULL] instantiateViewControllerWithIdentifier:kMyGoalIdentifier];
    
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)notificationsTapped
{
    UIViewController *viewController =
    [[UIStoryboard storyboardWithName:kStoryboard
                               bundle:NULL] instantiateViewControllerWithIdentifier:kNotificationsIdentifier];
    
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)historyTapped
{
    UIViewController *viewController =
    [[UIStoryboard storyboardWithName:kStoryboard
                               bundle:NULL] instantiateViewControllerWithIdentifier:kHistoryIdentifier];
    
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)feedbackTapped
{
    UIViewController *viewController =
    [[UIStoryboard storyboardWithName:kStoryboard
                               bundle:NULL] instantiateViewControllerWithIdentifier:kFeedbackIdentifier];
    
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)rateTapped
{
    NSLog(@"Rate app");
}

-(void)logoutTapped
{
    
}

@end
