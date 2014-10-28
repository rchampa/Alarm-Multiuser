//
//  HomeViewController.m
//  AlarmMultiUser
//
//  Created by Ricardo Champa on 26/10/14.
//  Copyright (c) 2014 Daniel Portillo. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"
#import "UserSettingsObject.h"
#import "SettingsViewController.h"


@interface HomeViewController ()
{
    UserSettingsObject *current_user_settings;
    BOOL first_time;
}

@end

@implementation HomeViewController

@synthesize hour1Label;
@synthesize hour2Label;
@synthesize minute1Label;
@synthesize minute2Label;
@synthesize colonLabel;
@synthesize monthYearLabel;
@synthesize alarmGoingOff;
@synthesize local_notification;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.navigationController.navigationBarHidden = YES;
    
   
    
    NSString *current_user = [[NSUserDefaults standardUserDefaults] stringForKey:@"current_user"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *userListData = [defaults objectForKey:@"UserListData"];
    NSMutableArray *users_list = [NSKeyedUnarchiver unarchiveObjectWithData:userListData];
    
    for (UserSettingsObject *user in users_list) {
        if([user.username isEqualToString:current_user]){
            current_user_settings = user;
            break;
        }
    }
    
    first_time = YES;
    
    
    [self myTimerAction];
    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
    //How often to update the clock labels
    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(myTimerAction) userInfo:nil repeats:YES];
    [runloop addTimer:timer forMode:NSRunLoopCommonModes];
    [runloop addTimer:timer forMode:UITrackingRunLoopMode];
    
    
    [self myTimerDate];
    NSTimer *dateTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(myTimerDate) userInfo:nil repeats:YES];
    [runloop addTimer:dateTimer forMode:NSRunLoopCommonModes];
    [runloop addTimer:dateTimer forMode:UITrackingRunLoopMode];
    
    
    UISwipeGestureRecognizer *swipeLeftRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)];
    [swipeLeftRight setDirection:(/*UISwipeGestureRecognizerDirectionRight |*/ UISwipeGestureRecognizerDirectionLeft )];
    [self.view addGestureRecognizer:swipeLeftRight];
    
    /*
     UISwipeGestureRecognizer *swipeUpDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [swipeUpDown setDirection:(UISwipeGestureRecognizerDirectionUp | UISwipeGestureRecognizerDirectionDown )];
    [self.view addGestureRecognizer:swipeUpDown];
     */
    
    

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    //This is what sets the custom font
    //See -http://stackoverflow.com/questions/360751/can-i-embed-a-custom-font-in-an-iphone-application
    colonLabel.font = [UIFont fontWithName:@"digital-7" size:90];
    hour1Label.font = [UIFont fontWithName:@"digital-7" size:90];
    minute1Label.font = [UIFont fontWithName:@"digital-7" size:90];
    hour2Label.font = [UIFont fontWithName:@"digital-7" size:90];
    minute2Label.font = [UIFont fontWithName:@"digital-7" size:90];
    
}




//This updates the clock labels
-(void)myTimerDate
{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //NSString* date_string = [NSString stringWithFormat:@"%@/%@/%@", one, two, three];
    
    //There is a bug open related to xcode6 and current language device
    //http://stackoverflow.com/questions/24588105/changing-language-on-ios-8-simulator-does-not-work
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:language]];
    
    
    if([SettingsViewController isModifiedSettings] || first_time){
        
        first_time = NO;
        [SettingsViewController setModifiedSettingsToNo];
        
        NSString *current_user = [[NSUserDefaults standardUserDefaults] stringForKey:@"current_user"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *userListData = [defaults objectForKey:@"UserListData"];
        NSMutableArray *users_list = [NSKeyedUnarchiver unarchiveObjectWithData:userListData];
        
        for (UserSettingsObject *user in users_list) {
            if([user.username isEqualToString:current_user]){
                current_user_settings = user;
                break;
            }
        }
        
        NSMutableString *formatter = [[NSMutableString alloc]init];
        
        if(current_user_settings.day_of_weak){
            [formatter appendString:@"EEEE "];
        }
        
        if(current_user_settings.day_of_month){
            [formatter appendString:@"d "];
        }
        
        if(current_user_settings.month){
            [formatter appendString:@"LLLL "];
        }
        
        if(current_user_settings.year){
            [formatter appendString:@"yyyy"];
        }
        NSLog(@"%@",formatter);
        [dateFormatter setDateFormat:formatter];
        NSString *mesAno = [dateFormatter stringFromDate:date];
        
        monthYearLabel.text = mesAno;

    }
     
    
    
}

//This updates the clock labels
-(void)myTimerAction
{
    NSDate *date = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"hh:mm a"];
    NSString *hourMinuteSecond = [dateFormatter stringFromDate:date];
    
    hour1Label.text = [hourMinuteSecond substringWithRange:NSMakeRange(0, 1)];
    hour2Label.text = [hourMinuteSecond substringWithRange:NSMakeRange(1, 1)];
    minute1Label.text = [hourMinuteSecond substringWithRange:NSMakeRange(3, 1)];
    minute2Label.text = [hourMinuteSecond substringWithRange:NSMakeRange(4, 1)];
}

- (IBAction)logout {
    
    // Delete User credential from NSUserDefaults and other data related to user
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogged"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
    
    UIViewController* rootController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"LoginViewController"];
    
    UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:rootController];
    appDelegateTemp.window.rootViewController = navigation;
    
}

- (IBAction)handleSwipeLeft:(UISwipeGestureRecognizer *)gestureRecognizer{
    
    
    if(gestureRecognizer.direction==UISwipeGestureRecognizerDirectionRight){
        NSLog(@"right");
        NSUInteger index = [self.tabBarController selectedIndex];
        [self.tabBarController setSelectedIndex:index+1];

    }
    else if(gestureRecognizer.direction==UISwipeGestureRecognizerDirectionLeft){
        NSLog(@"left");
        NSUInteger index = [self.tabBarController selectedIndex];
        [self.tabBarController setSelectedIndex:index-1];
    }
    
}

-(BOOL)canBecomeFirstResponder {
    return YES;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        AppDelegate * myAppDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [myAppDelegate cancelAlertView];
    }
}
@end
