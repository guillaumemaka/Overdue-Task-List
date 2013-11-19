//
//  GMTaskListViewController.m
//  Overdue Task List
//
//  Created by Guillaume Maka on 2013-11-04.
//  Copyright (c) 2013 G.Maka Ltd. All rights reserved.
//

#import "GMTaskListViewController.h"
#import "GMSettingsViewController.h"
#import "GMTask.h"
#import <Parse/Parse.h>

enum GMTaskListSection {
  GMTaskListSectionCompleted = 0,
  GMTaskListSectionIncompleted ,
  GMTaskListSectionOverdued
  };

@interface GMTaskListViewController ()

//! Track the state of the table view
@property (nonatomic) BOOL isInEditingMode;

//! Track if we need to reload the table view
@property (nonatomic) BOOL needToReload;

//! Capitalize the first letter of each task name
@property (nonatomic) BOOL capitalize;

//! Sort task model key
@property (strong, nonatomic) NSString* sortingModelKey;

//! Show task inmultiple section
@property (nonatomic) BOOL multipleSection;

//! The data source for the table view
@property (strong, nonatomic) NSMutableArray *tasks;

/*! Load tasks from NSUserDefault */
-(void) fetchTasks:(BOOL) reload;

//! Save task to NSUserDefault
-(void) saveTask:(GMTask*) task;

/*! Get a task from a property list
 \param data a dictionary containing task informations
 \return a GMTask object
 */
-(GMTask*) taskFromPropertyList:(NSDictionary*) data;

/*! Method that configure a UITableViewCell with a task
 \paran cell the UITableViewCell to configure
 \param task the task
 */
-(void) configureCell:(UITableViewCell*)cell withTask:(GMTask*) task;

//!
-(NSIndexPath*) indexPathForTask:(GMTask*) task;

/*! Function that compare if a a given date is greater than another
 \param date1 the date to compare
 \param date2 the against date
 \return YES if date1 is greater than date2, NO otherwise
 */
-(BOOL) isDate:(NSDate*)date1 greaterThan:(NSDate*)date2;

//! Method that update the UI
-(void) updateUI;

// Configure the table view disposition according to user settings
-(void) prepareTableViewWithTask:(NSArray*) tasks andReload:(BOOL) reloaded;

//! Setup method
-(void) setUp;
@end

@implementation GMTaskListViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.isInEditingMode = [self.tableView isEditing];
  self.needToReload = NO;
  
  if (!self.tasks) {
    self.tasks = [[NSMutableArray alloc] init];
  }
  
  [self setUp];
  [self fetchTasks:YES];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{    
  if (self.needToReload) {
    [self.tableView reloadData];
    self.needToReload = NO;
  }
}

#pragma mark - Helpers

-(void)setUp{
  NSDictionary *settings = [[NSUserDefaults standardUserDefaults] dictionaryForKey:SETTINGS_KEY];
  self.capitalize = [settings[SETTINGS_CAPITALIZING_KEY] boolValue];
  self.sortingModelKey = [settings[SETTINGS_SORTING_KEY] integerValue] == 0 ? TASK_NAME_KEY : TASK_DATE_KEY;
  self.multipleSection = [settings[SETTINGS_MULTIPLE_SECTION_KEY] boolValue];
}

-(void)fetchTasks:(BOOL) reload{
//
//  NSArray* savedTasks = [[NSUserDefaults standardUserDefaults] arrayForKey:TASkS_OBJECT_KEY];
//  for (NSDictionary *data in savedTasks) {
//    GMTask *task = [[GMTask alloc] initWithData:data];
//    [self.tasks addObject:task];
//  }
  
  PFQuery *query = [GMTask query];
  [query whereKey:@"username" equalTo:[[PFUser currentUser] username]];
  [query orderByAscending:self.sortingModelKey];
  
  [query findObjectsInBackgroundWithBlock:^(NSArray *tasks, NSError *error) {
    
      [self prepareTableViewWithTask:tasks andReload:reload];
      [self updateUI];
  }];
}

-(void)saveTask:(GMTask*) task{
//  NSMutableArray *tasksToSave = [[NSMutableArray alloc] init];
//  for (GMTask *task in self.tasks) {
//    [tasksToSave addObject:@{
//                             TASK_NAME_KEY : task.name,
//                             TASK_DESCRIPTION_KEY : task.taskDescription,
//                             TASK_DATE_KEY : task.dueDate,
//                             TASK_COMPLETED_KEY : @(task.isConpleted) }];
//  }
//  
//  [[NSUserDefaults standardUserDefaults] setObject:tasksToSave forKey:TASkS_OBJECT_KEY];
//  [[NSUserDefaults standardUserDefaults] synchronize];
  
  [task saveEventually:^(BOOL succeeded, NSError *error) {
    NSIndexPath *indexPath = [self indexPathForTask:task];
    if (self.multipleSection) {
      [self.tasks[indexPath.section] addObject:task];
    }else{
      [self.tasks addObject:task];
    }
    
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
  }];
}

-(GMTask *)taskFromPropertyList:(NSDictionary *)data {
  return [[GMTask alloc] initWithData:data];
}


-(BOOL)isDate:(NSDate *)date1 greaterThan:(NSDate*)date2{
  int date1TimeInterval = [date1 timeIntervalSince1970];
  int date2TimeInterval = [date2 timeIntervalSince1970];
  
  if (date1TimeInterval > date2TimeInterval) {
    return YES;
  }
  
  return NO;
}

-(void)updateUI{
  BOOL haveTasks;
  
  if (self.multipleSection) {
    haveTasks = ([self.tasks[GMTaskListSectionCompleted] count] > 0
                 || [self.tasks[GMTaskListSectionIncompleted] count] > 0
                 || [self.tasks[GMTaskListSectionOverdued] count] > 0);
  }else{
    haveTasks = [self.tasks count] > 0;
  }
  
  // if no more task set editing mode to NO
  if (!haveTasks) {
    [self.tableView setEditing:NO];
    self.isInEditingMode = NO;
  }
  
  if (haveTasks){
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:nil
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self
                                                                            action:@selector(reorderAction:)];
    

    self.navigationItem.leftBarButtonItem.style = self.isInEditingMode ? UIBarButtonItemStyleDone : UIBarButtonItemStyleBordered;
    self.navigationItem.leftBarButtonItem.title = self.isInEditingMode ? @"Done" : @"Edit";
  }else{
    self.navigationItem.leftBarButtonItem = nil;
  }
}

-(void)prepareTableViewWithTask:(NSArray *)tasks andReload:(BOOL)reloaded{
  NSArray *sortedTask = [tasks sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
    GMTask *task1 = (GMTask*) obj1;
    GMTask *task2 = (GMTask*) obj2;
    
    if ([self.sortingModelKey isEqualToString:TASK_NAME_KEY]) {
      if (task1.name > task2.name) {
        return (NSComparisonResult)NSOrderedDescending;
      }
      
      if (task1.name < task2.name) {
        return (NSComparisonResult)NSOrderedAscending;
      }
    }else if([self.sortingModelKey isEqualToString:TASK_DATE_KEY] ){
      if (task1.dueDate > task2.dueDate) {
        return (NSComparisonResult)NSOrderedDescending;
      }
      
      if (task1.dueDate < task2.dueDate) {
        return (NSComparisonResult)NSOrderedAscending;
      }
    }
    
    return (NSComparisonResult)NSOrderedSame;
  }];
  
  if (self.multipleSection) {
    NSMutableArray *sectionTaskCompleted = [@[] mutableCopy];
    NSMutableArray *sectionTaskInCompleted = [@[] mutableCopy];
    NSMutableArray *sectionTaskOverdued = [@[] mutableCopy];
    
    NSPredicate *completedTaskPredicate = [NSPredicate predicateWithFormat:@"%K = YES", TASK_COMPLETED_KEY];
    NSPredicate *inCompletedTaskPredicate = [NSPredicate predicateWithFormat:@"(%K = NO) && (%K > %@)", TASK_COMPLETED_KEY, TASK_DATE_KEY, [NSDate date]];
    NSPredicate *overduedTaskPredicate = [NSPredicate predicateWithFormat:@"(%K < %@) && !(%K = YES)", TASK_DATE_KEY, [NSDate date], TASK_COMPLETED_KEY, TASK_COMPLETED_KEY];
    
    sectionTaskCompleted = [[sortedTask filteredArrayUsingPredicate:completedTaskPredicate] mutableCopy];
    sectionTaskInCompleted = [[sortedTask filteredArrayUsingPredicate:inCompletedTaskPredicate] mutableCopy];
    sectionTaskOverdued = [[sortedTask filteredArrayUsingPredicate:overduedTaskPredicate] mutableCopy];
    
    [self.tasks removeAllObjects];
    [self.tasks addObject:sectionTaskCompleted];
    [self.tasks addObject:sectionTaskInCompleted];
    [self.tasks addObject:sectionTaskOverdued];
  }else {
    self.tasks = [sortedTask mutableCopy];
  }
  
  if (reloaded) {
    [self.tableView reloadData];
  }
  
  [self updateUI];
}

#pragma mark - Nofication handler

-(void) settingsChange:(NSNotification*) notification{
  NSDictionary *settings = notification.userInfo;
  
  self.capitalize = [settings[SETTINGS_CAPITALIZING_KEY] boolValue];
  self.sortingModelKey = ([settings[SETTINGS_SORTING_KEY] integerValue] == 0) ? TASK_NAME_KEY : TASK_DATE_KEY;
  
  BOOL oldMultipleSetting = self.multipleSection;
  BOOL newMultipleSetting = [settings[SETTINGS_MULTIPLE_SECTION_KEY] boolValue];

  self.multipleSection = newMultipleSetting;
  
  if (oldMultipleSetting) {
    if (!newMultipleSetting) {
      NSMutableArray *allTasks = [@[] mutableCopy];
      for (NSMutableArray *section in self.tasks) {
        [allTasks addObjectsFromArray:section];
      }
      
      [self prepareTableViewWithTask:allTasks andReload:NO];
    }
  }else{
      [self prepareTableViewWithTask:self.tasks andReload:NO];
  }
  
  self.needToReload = YES;
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  if (self.multipleSection) {
    return [self.tasks count];
  }
  
  return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
  if (self.multipleSection) {
    switch (section) {
      case GMTaskListSectionCompleted:
        return @"Completed";
      case GMTaskListSectionIncompleted:
        return @"Incompleted";
      case GMTaskListSectionOverdued:
        return @"Overdued";
    }
  }
  
  return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  // Return the number of rows in the section.
  if (self.multipleSection) {
    return [self.tasks[section] count];
  }
  
  return [self.tasks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"TaskListCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  
  // Configure the cell...
  
  GMTask* task;
  
  if (self.multipleSection) {
    task = self.tasks[indexPath.section][indexPath.row];
  }else{
    task = self.tasks[indexPath.row];
  }
  
  [self configureCell:cell withTask:task];
  
  return cell;
}

-(void)configureCell:(UITableViewCell *)cell withTask:(GMTask *)task{
  __block UITableViewCell *blockCell = cell;
  
  [task fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
    GMTask *task = (GMTask*) object;
    
    if (task.isCompleted) {
      blockCell.backgroundColor = TASK_COMPLETED_COLOR;
    }else {
      if ([self isDate:[NSDate date] greaterThan:task.dueDate]) {
        blockCell.backgroundColor = TASK_OVERDUED_COLOR;
      }else{
        blockCell.backgroundColor = TASK_UNCOMPLETED_COLOR;
      }
    }
    
    
    if (self.capitalize) {
      if (task.name.length > 0) {
        NSString *firstLetter = [task.name substringFromIndex:0];
        blockCell.textLabel.text = [NSString stringWithFormat:@"%@%@", firstLetter, [task.name substringToIndex:0]];
      }
    }else{
      blockCell.textLabel.text = task.name.length > 0 ? task.name : @"(No task name provided)";
    }
    
    
    blockCell.detailTextLabel.text =  [task getFormattedDateString];
  }];
}

-(NSIndexPath *)indexPathForTask:(GMTask *)task{
  NSIndexPath *indexPath;
  if (self.multipleSection) {
    int section, row;
    
    if (task.isCompleted) {
      section = GMTaskListSectionCompleted;
    }else {
      section = GMTaskListSectionIncompleted;
    }
    
    if ([self isDate:[NSDate date] greaterThan:task.dueDate] && !task.isCompleted) {
      section = GMTaskListSectionOverdued;
    }
    
    row = [self.tasks[section] count] == 0 ? 0 : (int) [self.tasks[section] count] - 1;
    
    indexPath = [NSIndexPath indexPathForRow:row inSection:section];
  }else{
    indexPath = [NSIndexPath indexPathForRow:self.tasks.count - 1 inSection:0];
  }
  
  return indexPath;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  GMTask *task;
  
  if (self.multipleSection) {
    task = self.tasks[indexPath.section][indexPath.row];
  }else{
    task = self.tasks[indexPath.row];
  }
  
  // Toggle the task state
  task.isCompleted = !task.isCompleted;
  
  NSIndexPath* newIndexPath = [self indexPathForTask:task];
  
  if (self.multipleSection) {
    [self.tasks[newIndexPath.section] addObject:task];
    [self.tasks[indexPath.section] removeObjectAtIndex:indexPath.row];
    
    // Move the row to it new section
    [tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
    [tableView reloadSections:[NSIndexSet indexSetWithIndex:newIndexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
  }else{
    // reload the cell to reflect change
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
  }
  
  // Save in background
  [task saveInBackground];
}

 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
   // Return NO if you do not want the specified item to be editable.
   return YES;
 }



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    // Delete the row from the data source
    
    // tell the table view we do some operation
    [self.tableView beginUpdates];
    
    
    GMTask *taskToRemove;
    
    if (self.multipleSection) {
      taskToRemove = self.tasks[indexPath.section][indexPath.row];
    }else{
      taskToRemove = self.tasks[indexPath.row];
    }
    
    // first we remove the task from the data source
    [taskToRemove deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
      if (succeeded) {
        if (self.multipleSection) {
            [self.tasks[indexPath.section] removeObjectAtIndex:indexPath.row];
        }else{
            [self.tasks removeObjectAtIndex:indexPath.row];
        }        
        
        // second we remove the task from the view
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        // third notify the view we've done
        [self.tableView endUpdates];
        
        [self updateUI];
      }
    }];        
  }
  else if (editingStyle == UITableViewCellEditingStyleInsert) {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
  }
}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
  if (!self.multipleSection) {
    [self.tasks exchangeObjectAtIndex:toIndexPath.row withObjectAtIndex:fromIndexPath.row];
    [GMTask saveAllInBackground:self.tasks];
  }
}


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
  // Return NO if you do not want the item to be re-orderable.
  return !self.multipleSection;
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqualToString:@"toAddTaskVC"]) {
    GMAddTaskViewController* addTaskVC = (GMAddTaskViewController*) [segue.destinationViewController topViewController];
    addTaskVC.delegate = self;
  }else if ([segue.identifier isEqualToString:@"toDetailVC"]){
    GMTaskDetailViewController *detailVC = segue.destinationViewController;
    UITableViewCell *selectedCell = (UITableViewCell*) sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:selectedCell];
    
    if (self.multipleSection) {
      detailVC.task = self.tasks[indexPath.section][indexPath.row];
    }else{
      detailVC.task = self.tasks[indexPath.row];
    }
    
    detailVC.delegate = self;
  }
}


#pragma mark - GMAddTaskViewControllerDelegate

-(void)didAddTask:(GMTask *)task{
  [self saveTask:task];
  [self updateUI];
  [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)didCancel{
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - GMTaskEditViewControllerDelegate

-(void)didUpdate{
  self.needToReload = YES;
}

#pragma mark - IBActions

- (IBAction)reorderAction:(UIBarButtonItem *)sender {
  [self.tableView setEditing:!self.isInEditingMode];
  self.isInEditingMode = !self.isInEditingMode;
  [self updateUI];
}
@end
