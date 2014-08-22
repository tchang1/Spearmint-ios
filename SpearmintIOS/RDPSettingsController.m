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

#import "RDPImageFetcher.h"
#import "RDPUserService.h"
#import "RDPAnalyticsModule.h"
#import "RDPDataHolder.h"


#define kKeyName                    @"name"
#define kKeySelector                @"selector"

#define kCellReusableIdentifier     @"settingsCell"
#define kCellXibName                @"RDPTableViewCellWithName"

#define kSegueToMyGoal              @"segueToMyGoal"
#define kSegueToNotifications       @"segueToNotifications"
#define kSegueToHistory             @"segueToHistory"
#define kSegueToFeedback            @"segueToFeedback"

#define kStoryboard                 @"Main"
#define kRDPLoginViewController     @"RDPLoginViewController"

#define kMyGoalIdentifier           @"settingsMyGoal"
#define kNotificationsIdentifier    @"settingsNotifications"
#define kFeedbackIdentifier         @"settingsFeedback"

#define kLogoutSegue                @"logoutSegue"

#define kStatusBarHeight            38
#define kCellHeight                 55

@interface RDPSettingsController ()

@property (nonatomic, strong) NSArray* menuItems;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RDPSettingsController

- (NSArray*)menuItems
{
    if (!_menuItems) {
        _menuItems = @[@{kKeyName : [RDPStrings stringForID:sMyGoal],
                         kKeySelector : NSStringFromSelector(@selector(navigateToMyGoal))
                         },
                       @{kKeyName : [RDPStrings stringForID:sNotificationSettings],
                         kKeySelector : NSStringFromSelector(@selector(notificationsTapped))
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
    UIImage* backgroundImage = [[RDPImageFetcher getImageFetcher] getCurrentBlurredImage];
    
    backgroundImage = [UIImage imageWithCGImage:backgroundImage.CGImage
                                                scale:backgroundImage.scale
                                          orientation:UIImageOrientationUpMirrored];
    
    [self setPersistentBackgroundImage:backgroundImage];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self setNavigationBarColor:kColor_SettingPanelHeader];
    
    [self.logoutButton setTitle:[RDPStrings stringForID:sLogout] forState:UIControlStateNormal];
    [self.logoutButton setBackgroundColor:kColor_LogoutButtonPanelColor];
    [self.logoutButton setTintColor:kColor_LightText];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view setBackgroundColor:kColor_Transparent];
    [self.tableView setBackgroundColor:kColor_Transparent];
    self.tableView.alwaysBounceVertical = NO;
    [self.tableView registerNib:[UINib nibWithNibName:kCellXibName bundle:nil] forCellReuseIdentifier:kCellReusableIdentifier];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [RDPFonts fontForID:fNavigationHeaderFont],
      NSFontAttributeName, nil]];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar.layer removeAllAnimations];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
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
    if ([segue.identifier isEqualToString:kLogoutSegue]) {
        [RDPUserService logoutWithResponse:^(RDPResponseCode response) {
            if (response==RDPResponseCodeOK)
            {
                NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
                for (NSHTTPCookie *each in cookieStorage.cookies) {
                    [cookieStorage deleteCookie:each];
                }
                [RDPAnalyticsModule track:@"Logged Out"];
            }
            else
            {
                [RDPAnalyticsModule track:@"Error logging out"];
            }
        }];
    }
}

#pragma mark tap handlers
                       
-(void)navigateToMyGoal
{
    [RDPAnalyticsModule track:@"Settings" properties:@{@"location" : @"myGoal"}];

    RDPViewController *viewController =
    [[UIStoryboard storyboardWithName:kStoryboard
                               bundle:NULL] instantiateViewControllerWithIdentifier:kMyGoalIdentifier];
    
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)notificationsTapped
{
    [RDPAnalyticsModule track:@"Settings" properties:@{@"location" : @"notifications"}];

    RDPViewController *viewController =
    [[UIStoryboard storyboardWithName:kStoryboard
                               bundle:NULL] instantiateViewControllerWithIdentifier:kNotificationsIdentifier];
    
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)feedbackTapped
{
    [RDPAnalyticsModule track:@"Settings" properties:@{@"location" : @"feedback"}];

    RDPViewController *viewController =
    [[UIStoryboard storyboardWithName:kStoryboard
                               bundle:NULL] instantiateViewControllerWithIdentifier:kFeedbackIdentifier];
    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)backTapped:(id)sender {
    [self removeStatusBar];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    if ([RDPDataHolder getDataHolder].homeController) {
//        [self.navigationController popToViewController:[RDPDataHolder getDataHolder].homeController animated:YES];
        [self.RDPNavigationController popToViewController:[RDPDataHolder getDataHolder].homeController withAnimation:RDPTransitionAnimationFlipLeft];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(void)rateTapped
{
    [RDPAnalyticsModule track:@"Settings" properties:@{@"location" : @"Rate app"}];

    //DevNSLog(@"Rate app");
}

- (IBAction)logoutTapped:(id)sender {
    [RDPUserService logoutWithResponse:^(RDPResponseCode response) {
        if (response==RDPResponseCodeOK)
        {
            NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            for (NSHTTPCookie *each in cookieStorage.cookies) {
                [cookieStorage deleteCookie:each];
            }
            [RDPAnalyticsModule track:@"Logged Out"];
            UIViewController* rootController = [[UIStoryboard storyboardWithName:kStoryboard
                                                                          bundle:NULL] instantiateViewControllerWithIdentifier:kRDPLoginViewController];
            [self clearNavigationView];
            [self.navigationController setViewControllers:@[rootController] animated:YES];
        }
        else
        {
            [RDPAnalyticsModule track:@"Error logging out"];
        }
    }];
}


@end
