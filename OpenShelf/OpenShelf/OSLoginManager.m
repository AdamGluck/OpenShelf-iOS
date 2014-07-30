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
    //TODO: other logout stuff
    self.user = nil;
}
    


@end
