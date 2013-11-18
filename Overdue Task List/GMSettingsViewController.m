//
//  GMSettingsViewController.m
//  Overdue Task List
//
//  Created by Guillaume Maka on 2013-11-16.
//  Copyright (c) 2013 G.Maka Ltd. All rights reserved.
//

#import "GMSettingsViewController.h"
#import <Parse/Parse.h>

@interface GMSettingsViewController () <UIActionSheetDelegate>
@property (strong, nonatomic) NSMutableDictionary *settings;

-(void) saveSettings;
@end

@implementation GMSettingsViewController

NSString* GMDidSignOutNotification = @"GMDidSignOutNotification";
NSString* GMSettingsDidChangeNotification = @"GMSettingsDidChangeNotification";

- (void)viewDidLoad
{
    [super viewDidLoad];
  
}

-(void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  
  _settings = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:SETTINGS_KEY] mutableCopy];
  
  if ([PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
    _cellRowAccountDetailText.text = @"Facebook";
  }else{
    _cellRowAccountDetailText.text = @"Parse";
  }
  
  [_cellRowAccountDetailText sizeToFit];
  
  _capitaliseSwitchSetting.on = [[_settings objectForKey:SETTINGS_CAPITALIZING_KEY] boolValue];
  
  _sortingSegmentedControlSetting.selectedSegmentIndex = [[_settings objectForKey:SETTINGS_SORTING_KEY] integerValue];
  
  _multipleSectionSwitchSetting.on = [[_settings objectForKey:SETTINGS_MULTIPLE_SECTION_KEY] boolValue];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 1 && indexPath.row == 0 ) {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Sign Out" otherButtonTitles:nil];
    
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
  }
  
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (IBAction)setCapitalizeSetting:(UISwitch *)sender {
  [_settings setValue:@(sender.on) forKey:SETTINGS_CAPITALIZING_KEY];
  [self saveSettings];
}

- (IBAction)setSortSetting:(UISegmentedControl*)sender {
  [_settings setValue:@(sender.selectedSegmentIndex) forKey:SETTINGS_SORTING_KEY];
  [self saveSettings];
}

- (IBAction)setMultipleSectionSetting:(UISwitch *)sender {
  [_settings setValue:@(sender.on) forKey:SETTINGS_MULTIPLE_SECTION_KEY];
  [self saveSettings];
}

-(void)saveSettings{
  [[NSUserDefaults standardUserDefaults] setObject:_settings forKey:SETTINGS_KEY];
  [[NSUserDefaults standardUserDefaults] synchronize];
  [[NSNotificationCenter defaultCenter] postNotificationName:GMSettingsDidChangeNotification object:nil userInfo:_settings];
}

#pragma mark - UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Sign Out"]) {
    [PFUser logOut];
    [[NSNotificationCenter defaultCenter] postNotificationName:GMDidSignOutNotification object:self userInfo:nil];
  }
}

@end
