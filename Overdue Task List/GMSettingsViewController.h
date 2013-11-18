//
//  GMSettingsViewController.h
//  Overdue Task List
//
//  Created by Guillaume Maka on 2013-11-16.
//  Copyright (c) 2013 G.Maka Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GMSettingsViewController : UITableViewController

extern NSString* GMDidSignOutNotification;
extern NSString* GMSettingsDidChangeNotification;

@property (weak, nonatomic) IBOutlet UISwitch *capitaliseSwitchSetting;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sortingSegmentedControlSetting;
@property (weak, nonatomic) IBOutlet UISwitch *multipleSectionSwitchSetting;
@property (weak, nonatomic) IBOutlet UILabel *cellRowAccountDetailText;
- (IBAction)setCapitalizeSetting:(UISwitch *)sender;
- (IBAction)setSortSetting:(UISegmentedControl*)sender;
- (IBAction)setMultipleSectionSetting:(UISwitch *)sender;

@end
