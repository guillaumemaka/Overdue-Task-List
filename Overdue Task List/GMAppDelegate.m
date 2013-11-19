//
//  GMAppDelegate.m
//  Overdue Task List
//
//  Created by Guillaume Maka on 2013-11-04.
//  Copyright (c) 2013 G.Maka Ltd. All rights reserved.
//

#import "GMAppDelegate.h"
#import "GMSettingsViewController.h"
#import "GMTaskListViewController.h"
#import <Parse/Parse.h>
#import "GMTask.h"

@implementation GMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  [[NSUserDefaults standardUserDefaults] registerDefaults:@{SETTINGS_KEY: @{SETTINGS_CAPITALIZING_KEY: @NO,SETTINGS_SORTING_KEY : @0, SETTINGS_MULTIPLE_SECTION_KEY:@NO}}];
  
  [GMTask registerSubclass];
  [Parse setApplicationId:PARSE_APP_ID clientKey:PARSE_APP_CLIENT_KEY];
  [PFFacebookUtils initializeFacebook];
  [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];  
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSignOut:) name:GMDidSignOutNotification object:nil];
  
  GMWelcomeViewController *welcomeVC = (GMWelcomeViewController*) self.window.rootViewController;
  welcomeVC.delegate = self;
  
  [self customizeAppearence];
  
  return YES;
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
  return  [PFFacebookUtils handleOpenURL:url];
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
  return [PFFacebookUtils handleOpenURL:url];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  [[NSNotificationCenter defaultCenter] removeObserver:self name:GMDidSignOutNotification object:nil];
  UITabBarController* tabBarVC = (UITabBarController*) self.window.rootViewController;
  
  if ([tabBarVC isKindOfClass:[UITabBarController class]]) {
    GMTaskListViewController* taskListVC = (GMTaskListViewController*) [tabBarVC.viewControllers[0] topViewController];
    [[NSNotificationCenter defaultCenter] removeObserver:taskListVC name:GMSettingsDidChangeNotification object:nil];
  }
}

-(void) customizeAppearence{
  [UINavigationBar appearance].tintColor = [UIColor whiteColor];
  [UINavigationBar appearance].barTintColor = [UIColor colorWithRed:10.0f/255.0f green:100.0f/255.0f blue:164.0f/255.0f alpha:1.0f];
  NSDictionary *textAttributes = @{ NSForegroundColorAttributeName : [UIColor whiteColor]};
  [UINavigationBar appearance].titleTextAttributes = textAttributes;
  [UITabBar appearance].tintColor = [UIColor whiteColor];
  [UITabBar appearance].barTintColor = [UIColor colorWithRed:10.0f/255.0f green:100.0f/255.0f blue:164.0f/255.0f alpha:1.0f];  
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSignOut:) name:GMDidSignOutNotification object:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void) performLaunch {
  UITabBarController* tabBarVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"tabBarController"];
  
  GMTaskListViewController* taskListVC = (GMTaskListViewController*) [tabBarVC.viewControllers[0] topViewController];
  [[NSNotificationCenter defaultCenter] addObserver:taskListVC selector:@selector(settingsChange:) name:GMSettingsDidChangeNotification object:nil];

  self.window.rootViewController = tabBarVC;
}

#pragma mark - Notification Handler

-(void) didSignOut:(NSNotification*) notification{
  GMWelcomeViewController *welcomeVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"welcomeVC"];
  welcomeVC.delegate = self;
  self.window.rootViewController = welcomeVC;
}

@end
