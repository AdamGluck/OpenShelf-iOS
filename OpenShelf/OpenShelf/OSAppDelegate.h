//
//  OSAppDelegate.h
//  OpenShelf
//
//  Created by Brian Strobach on 6/24/14.
//  Copyright (c) 2014 OpenShelf. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OSAccountViewController.h"
#import "OSSideMenuViewController.h"
#import "OSMainNavigationController.h"
@interface OSAppDelegate : UIResponder <UIApplicationDelegate, REFrostedViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
