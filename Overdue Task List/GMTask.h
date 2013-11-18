//
//  GMTask.h
//  Overdue Task List
//
//  Created by Guillaume Maka on 2013-11-04.
//  Copyright (c) 2013 G.Maka Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface GMTask : PFObject <PFSubclassing>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *taskDescription;
@property (strong, nonatomic) NSDate *dueDate;
@property (assign, nonatomic) BOOL isCompleted;
@property (strong, nonatomic) NSString *username;

-(instancetype) initWithData:(NSDictionary*) data;
-(NSString*) getFormattedDateString;
@end
