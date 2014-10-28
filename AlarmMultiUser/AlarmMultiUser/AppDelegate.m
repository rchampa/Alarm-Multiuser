//
//  AppDelegate.m
//  AlarmMultiUser
//
//  Created by Ricardo Champa on 26/10/14.
//  Copyright (c) 2014 Daniel Portillo. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "LoginViewController.h"
#import "UserSettingsObject.h"
#import "RootTabBarController.h"

@interface AppDelegate ()
{
    UIAlertView *alarmAlert;
}

@end

@implementation AppDelegate

@synthesize player;


/*
 - (void)applicationDidFinishLaunching:(UIApplication *)application {
    
    application.applicationSupportsShakeToEdit = YES;
    
    RootTabBarController* controller = (RootTabBarController *) self.window.rootViewController;
    [self.window addSubview:controller.view];
    [self.window makeKeyAndVisible];
}
 */

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    application.applicationSupportsShakeToEdit = YES;

    
    //request to user permissions for notifications
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        //older than iOS 8 code here
    } else {
        //iOS 8 specific code here
        //request to user permissions for notifications
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    
    //Prevents screen from locking
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    
    //check if is the first time the app is launched
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
    {
        // app already launched
        NSLog(@"Loading users...");
        
        //Check if the users exists
        /*
        NSArray *users_saved_array = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"users"]] ;
        
        for (id user in users_saved_array) {
            NSLog(@"%@",user);
        }
         */
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *userListData = [defaults objectForKey:@"UserListData"];
        NSMutableArray *users_list = [NSKeyedUnarchiver unarchiveObjectWithData:userListData];
        
        for (UserSettingsObject *user in users_list) {
             NSLog(@"%@",user.username);
        }
        
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        // This is the first launch ever
        
        NSMutableArray *users_list = [[NSMutableArray alloc] init];
        
        UserSettingsObject *user = [[UserSettingsObject alloc] init];
        user.username = @"user1";
        user.password = @"user1";
        user.vibration = NO;
        user.day_of_weak = NO;
        user.day_of_month = NO;
        user.month = NO;
        user.year = NO;
        
        UserSettingsObject *user2 = [[UserSettingsObject alloc] init];
        user2.username = @"user2";
        user2.password = @"user2";
        user2.vibration = NO;
        user2.day_of_weak = NO;
        user2.day_of_month = NO;
        user2.month = NO;
        user2.year = NO;
        
        [users_list addObject:user];
        [users_list addObject:user2];
        
        
        //saving users list
        NSData *userListData = [NSKeyedArchiver archivedDataWithRootObject:users_list];
        [[NSUserDefaults standardUserDefaults] setObject:userListData forKey:@"UserListData"];
        
        
        //unique ID for alarms
        int first_id = 1;
        [[NSUserDefaults standardUserDefaults] setInteger:first_id forKey:@"id_counter"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
    BOOL isLogged = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogged"];
    
    if(!isLogged){
        [self showLoginScreen];
    }
    
    return YES;
    
}

-(void) showLoginScreen
{
    
    UIViewController* rootController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"LoginViewController"];
    UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:rootController];
    
    self.window.rootViewController = navigation;
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}







-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    
    NSDictionary *userInfo = notification.userInfo;
    
    NSString *song = [userInfo objectForKey:@"song"];
    
    NSString *path;
    
    if([song isEqualToString:@"Mario"]){
        path = [[NSBundle mainBundle] pathForResource:@"mario_alarm" ofType:@"m4r"];
    }
    else if([song isEqualToString:@"CSI"]){
        path = [[NSBundle mainBundle] pathForResource:@"csi_alarm" ofType:@"m4r"];
    }
    else{
        path = [[NSBundle mainBundle] pathForResource:@"Best_Morning_Alarm" ofType:@"m4r"];
    }
    
    NSURL *file = [[NSURL alloc] initFileURLWithPath:path];
    
    self.player =[[AVAudioPlayer alloc] initWithContentsOfURL:file error:nil];
    [self.player prepareToPlay];
    [self.player play];
    
    //showing alert message
    NSString *label = [userInfo objectForKey:@"label"];
    
    
    alarmAlert = [[UIAlertView alloc] initWithTitle:label
                                                         message:@"Press okay to stop"
                                                        delegate:self
                                               cancelButtonTitle:@"okay"
                                               otherButtonTitles:nil, nil];
    [alarmAlert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        //AppDelegate * myAppDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        //[myAppDelegate.player stop];
        [player stop];
    }
    else{
        //do nothing
    }
}

- (void)cancelAlertView{
    
    if(alarmAlert)
        [alarmAlert dismissWithClickedButtonIndex:0 animated:YES];
    
}

@end
