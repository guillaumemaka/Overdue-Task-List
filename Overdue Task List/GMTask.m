//
//  GMTask.m
//  Overdue Task List
//
//  Created by Guillaume Maka on 2013-11-04.
//  Copyright (c) 2013 G.Maka Ltd. All rights reserved.
//

#import "GMTask.h"
#import <Parse/PFObject+Subclass.h>

@implementation GMTask

@dynamic name;
@dynamic taskDescription;
@dynamic dueDate;
@dynamic isCompleted;
@dynamic username;

-(instancetype)initWithData:(NSDictionary *)data{
  self = [super init];
  
  if (self) {
    self.name = data[TASK_NAME_KEY];
    self.taskDescription = data[TASK_DESCRIPTION_KEY];
    self.dueDate = data[TASK_DATE_KEY];
    self.isCompleted = [data[TASK_COMPLETED_KEY] boolValue];
  }
  
  return self;
}

+(NSString *) parseClassName {
 return @"Task";
}

-(NSString *)getFormattedDateString {
  NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
  [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
  
  return  [dateFormatter stringFromDate:self.dueDate];
}
@end
