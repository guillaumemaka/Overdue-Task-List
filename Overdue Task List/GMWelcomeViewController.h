//
//  GMWelcomeViewController.h
//  Overdue Task List
//
//  Created by Guillaume Maka on 2013-11-12.
//  Copyright (c) 2013 G.Maka Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@protocol GMWelcomeViewControllerDelegate <NSObject>

-(void) performLaunch;

@end

@interface GMWelcomeViewController : UIViewController <PFLogInViewControllerDelegate,PFSignUpViewControllerDelegate>
@property (strong, nonatomic) PFLogInViewController *loginVC;
@property (strong, nonatomic) PFSignUpViewController *signUpVC;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) id<GMWelcomeViewControllerDelegate> delegate;
@end
