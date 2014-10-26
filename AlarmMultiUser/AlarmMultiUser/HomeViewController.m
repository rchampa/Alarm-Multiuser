//
//  HomeViewController.m
//  AlarmMultiUser
//
//  Created by Ricardo Champa on 26/10/14.
//  Copyright (c) 2014 Daniel Portillo. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"

@interface HomeViewController ()

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


-(void)viewDidAppear:(BOOL)animated
{
    //This checks if the home view is shown because of an alarm firing
    if(self.alarmGoingOff)
    {
        
        NSDictionary *userInfo = local_notification.userInfo;
        
        NSString *label = [userInfo objectForKey:@"label"];
        
        
        UIAlertView *alarmAlert = [[UIAlertView alloc] initWithTitle:label
                                                             message:@"Press okay to stop"
                                                            delegate:self
                                                   cancelButtonTitle:@"okay"
                                                   otherButtonTitles:nil, nil];
        [alarmAlert show];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        AppDelegate * myAppDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [myAppDelegate.player stop];
    }
    else{
        //do nothing
    }
}

//This updates the clock labels
-(void)myTimerDate
{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //There is a bug open related to xcode6 and current language device
    //http://stackoverflow.com/questions/24588105/changing-language-on-ios-8-simulator-does-not-work
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:language]];
    
    [dateFormatter setDateFormat:@"E d MMMM yyyy"];
    NSString *mesAno = [dateFormatter stringFromDate:date];
    
    monthYearLabel.text = mesAno;
    
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

@end
