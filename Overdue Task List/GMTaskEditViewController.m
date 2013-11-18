//
//  GMTaskEditViewController.m
//  Overdue Task List
//
//  Created by Guillaume Maka on 2013-11-04.
//  Copyright (c) 2013 G.Maka Ltd. All rights reserved.
//

#import "GMTaskEditViewController.h"

@interface GMTaskEditViewController ()
//! Heloer method to setup the view controller
- (void) setUp;

//! Method to update the UI when the model is updated
- (void) updateUI;

//! Target action to dismiss the keyboard on UITextView
- (void) dismissKeyboard:(id)sender;
@end

@implementation GMTaskEditViewController


- (void)setUp
{
  // Create a tool bar
  UIToolbar* toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
  [toolbar sizeToFit];
  toolbar.barStyle = UIBarStyleDefault;
  
  // Add a flexible space and a done button
  toolbar.items = @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                    [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                     style:UIBarButtonItemStyleDone
                                                    target:self
                                                    action:@selector(dismissKeyboard:)]
                    ];
  
  // Set the input Accessory View of the UITextView
  _taskDescriptionTextView.inputAccessoryView = toolbar;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self setUp];
}

-(void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  [self updateUI];
}

-(void)updateUI{
  _taskNameTextField.text = _task.name;
  _taskDueDateDatePicker.date = _task.dueDate;
  _taskDescriptionTextView.text = _task.taskDescription;
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)saveAction:(UIBarButtonItem *)sender {
  _task.name = _taskNameTextField.text;
  _task.dueDate = _taskDueDateDatePicker.date;
  _task.taskDescription = _taskDescriptionTextView.text;
  
  [_task saveInBackground];
  [self.delegate didUpdateTask];
}

-(void)dismissKeyboard:(id)sender {
  [_taskDescriptionTextView resignFirstResponder];
}


@end
