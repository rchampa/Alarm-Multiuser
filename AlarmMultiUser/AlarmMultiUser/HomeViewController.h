//
//  HomeViewController.h
//  AlarmMultiUser
//
//  Created by Ricardo Champa on 26/10/14.
//  Copyright (c) 2014 Daniel Portillo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *hour1Label;
@property (weak, nonatomic) IBOutlet UILabel *hour2Label;
@property (weak, nonatomic) IBOutlet UILabel *minute1Label;
@property (weak, nonatomic) IBOutlet UILabel *minute2Label;



@property (weak, nonatomic) IBOutlet UILabel *colonLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthYearLabel;

@property(nonatomic) BOOL alarmGoingOff;
@property(nonatomic) UILocalNotification *local_notification;
- (IBAction)logout;
- (IBAction)handleSwipeLeft:(UISwipeGestureRecognizer *)sender;

@end
