//
//  AlarmListTableViewController.m
//  AlarmMultiUser
//
//  Created by Ricardo Champa on 26/10/14.
//  Copyright (c) 2014 Daniel Portillo. All rights reserved.
//

#import "AlarmListTableViewController.h"
#import "AddEditAlarmViewController.h"
#import "AlarmObject.h"

@interface AlarmListTableViewController ()

@end

@implementation AlarmListTableViewController

@synthesize list_of_user_alarms;
@synthesize list_of_all_alarms;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 70;
    
    //self.automaticallyAdjustsScrollViewInsets = NO;
    //self.navigationController.navigationBar.translucent = YES;
    //self.tableView.backgroundColor = [UIColor clearColor];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UISwipeGestureRecognizer *swipeLeftRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [swipeLeftRight setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.view addGestureRecognizer:swipeLeftRight];
    
    UISwipeGestureRecognizer *swipeLeftRight2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [swipeLeftRight2 setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:swipeLeftRight2];
}

- (void)viewWillAppear:(BOOL)animated
{
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *alarmListData = [defaults objectForKey:@"AlarmListData"];
    
    NSMutableArray *user_alarms = [[NSMutableArray alloc] init];
    
    NSString *current_user = [[NSUserDefaults standardUserDefaults] stringForKey:@"current_user"];
    
    self.list_of_all_alarms = [NSKeyedUnarchiver unarchiveObjectWithData:alarmListData];
    
    for(AlarmObject *alarm in self.list_of_all_alarms){
        
        NSString *user_alarm = alarm.username;
        
        if([user_alarm isEqualToString:current_user]){
            [user_alarms addObject:alarm];
        }
    }
    
    self.list_of_user_alarms = user_alarms;
    [self.tableView reloadData];
    
    [super viewWillAppear:true];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    if(self.list_of_user_alarms){
        
        return [self.list_of_user_alarms count];
    }
    else return 0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[self performSegueWithIdentifier:@"add_edit_alarm_segue" sender:self];
    
    AddEditAlarmViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AddEditAlarmViewController"];
    controller.indexOfAlarmToEdit = self.tableView.indexPathForSelectedRow.row;
    controller.editMode = YES;
    controller.old_alarm_object = [list_of_user_alarms objectAtIndex:controller.indexOfAlarmToEdit];
    
    [self.navigationController pushViewController:controller animated:YES];
    
}


- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDateFormatter * dateReader = [[NSDateFormatter alloc] init];
    [dateReader setDateFormat:@"hh:mm a"];
    AlarmObject *currentAlarm = [self.list_of_user_alarms objectAtIndex:indexPath.row];
    
    NSString *label = currentAlarm.label;
    BOOL enabled = currentAlarm.enabled;
    NSString *date = [dateReader stringFromDate:currentAlarm.timeToSetOff];
    
    
    UILabel *topLabel;
    UILabel *bottomLabel;
    UISwitch *enabledSwitch;
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell;/*= [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];*/
    if (cell == nil)
    {
        //
        // Create the cell.
        //
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:CellIdentifier];
        
        //
        // Create the label for the top row of text
        //
        topLabel = [[UILabel alloc]	initWithFrame:CGRectMake(14,5,170,40)];
        [cell.contentView addSubview:topLabel];
        
        //
        // Configure the properties for the text that are the same on every row
        //
        topLabel.backgroundColor = [UIColor clearColor];
        topLabel.textColor = [UIColor blackColor];
        topLabel.highlightedTextColor = [UIColor whiteColor];
        topLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize]+2];
        
        //
        // Create the label for the top row of text
        //
        bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(14,30,170,40)];
        [cell.contentView addSubview:bottomLabel];
        
        //
        // Configure the properties for the text that are the same on every row
        //
        bottomLabel.backgroundColor = [UIColor clearColor];
        bottomLabel.textColor = [UIColor blackColor];
        bottomLabel.highlightedTextColor = [UIColor whiteColor];
        bottomLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize]];
        
        
        enabledSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(200,20,170,40)];
        enabledSwitch.tag = indexPath.row;
        [enabledSwitch  addTarget:self
                           action:@selector(toggleAlarmEnabledSwitch:)
                 forControlEvents:UIControlEventTouchUpInside];
        
        [cell.contentView addSubview:enabledSwitch];
        
        [enabledSwitch setOn:enabled];
        topLabel.text = date;
        bottomLabel.text = label;
        
    }
    
    return cell;

}


-(void)toggleAlarmEnabledSwitch:(id)sender
{
    UISwitch *mySwitch = (UISwitch *)sender;
    
    if(mySwitch.isOn == NO)
    {
        UIApplication *app = [UIApplication sharedApplication];
        NSArray *eventArray = [app scheduledLocalNotifications];
        AlarmObject *currentAlarm = [self.list_of_user_alarms objectAtIndex:mySwitch.tag];
        currentAlarm.enabled = NO;
        for (int i=0; i<[eventArray count]; i++)
        {
            UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
            NSDictionary *userInfoCurrent = oneEvent.userInfo;
            NSString *uid=[NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"notificationID"]];
            if ([uid isEqualToString:[NSString stringWithFormat:@"%i",mySwitch.tag]])
            {
                //Cancelling local notification
                [app cancelLocalNotification:oneEvent];
                break;
            }
        }
        
    }
    else if(mySwitch.isOn == YES)
    {
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        AlarmObject *currentAlarm = [self.list_of_user_alarms objectAtIndex:mySwitch.tag];
        currentAlarm.enabled = YES;
        if (!localNotification)
            return;
        
        //localNotification.repeatInterval = NSDayCalendarUnit;
        localNotification.repeatInterval = NSCalendarUnitDay;
        [localNotification setFireDate:currentAlarm.timeToSetOff];
        [localNotification setTimeZone:[NSTimeZone defaultTimeZone]];
        // Setup alert notification
        [localNotification setAlertBody:@"Alarm" ];
        [localNotification setAlertAction:@"Open App"];
        [localNotification setHasAction:YES];
        
        
        NSNumber* uidToStore = [NSNumber numberWithInt:currentAlarm.notificationID];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:uidToStore forKey:@"notificationID"];
        localNotification.userInfo = userInfo;
        
        // Schedule the notification
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
    NSData *alarmListData2 = [NSKeyedArchiver archivedDataWithRootObject:self.list_of_all_alarms];
    [[NSUserDefaults standardUserDefaults] setObject:alarmListData2 forKey:@"AlarmListData"];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)handleSwipe:(UISwipeGestureRecognizer *)gestureRecognizer{
    
    
    if(gestureRecognizer.direction==UISwipeGestureRecognizerDirectionRight){
        NSLog(@"right");
        NSUInteger index = [self.tabBarController selectedIndex];
        [self.tabBarController setSelectedIndex:index-1];
        
    }
    else if(gestureRecognizer.direction==UISwipeGestureRecognizerDirectionLeft){
        NSLog(@"left");
        NSUInteger index = [self.tabBarController selectedIndex];
        [self.tabBarController setSelectedIndex:index+1];
    }
    
}
@end
