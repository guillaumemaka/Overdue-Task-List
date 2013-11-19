//
//  GMTaskListViewController.h
//  Overdue Task List
//
//  Created by Guillaume Maka on 2013-11-04.
//  Copyright (c) 2013 G.Maka Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMAddTaskViewController.h"
#import "GMTaskDetailViewController.h"


@interface GMTaskListViewController : UITableViewController <GMAddTaskViewControllerDelegate, GMTaskDetailViewControllerDelegate>


extern NSString* kSettingsNotificationDidChange;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *reorderBarButtonItem;

- (IBAction)reorderAction:(UIBarButtonItem *)sender;

//! Handler for setings notification
- (void)settingsChange:(NSNotification*) notification;
@end
