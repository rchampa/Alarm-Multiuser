//
//  LoginViewController.m
//  AlarmMultiUser
//
//  Created by Ricardo Champa on 26/10/14.
//  Copyright (c) 2014 Daniel Portillo. All rights reserved.
//

#import "LoginViewController.h"
#import "AlarmObject.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize tf_username;
@synthesize tf_password;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    //if ([identifier isEqualToString:@"Identifier Of Segue Under Scrutiny"]) {
    // perform your computation to determine whether segue should occur
    
    BOOL segueShouldOccur = NO;
    
    //by default disable all alarms before login
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *alarmListData = [defaults objectForKey:@"AlarmListData"];
    NSMutableArray *list_of_all_alarms = [NSKeyedUnarchiver unarchiveObjectWithData:alarmListData];
    
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *eventArray = [app scheduledLocalNotifications];
    
    for (int i=0; i<[eventArray count]; i++)
    {
        UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
        //NSDictionary *userInfoCurrent = oneEvent.userInfo;
        //NSString *uid=[NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"notificationID"]];
        
        [app cancelLocalNotification:oneEvent];
    }
    
    
    
    NSArray *users_saved_array = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"users"]] ;
    
    NSString *user_name = [tf_username text];
    
    for (id user in users_saved_array) {
        if([user isEqualToString:user_name]){
            segueShouldOccur = YES;
            //set the loged user as current user
            [[NSUserDefaults standardUserDefaults] setObject:user forKey:@"current_user"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            //re activate alarms that belongs to user
            
            for (AlarmObject *alarm in list_of_all_alarms) {
                if ([user isEqualToString:alarm.username]) {
                    [self scheduleAnAlarm:alarm];
                }
            }
            
        }
    }
    
    if (!segueShouldOccur) {
        UIAlertView *notPermitted = [[UIAlertView alloc]
                                     initWithTitle:@"Error"
                                     message:@"Usuario no valido"
                                     delegate:nil
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
        
        // shows alert to user
        [notPermitted show];
        
        // prevent segue from occurring
        return NO;
    }
    //}
    
    // by default perform the segue transition
    return YES;
}


- (void)scheduleAnAlarm:(AlarmObject *)currentAlarm {
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
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

@end
