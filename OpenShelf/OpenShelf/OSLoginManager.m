//
//  OSLoginManager.m
//  OpenShelf
//
//  Created by Brian Strobach on 7/23/14.
//  Copyright (c) 2014 OpenShelf. All rights reserved.
//

#import "OSLoginManager.h"
#import "OSNetworking.h"
#import "OSLoginViewController.h"
#import "SSKeychain.h"
#import "NSObject+MappableObject.h"

@implementation OSLoginManager

#pragma mark - Public Method

+ (id)sharedInstance
{
    static dispatch_once_t pred;
    static OSLoginManager *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[self alloc] init];
    });
    return shared;
}


-(void)presentLoginPage:(UIViewController *)vc
                    successfullLogin:(void (^)(void))successCompletion
                    canceldLogin:(void (^)(void))canceledCompletion{
    OSLoginViewController *loginVC = [[OSLoginViewController alloc]init];
    loginVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    loginVC.successfulLoginCompletion = successCompletion;
    loginVC.cancelledLoginCompletion = canceledCompletion;
    [vc presentViewController:loginVC animated:YES completion:nil];

}

-(void)logout{
    //Removes credentials from keychain that are used to auto login at launch
    [SSKeychain deletePasswordForService:[[NSBundle mainBundle] bundleIdentifier] account:self.user.email];
    self.user = nil;
}


-(void)attemptAutoLogin{
    if (!self.user) {
        NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
        NSArray *accounts = [SSKeychain accountsForService:bundleIdentifier];
        NSDictionary *account;
        if (accounts.count > 0) {
            account = [accounts objectAtIndex:0];
        }
        NSString *accountLogin = [account objectForKey:@"acct"];
        NSString *password = [SSKeychain passwordForService:[[NSBundle mainBundle]bundleIdentifier] account:accountLogin];
        
        if (password) {
            [OSProgressHUD showGlobalProgressHUDWithTitle:@"Logging In"];
            [[OSNetworking sharedInstance]loginWithEmail:accountLogin
                                                password:password
                                                 success:^(NSDictionary *dictionary) {
                [OSProgressHUD showGlobalProgressHUDWithTitle:@"Login Successful"];
                
                OSUser *user = [OSUser createWithDataFromDictionary:dictionary];
                [OSLoginManager sharedInstance].user = user;
                NSLog(@"AUTOLOGIN successful");
            
                [OSProgressHUD dismissGlobalHUD];
            } failure:^(NSError *error){
                [OSProgressHUD showGlobalProgressHUDWithTitle:@"Login Failed"];
                NSLog(@"AUTOLOGIN unsuccessful");
                [OSProgressHUD dismissGlobalHUD];
            }];
        }
    }
    
}

- (void)refreshUserInfoWithSuccess:(void (^)(NSDictionary *dictionary))successCompletion
                           failure:(void (^)(NSError *error))failureCompletion{
    if (self.email && self.password) {
        [OSProgressHUD showGlobalProgressHUDWithTitle:@"Refreshing user info"];
        [[OSNetworking sharedInstance]loginWithEmail:self.email
                                            password:self.password
                                             success:^(NSDictionary *dictionary) {
                                                 [OSProgressHUD showGlobalProgressHUDWithTitle:@"Refresh Successful"];
                                                 
                                                 OSUser *user = [OSUser createWithDataFromDictionary:dictionary];
                                                 [OSLoginManager sharedInstance].user = user;
                                                 NSLog(@"Refresh successful");
                                                 
                                                 [OSProgressHUD dismissGlobalHUD];
                                             } failure:^(NSError *error){
                                                 [OSProgressHUD showGlobalProgressHUDWithTitle:@"Refresh Failed"];
                                                 NSLog(@"Refresh unsuccessful");
                                                 [OSProgressHUD dismissGlobalHUD];
                                             }];

    }
}




@end
