//
//  OSSearchViewController.h
//  OpenShelf
//
//  Created by Brian Strobach on 7/1/14.
//  Copyright (c) 2014 OpenShelf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OSContentTableViewController.h"

@interface OSSearchViewController : OSContentTableViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@end
