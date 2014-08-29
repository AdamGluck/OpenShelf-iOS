//
//  GGProgressHUD.m
//  OpenShelf
//
//  Created by Brian Strobach on 8/19/14.
//  Copyright (c) 2014 Brian Strobach. All rights reserved.
//

#import "OSProgressHUD.h"

@implementation OSProgressHUD

+ (MBProgressHUD *)showGlobalProgressHUDWithTitle:(NSString *)title {
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    [MBProgressHUD hideAllHUDsForView:window animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.labelText = title;
    return hud;
}

+ (void)dismissGlobalHUD {
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    [MBProgressHUD hideHUDForView:window animated:YES];
}


@end
