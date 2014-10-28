//
//  AddEditAlarmViewController.h
//  AlarmMultiUser
//
//  Created by Ricardo Champa on 27/10/14.
//  Copyright (c) 2014 Daniel Portillo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlarmObject.h"

@interface AddEditAlarmViewController : UIViewController<UIAlertViewDelegate,UIPickerViewDataSource, UIPickerViewDelegate,UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UIPickerView *picker_ring;
@property (weak, nonatomic) IBOutlet UIDatePicker *timeToSetOff;
@property (weak, nonatomic) IBOutlet UIButton *deleteAlarm;
@property (weak, nonatomic) IBOutlet UITextField *alarmName;

@property (nonatomic, assign) NSInteger indexOfAlarmToEdit;
//@property(nonatomic,strong) NSString *label;
@property(nonatomic,assign) BOOL editMode;
@property(nonatomic,assign) int notificationID;
@property(nonatomic,assign) AlarmObject *old_alarm_object;
- (IBAction)saveAlarm:(id)sender;
- (IBAction)deleteAlarm:(id)sender;
@end
