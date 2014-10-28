//
//  SettingsViewController.m
//  AlarmMultiUser
//
//  Created by Ricardo Champa on 28/10/14.
//  Copyright (c) 2014 Daniel Portillo. All rights reserved.
//

#import "SettingsViewController.h"
#import "UserSettingsObject.h"

@interface SettingsViewController ()
{
    UserSettingsObject *current_user_settings;
}
@end

BOOL static modifiedSettings;
@implementation SettingsViewController

@synthesize switch_vibration;
@synthesize switch_day_of_weak;
@synthesize switch_day_of_month;
@synthesize switch_year;
@synthesize switch_month;

+ (BOOL)isModifiedSettings
{
    return modifiedSettings;
}

+ (void)setModifiedSettingsToNo
{
    modifiedSettings=NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
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
    
    [switch_vibration setOn:current_user_settings.vibration];
    [switch_day_of_weak setOn:current_user_settings.day_of_weak];
    [switch_day_of_month setOn:current_user_settings.day_of_month];
    [switch_month setOn:current_user_settings.month];
    [switch_year setOn:current_user_settings.year];
    
    [switch_vibration  addTarget:self
                       action:@selector(toggleAlarmEnabledSwitch:)
             forControlEvents:UIControlEventTouchUpInside
    ];
    
    [switch_day_of_weak  addTarget:self
                          action:@selector(toggleAlarmEnabledSwitch:)
                forControlEvents:UIControlEventTouchUpInside
     ];
    
    [switch_day_of_month  addTarget:self
                            action:@selector(toggleAlarmEnabledSwitch:)
                  forControlEvents:UIControlEventTouchUpInside
     ];
    
    [switch_month  addTarget:self
                            action:@selector(toggleAlarmEnabledSwitch:)
                  forControlEvents:UIControlEventTouchUpInside
     ];
    
    [switch_year  addTarget:self
                            action:@selector(toggleAlarmEnabledSwitch:)
                  forControlEvents:UIControlEventTouchUpInside
     ];
    
    
    UISwipeGestureRecognizer *swipeLeftRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [swipeLeftRight setDirection:(/*UISwipeGestureRecognizerDirectionRight |*/ UISwipeGestureRecognizerDirectionLeft )];
    [self.view addGestureRecognizer:swipeLeftRight];

 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)toggleAlarmEnabledSwitch:(id)sender
{
    
    modifiedSettings = YES;
    
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
    
    UISwitch *switch_selected = (UISwitch *)sender;
    
    if(switch_selected == switch_vibration){
        current_user_settings.vibration = switch_vibration.isOn;
    }
    else if(switch_selected == switch_day_of_weak){
        current_user_settings.day_of_weak = switch_day_of_weak.isOn;
    }
    else if(switch_selected == switch_day_of_month){
        current_user_settings.day_of_month = switch_day_of_month.isOn;
    }
    else if(switch_selected == switch_month){
        current_user_settings.month = switch_month.isOn;
    }
    else if(switch_selected == switch_year){
        current_user_settings.year = switch_year.isOn;
    }
    
    //saving users list
    userListData = [NSKeyedArchiver archivedDataWithRootObject:users_list];
    [[NSUserDefaults standardUserDefaults] setObject:userListData forKey:@"UserListData"];
    
}


- (IBAction)handleSwipe:(UISwipeGestureRecognizer *)gestureRecognizer{
    
    
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



@end
