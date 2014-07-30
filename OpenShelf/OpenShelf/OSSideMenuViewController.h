//
//  OSSideMenuViewController.m
//
//  Created by Brian Strobach on 7/1/14
//  Copyright (c) 2014 Open Shelf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OSAccountViewController.h"
#import "OSSearchViewController.h"
#import "OSExploreViewController.h"
#import "OSAccountViewController.h"
#import "OSExploreViewController.h"
#import "OSMainNavigationController.h"
#import "OSSearchViewController.h"
#import "UIViewController+REFrostedViewController.h"

@interface OSSideMenuViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) OSAccountViewController *accountViewController;
@property (strong, nonatomic) OSExploreViewController *exploreViewController;
@property (strong, nonatomic) OSSearchViewController *searchViewController;
@property (strong, nonatomic) OSMainNavigationController *navigationController;

-(void)switchContentVCToVC:(UIViewController*)viewController;
@end
