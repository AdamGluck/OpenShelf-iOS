//
//  OSLoginManager.h
//  OpenShelf
//
//  Created by Brian Strobach on 7/23/14.
//  Copyright (c) 2014 OpenShelf. All rights reserved.
//

#import "OSUser.h"

@interface OSLoginManager : NSObject

@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *password;

@property (strong, nonatomic) OSUser *user;

/**
 * gets singleton object.
 * @return singleton
 */
+ (OSLoginManager*)sharedInstance;
-(void)presentLoginPage:(UIViewController *)vc
       successfullLogin:(void (^)(void))successCompletion
           canceldLogin:(void (^)(void))canceledCompletion;
- (void)refreshUserInfoWithSuccess:(void (^)(NSDictionary *dictionary))successCompletion
                           failure:(void (^)(NSError *error))failureCompletion;
-(void)logout;
-(void)attemptAutoLogin;
@end
