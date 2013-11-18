//
//  GMAddTaskViewController.h
//  Overdue Task List
//
//  Created by Guillaume Maka on 2013-11-04.
//  Copyright (c) 2013 G.Maka Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMTask.h"

@protocol GMAddTaskViewControllerDelegate <NSObject>

-(void) didAddTask:(GMTask*) task;
-(void) didCancel;

@end

@interface GMAddTaskViewController : UITableViewController <UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate>
@property (weak, nonatomic) id<GMAddTaskViewControllerDelegate> delegate;

- (IBAction)cancelAction:(id)sender;
- (IBAction)doneAction:(id)sender;

@end
