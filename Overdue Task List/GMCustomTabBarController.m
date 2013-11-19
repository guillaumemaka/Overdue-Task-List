//
//  GMCustomTabBarController.m
//  Overdue Task List
//
//  Created by Guillaume Maka on 2013-11-19.
//  Copyright (c) 2013 G.Maka Ltd. All rights reserved.
//

#import "GMCustomTabBarController.h"

@interface GMCustomTabBarController ()

@end

@implementation GMCustomTabBarController
-(id)initWithCoder:(NSCoder *)aDecoder{
  
  self = [super initWithCoder:aDecoder];
  
  if (self) {
    for (UITabBarItem *item in self.tabBar.items) {
      item.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
      item.title = nil;
    }
  }
  
  return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
