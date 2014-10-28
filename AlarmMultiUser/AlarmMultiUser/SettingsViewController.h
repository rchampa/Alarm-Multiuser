//
//  SettingsViewController.h
//  AlarmMultiUser
//
//  Created by Ricardo Champa on 28/10/14.
//  Copyright (c) 2014 Daniel Portillo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISwitch *switch_vibration;
@property (weak, nonatomic) IBOutlet UISwitch *switch_month;
@property (weak, nonatomic) IBOutlet UISwitch *switch_year;

@property (weak, nonatomic) IBOutlet UISwitch *switch_day_of_weak;
@property (weak, nonatomic) IBOutlet UISwitch *switch_day_of_month;
- (IBAction)handleSwipe:(UISwipeGestureRecognizer *)sender;

+ (BOOL)isModifiedSettings;
+ (void)setModifiedSettingsToNo;

@end
