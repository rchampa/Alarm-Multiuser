//
//  LoginViewController.m
//  AlarmMultiUser
//
//  Created by Ricardo Champa on 26/10/14.
//  Copyright (c) 2014 Daniel Portillo. All rights reserved.
//

#import "LoginViewController.h"
#import "AlarmObject.h"
#import "AppDelegate.h"
#import "UserSettingsObject.h"

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

- (IBAction)authenticate {
    
    BOOL segueShouldOccur = NO;
    
    //by default remove all alarms before login
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
    
    NSString *user_name = [tf_username text];
    NSString *password = [tf_password text];
    
    NSData *userListData = [defaults objectForKey:@"UserListData"];
    NSMutableArray *users_list = [NSKeyedUnarchiver unarchiveObjectWithData:userListData];
    
    for (UserSettingsObject *user in users_list) {
        
        if([user.username isEqualToString:user_name] && [user.password isEqualToString:password]){
            segueShouldOccur = YES;
            //set the loged user as current user
            [[NSUserDefaults standardUserDefaults] setObject:user.username forKey:@"current_user"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSLog(@"Vibration");
            NSLog(user.vibration ? @"Yes" : @"No");
            NSLog(@"day_of_weak");
            NSLog(user.day_of_weak ? @"Yes" : @"No");
            NSLog(@"day_of_month");
            NSLog(user.day_of_month ? @"Yes" : @"No");
            NSLog(@"month");
            NSLog(user.month ? @"Yes" : @"No");
            NSLog(@"year");
            NSLog(user.year ? @"Yes" : @"No");
            
            //re activate alarms that belongs to user
            
            for (AlarmObject *alarm in list_of_all_alarms) {
                if ([user.username isEqualToString:alarm.username]) {
                    [self scheduleAnAlarm:alarm];
                }
            }
            
        }
    }
    
    
    if (!segueShouldOccur) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogged"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        UIAlertView *notPermitted = [[UIAlertView alloc]
                                     initWithTitle:@"Error"
                                     message:@"Usuario no valido"
                                     delegate:nil
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
        
        // shows alert to user
        [notPermitted show];
        
        
    }
    else{
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogged"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
        
        appDelegateTemp.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
    }
    

}
@end
