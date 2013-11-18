//
//  GMTaskDetailViewController.m
//  Overdue Task List
//
//  Created by Guillaume Maka on 2013-11-04.
//  Copyright (c) 2013 G.Maka Ltd. All rights reserved.
//

#import "GMTaskDetailViewController.h"

@interface GMTaskDetailViewController ()
-(void) updateUI;
@end

@implementation GMTaskDetailViewController


- (void)viewDidLoad
{
  [super viewDidLoad];
  [self updateUI];
}

-(void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self updateUI];
}

-(void)updateUI{
  _taskNameLabel.text = _task.name;
  [_taskNameLabel sizeToFit];
  
  _taskDueDateLabel.text = [_task getFormattedDateString];;
  _taskDueDateLabel.numberOfLines = 2;
  [_taskDueDateLabel sizeToFit];
  
  _completedTaskSwitch.on = _task.isCompleted ? YES : NO;
  
  _taskDescriptionTextView.text = _task.taskDescription;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
  if ([segue.identifier isEqualToString:@"toEditVC"]) {
    GMTaskEditViewController *editVC = segue.destinationViewController;
    editVC.delegate = self;
    editVC.task = self.task;
  }
}

#pragma mark - GMTaskEditViewControllerDelegate

-(void)didUpdateTask{
  [self.navigationController popViewControllerAnimated:YES];
  [self.delegate didUpdate];
}
- (IBAction)changeTaskStateAction:(UISwitch *)sender {
  if (sender == _completedTaskSwitch) {
    _task.isCompleted = _completedTaskSwitch.on;
    [_task saveInBackground];
    [self.delegate didUpdate];    
  }
}
@end
