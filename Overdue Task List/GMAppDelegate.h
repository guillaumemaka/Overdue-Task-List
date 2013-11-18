//
//  GMAppDelegate.h
//  Overdue Task List
//
//  Created by Guillaume Maka on 2013-11-04.
//  Copyright (c) 2013 G.Maka Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMWelcomeViewController.h"
@interface GMAppDelegate : UIResponder <UIApplicationDelegate, GMWelcomeViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
