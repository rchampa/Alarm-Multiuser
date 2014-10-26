//
//  AppDelegate.m
//  AlarmMultiUser
//
//  Created by Ricardo Champa on 26/10/14.
//  Copyright (c) 2014 Daniel Portillo. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize player;

//change to home
- (void)setupWindowWith:(UILocalNotification *)notification
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    HomeViewController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"HomeView"];
    rootViewController.alarmGoingOff = YES;
    rootViewController.local_notification = notification;
    self.window.rootViewController = rootViewController;
    [self.window makeKeyAndVisible];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
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
    UILocalNotification *localNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    
    if (localNotif)
    {
        [self setupWindowWith:localNotif];
    }
    
    
    //check if is the first time the app is launched
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
    {
        // app already launched
        
        NSLog(@"Loading users...");
        
        //Check if the users exists
        NSArray *users_saved_array = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"users"]] ;
        
        for (id user in users_saved_array) {
            NSLog(@"%@",user);
        }
        
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        // This is the first launch ever
        
        // let's take the NSString as example
        NSArray *users_array = @[@"user1", @"user2", @"user3"];
        
        [[NSUserDefaults standardUserDefaults] setObject: [NSKeyedArchiver archivedDataWithRootObject:users_array] forKey:@"users"];
        
        int first_id = 1;
        [[NSUserDefaults standardUserDefaults] setInteger:first_id forKey:@"id_counter"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
    return YES;
    
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
    
    //changing to HomeView
    [self setupWindowWith:notification];
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

@end
