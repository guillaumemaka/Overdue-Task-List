//
//  GMWelcomeViewController.m
//  Overdue Task List
//
//  Created by Guillaume Maka on 2013-11-12.
//  Copyright (c) 2013 G.Maka Ltd. All rights reserved.
//

#import "GMWelcomeViewController.h"

@interface GMWelcomeViewController ()
-(void) performLogin;
@end

@implementation GMWelcomeViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
  _loginVC = [[PFLogInViewController alloc] init];
  _loginVC.delegate = self;
  
  _signUpVC = [[PFSignUpViewController alloc] init];
  _signUpVC.delegate = self;
  
  _loginVC.fields = PFLogInFieldsUsernameAndPassword | PFLogInFieldsFacebook | PFLogInFieldsSignUpButton | PFLogInFieldsLogInButton;
  
  UILabel* logo = [[UILabel alloc] initWithFrame:_loginVC.logInView.logo.frame];
  logo.text = @"√ iTask";
  [logo sizeThatFits:_loginVC.logInView.logo.frame.size];
  
  _loginVC.logInView.logo = logo;
  
  UILabel* logo2 = [[UILabel alloc] initWithFrame:_loginVC.logInView.logo.frame];
  logo2.text = @"√ iTask";
  [logo2 sizeThatFits:_loginVC.logInView.logo.frame.size];
  _signUpVC.signUpView.logo = logo2;
  
  _loginVC.signUpController = _signUpVC;
  _loginVC.facebookPermissions = @[@"friends_about_me"];
  
  NSDictionary *appInfos = [[NSBundle mainBundle] infoDictionary];
  NSString *version = appInfos[(NSString*)kCFBundleVersionKey];
  _versionLabel.text = [NSString stringWithFormat:@"v%@", version];

  [_activityIndicator startAnimating];
}

-(void)viewDidAppear:(BOOL)animated{
  [super viewDidAppear:animated];
  if ([PFUser currentUser]) {
    [[PFUser currentUser] fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
      [self.delegate performLaunch];
    }];
  }else{
    [self performLogin];
  }
}

-(void)performLogin{
  [self presentViewController:_loginVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PFLogInViewControllerDelegate

-(void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user{
  [self dismissViewControllerAnimated:YES completion:nil];
  
  NSLog(@"Signed in user: %@", user);
  
  [self.delegate performLaunch];
}

-(void) logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error{
  NSLog(@"%@",error);
}

#pragma mark - PFSignUpViewControllerDelegate
-(void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
  [_activityIndicator stopAnimating];
  
  NSLog(@"Signed up user: %@", user);
  
  [self dismissViewControllerAnimated:YES completion:nil];
  [self.delegate performLaunch];
}

@end
