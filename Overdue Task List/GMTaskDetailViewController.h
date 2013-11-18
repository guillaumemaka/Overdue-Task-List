//
//  GMTaskDetailViewController.h
//  Overdue Task List
//
//  Created by Guillaume Maka on 2013-11-04.
//  Copyright (c) 2013 G.Maka Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMTask.h"
#import "GMTaskEditViewController.h"

@protocol GMTaskDetailViewControllerDelegate <NSObject>

-(void) didUpdate;

@end

@interface GMTaskDetailViewController : UIViewController <GMTaskEditViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *taskNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskDueDateLabel;
@property (weak, nonatomic) IBOutlet UITextView *taskDescriptionTextView;
@property (weak, nonatomic) IBOutlet UISwitch *completedTaskSwitch;
@property (strong, nonatomic) GMTask *task;

@property (weak, nonatomic) id<GMTaskDetailViewControllerDelegate> delegate;
- (IBAction)changeTaskStateAction:(UISwitch *)sender;
@end
