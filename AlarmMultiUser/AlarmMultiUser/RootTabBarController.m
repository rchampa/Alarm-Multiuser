//
//  RootTabBarController.m
//  AlarmMultiUser
//
//  Created by Ricardo Champa on 27/10/14.
//  Copyright (c) 2014 Daniel Portillo. All rights reserved.
//

#import "RootTabBarController.h"
#import "AppDelegate.h"

@interface RootTabBarController ()

@end

@implementation RootTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*UISwipeGestureRecognizer *swipeLeftRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    [swipeLeftRight setDirection:(UISwipeGestureRecognizerDirectionRight | UISwipeGestureRecognizerDirectionLeft )];
    [self.view addGestureRecognizer:swipeLeftRight];
    
    UISwipeGestureRecognizer *swipeUpDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    [swipeUpDown setDirection:(UISwipeGestureRecognizerDirectionUp | UISwipeGestureRecognizerDirectionDown )];
    [self.view addGestureRecognizer:swipeUpDown];
     */
}

/*
-(IBAction)tappedRightButton
{
    NSUInteger selectedIndex = [self.tabBarController selectedIndex];
    [self.tabBarController setSelectedIndex:selectedIndex + 1];
}

- (IBAction)tappedLeftButton
{
    NSUInteger selectedIndex = [self.tabBarController selectedIndex];
    [self.tabBarController setSelectedIndex:selectedIndex - 1];
}
*/

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


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
