//
//  GMTaskEditViewController.h
//  Overdue Task List
//
//  Created by Guillaume Maka on 2013-11-04.
//  Copyright (c) 2013 G.Maka Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMTask.h"

@protocol GMTaskEditViewControllerDelegate <NSObject>

-(void)didUpdateTask;

@end
@interface GMTaskEditViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *taskNameTextField;
@property (weak, nonatomic) IBOutlet UITextView *taskDescriptionTextView;
@property (weak, nonatomic) IBOutlet UIDatePicker *taskDueDateDatePicker;
@property (strong, nonatomic) GMTask *task;

@property (weak, nonatomic) id<GMTaskEditViewControllerDelegate> delegate;
- (IBAction)saveAction:(UIBarButtonItem *)sender;
@end
