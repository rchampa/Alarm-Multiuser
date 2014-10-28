//
//  AlarmListTableViewController.h
//  AlarmMultiUser
//
//  Created by Ricardo Champa on 26/10/14.
//  Copyright (c) 2014 Daniel Portillo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlarmListTableViewController : UITableViewController

- (IBAction)handleSwipe:(UISwipeGestureRecognizer *)sender;


@property (nonatomic, strong) NSMutableArray *list_of_user_alarms;
@property (nonatomic, strong) NSMutableArray *list_of_all_alarms;
@end
