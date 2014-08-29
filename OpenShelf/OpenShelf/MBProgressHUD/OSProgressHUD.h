//
//  GGProgressHUD.h
//  Goat Roper
//
//  Created by Brian Strobach on 8/19/14.
//  Copyright (c) 2014 Brian Strobach. All rights reserved.
//
#import "MBProgressHUD.h"

@interface OSProgressHUD : NSObject
+ (MBProgressHUD *)showGlobalProgressHUDWithTitle:(NSString *)title;
+ (void)dismissGlobalHUD;

@end
