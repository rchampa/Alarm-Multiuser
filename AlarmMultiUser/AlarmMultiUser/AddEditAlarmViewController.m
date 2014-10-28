//
//  AddEditAlarmViewController.m
//  AlarmMultiUser
//
//  Created by Ricardo Champa on 27/10/14.
//  Copyright (c) 2014 Daniel Portillo. All rights reserved.
//

#import "AddEditAlarmViewController.h"

@interface AddEditAlarmViewController ()
{
    NSArray *_pickerData;
}
@end

@implementation AddEditAlarmViewController

//@synthesize tableView;
@synthesize timeToSetOff;
//@synthesize label;
@synthesize navItem;
@synthesize saveButton;
@synthesize notificationID;
@synthesize old_alarm_object;
@synthesize picker_ring;

@synthesize deleteAlarm;
@synthesize alarmName;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //return button of keyboard
    self.alarmName.delegate = self;
    
    // Do any additional setup after loading the view.
    _pickerData = @[@"Morning", @"Mario", @"CSI"];
    
    // Connect data
    self.picker_ring.dataSource = self;
    self.picker_ring.delegate = self;
    
    // Do any additional setup after loading the view.
    
    //Edit mode is only true when an existing alarm is pressed
    if (self.editMode)
    {
        navItem.title = @"Edit Alarm";
        saveButton.title = @"Save";
        
        //self.label = old_alarm_object.label;
        self.alarmName.text = old_alarm_object.label;
        timeToSetOff.date = old_alarm_object.timeToSetOff;
        self.notificationID = old_alarm_object.notificationID;
        
    }
    else{
        deleteAlarm.hidden = YES;
    }

}

- (void)CancelExistingNotification
{
    //cancel alarm
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *eventArray = [app scheduledLocalNotifications];
    for (int i=0; i<[eventArray count]; i++)
    {
        UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
        NSDictionary *userInfoCurrent = oneEvent.userInfo;
        NSString *uid=[NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"notificationID"]];
        if ([uid isEqualToString:[NSString stringWithFormat:@"%i",self.notificationID]])
        {
            //Cancelling local notification
            
            [app cancelLocalNotification:oneEvent];
            break;
        }
    }
}


//called when add is pressed, check it in "Sow the connections inspector" the "->" icon
-(IBAction)saveAlarm:(id)sender
{
    AlarmObject * newAlarmObject;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *alarmListData = [defaults objectForKey:@"AlarmListData"];
    NSMutableArray *alarmList = [NSKeyedUnarchiver unarchiveObjectWithData:alarmListData];
    
    NSInteger id_counter_ns = [[NSUserDefaults standardUserDefaults] integerForKey:@"id_counter"];
    NSInteger id_counter = id_counter_ns;
    
    if(!alarmList)
    {
        alarmList = [[NSMutableArray alloc]init];
    }
    
    if(self.editMode)//Editing Alarm that already exists
    {
        //newAlarmObject = [alarmList objectAtIndex:self.indexOfAlarmToEdit];
        
        for (AlarmObject *alarm in alarmList) {
            if (alarm.id_alarm == old_alarm_object.id_alarm) {
                newAlarmObject = alarm;
            }
        }
        
        self.notificationID = old_alarm_object.notificationID;
        [self CancelExistingNotification];
    }
    else//Adding a new alarm
    {
        newAlarmObject = [[AlarmObject alloc]init];
        newAlarmObject.id_alarm = id_counter;
        newAlarmObject.enabled = YES;
        newAlarmObject.notificationID = [self getUniqueNotificationID];
        int next_id = id_counter+1;
        [[NSUserDefaults standardUserDefaults] setInteger:next_id forKey:@"id_counter"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    newAlarmObject.label = self.alarmName.text;
    newAlarmObject.timeToSetOff = timeToSetOff.date;
    newAlarmObject.enabled = YES;
    
    NSString *current_user = [[NSUserDefaults standardUserDefaults] stringForKey:@"current_user"];
    newAlarmObject.username = current_user;
    
    NSInteger row = [picker_ring selectedRowInComponent:0];
    NSString *song_name = [_pickerData objectAtIndex:row];
    newAlarmObject.song_name = song_name;
    
    [self scheduleLocalNotificationWithAlarm:newAlarmObject];
    
    if(self.editMode == NO){
        [alarmList addObject:newAlarmObject];
    }
    
    //update alarms list
    NSData *alarmListData2 = [NSKeyedArchiver archivedDataWithRootObject:alarmList];
    [[NSUserDefaults standardUserDefaults] setObject:alarmListData2 forKey:@"AlarmListData"];
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)deleteAlarm:(id)sender {
    
    UIAlertView *deleteAlarmAlert = [[UIAlertView alloc] initWithTitle:@"Delete Alarm"
                                                               message:@"Are you sure you want to delete this alarm?"
                                                              delegate:self
                                                     cancelButtonTitle:@"Yes"
                                                     otherButtonTitles:@"Cancel", nil];
    [deleteAlarmAlert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        //cancel alarm
        [self CancelExistingNotification];
        //delete alarm
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *alarmListData = [defaults objectForKey:@"AlarmListData"];
        
        NSMutableArray *alarmList = [NSKeyedUnarchiver unarchiveObjectWithData:alarmListData];
        
        int index = -1;
        //AlarmListData
        for (int i=0; i<[alarmList count]; i++) {
            
            AlarmObject* alarm = [alarmList objectAtIndex:i];
            if (old_alarm_object.id_alarm == alarm.id_alarm) {
                index = i;
            }
        }
        
        if(index != -1){
            
            [alarmList removeObjectAtIndex: index];
            
            NSData *alarmListData2 = [NSKeyedArchiver archivedDataWithRootObject:alarmList];
            [[NSUserDefaults standardUserDefaults] setObject:alarmListData2 forKey:@"AlarmListData"];
            
            NSLog(@"Alarma borrada");
        }
        
        
        
        [self.navigationController popViewControllerAnimated:YES];
    }
   
}

- (void)scheduleLocalNotificationWithAlarm:(AlarmObject *) alarm{
    
    NSDate *fireDate = alarm.timeToSetOff;
    int uid = alarm.notificationID;
    NSString *song_name = alarm.song_name;
    NSString *label_alarm = alarm.label;
    
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    if (!localNotification)
        return;
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"hh-mm -a";
    NSDate* date = [dateFormatter dateFromString:[dateFormatter stringFromDate:fireDate]];
    
    //localNotification.repeatInterval = NSDayCalendarUnit;
    localNotification.repeatInterval = NSCalendarUnitDay;
    [localNotification setFireDate:date];
    [localNotification setTimeZone:[NSTimeZone defaultTimeZone]];
    // Setup alert notification
    [localNotification setAlertBody:@"Alarm body" ];
    [localNotification setAlertAction:@"Open App Action"];
    [localNotification setHasAction:YES];
    
    //This array maps the alarms uid to the index of the alarm so that we can cancel specific local notifications
    
    NSNumber* uidToStore = [NSNumber numberWithInt:uid];
    NSDictionary *userInfo = @{
                               @"notificationID" : uidToStore,
                               @"song" : song_name,
                               @"label" : label_alarm,
                               };
    localNotification.userInfo = userInfo;
    
    // Schedule the notification
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    
}

//Get Unique Notification ID for a new alarm O(n)
-(int)getUniqueNotificationID
{
    NSMutableDictionary * hashDict = [[NSMutableDictionary alloc]init];
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *eventArray = [app scheduledLocalNotifications];
    for (int i=0; i<[eventArray count]; i++)
    {
        UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
        NSDictionary *userInfoCurrent = oneEvent.userInfo;
        NSNumber *uid= [userInfoCurrent valueForKey:@"notificationID"];
        NSNumber * value =[NSNumber numberWithInt:1];
        [hashDict setObject:value forKey:uid];
    }
    for (int i=0; i<[eventArray count]+1; i++)
    {
        NSNumber * value = [hashDict objectForKey:[NSNumber numberWithInt:i]];
        if(!value)
        {
            return i;
        }
    }
    return 0;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _pickerData[row];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


@end
