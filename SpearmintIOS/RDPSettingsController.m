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

#define kKeyName                    @"name"
#define kKeySelector                @"selector"

#define kCellReusableIdentifier     @"settingsCell"
#define kCellXibName                @"RDPTableViewCellWithName"

#define kSegueToMyGoal              @"segueToMyGoal"
#define kSegueToNotifications       @"segueToNotifications"
#define kSegueToHistory             @"segueToHistory"
#define kSegueToFeedback            @"segueToFeedback"

@interface RDPSettingsController ()

@property (nonatomic, strong) NSArray* menuItems;

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

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.alwaysBounceVertical = NO;
    [self.tableView registerNib:[UINib nibWithNibName:kCellXibName bundle:nil] forCellReuseIdentifier:kCellReusableIdentifier];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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


#pragma mark tap handlers
                       
-(void)goalsTapped
{
    [self performSegueWithIdentifier:kSegueToMyGoal sender:self];
}

-(void)notificationsTapped
{
    [self performSegueWithIdentifier:kSegueToNotifications sender:self];}

-(void)historyTapped
{
    [self performSegueWithIdentifier:kSegueToHistory sender:self];
}

-(void)feedbackTapped
{
    [self performSegueWithIdentifier:kSegueToFeedback sender:self];
}

-(void)rateTapped
{
    NSLog(@"Rate app");
}

-(void)logoutTapped
{
    
}
                       
#pragma mark segues

-(void)segueToMyGoal:(RDPViewController*)goalController
{
    
}

-(void)segueToNotifications:(RDPViewController*)notificationsController
{
    
}

// history
-(void)segueToHistory:(RDPViewController*)historyController
{
    
}


// feedback
-(void)segueToFeedback:(RDPViewController*)feedbackController
{
    
}

@end
