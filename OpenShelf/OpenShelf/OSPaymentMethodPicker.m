//
//  OSPaymentMethodPicker.m
//  OpenShelf
//
//  Created by Brian Strobach on 8/13/14.
//  Copyright (c) 2014 OpenShelf. All rights reserved.
//

#import "OSPaymentMethodPicker.h"
#import "STPCard.h"
#import "MBProgressHUD.h"
#import "OSNetworking.h"
#import "OSLoginManager.h"
@interface OSPaymentMethodPicker ()

@end

@implementation OSPaymentMethodPicker

- (void)commonInit{
    
    self.saveButton = [[UIBarButtonItem alloc]initWithTitle:@"SAVE" style:UIBarButtonItemStylePlain target:self action:@selector(save:)];
    self.navigationItem.rightBarButtonItem = self.saveButton;
    self.view.backgroundColor = [UIColor whiteColor];
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)coder{
    if ((self = [super initWithCoder:coder])) {
        [self commonInit];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
#ifdef DEBUG
    //Use test publishable key
    self.stripeView = [[STPView alloc] initWithFrame:CGRectMake(15,75,290,55)
                                              andKey:@"pk_test_4V1zPQ3CwSXRAkHtq63K1wLv"];
#endif
    
#ifndef DEBUG
    //Use live publishable key
    self.stripeView = [[STPView alloc] initWithFrame:CGRectMake(15,75,290,55)
                                              andKey:@"pk_live_4V1zrFjjaXAHzq32WcvEEk7p"];
#endif
    self.stripeView.delegate = self;
    [self.view addSubview:self.stripeView];
}

-(void)stripeView:(STPView *)view withCard:(id)card isValid:(BOOL)valid{
    self.saveButton.enabled = valid;
}

- (void)save:(id)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self.stripeView createToken:^(STPToken *token, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (error) {
            [self hasError:error];
        } else {
            [self hasToken:token];
        }
    }];
}

- (void)hasError:(NSError *)error
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error")
                                                      message:[error localizedDescription]
                                                     delegate:nil
                                            cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                            otherButtonTitles:nil];
    [message show];
}

- (void)hasToken:(STPToken *)token
{
    NSLog(@"Received token %@", token.tokenId);
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[OSNetworking sharedInstance] addCreditCardWithId:token.tokenId
                                             forUserId:[OSLoginManager sharedInstance].user.id
                                               success:^(NSDictionary *dictionary) {
                                                   [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                   [self.navigationController popViewControllerAnimated:YES];
                                                   [self.delegate userDidSavePaymentMethod];
                                                   
                                               } failure:^(NSError *error){
                                                   [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                   [self hasError:error];
                                                   
                                                   
                                                   
                                               }];
    
}
@end
