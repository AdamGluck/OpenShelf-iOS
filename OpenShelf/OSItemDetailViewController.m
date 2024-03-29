//
//  OSItemDetailViewController.m
//  OpenShelf
//
//  Created by Brian Strobach on 7/8/14.
//  Copyright (c) 2014 OpenShelf. All rights reserved.
//

#import "OSItemDetailViewController.h"
#import "OSNetworking.h"
#import "UIView+Utilities.h"
#import "UITextView+Utilities.h"
#import "OSLoginManager.h"
#import "OSOrderTableViewController.h"

@interface OSItemDetailViewController()

@property (nonatomic, strong) UIScrollView *transparentScroller;
@property (nonatomic, strong) NSMutableArray *imageViews;

@end

@implementation OSItemDetailViewController


-(void)viewDidLoad{
    [self setupViews];
    self.imageViews = [NSMutableArray arrayWithCapacity:[self.item.images count]];
    [self.imageScroller setScrollViewContents:self.item.images];
    [self.imageScroller setExclusiveTouch:YES];
    self.view.backgroundColor= [UIColor whiteColor];
    [self.deliverButton addTarget:self action:@selector(deliverButtonPressed) forControlEvents:UIControlEventTouchUpInside];
}




- (void)setupViews{
    
    //For testing
    for (int i =0; i < 200; i++) {
        self.item.description = [self.item.description stringByAppendingString:@"TESTING SCROLL"];
    }
    
//    self.item.cost = [NSNumber numberWithDouble:10.0];
    
    //End testing
    
    [self.descriptionTextView resizeContentViewAfterSettingText:self.item.description];
   
    [self.contentView resizeHeightToFitSubviewsHeight];
    
    self.titleLabel.text = [self.item.title uppercaseString];
    [self.titleLabel sizeToFit];
    self.priceLabel.text = self.item.formattedPrice;
    self.priceLabel.layer.zPosition = 100;
}

-(void)viewWillLayoutSubviews{

    CGFloat height = 0;
    height = self.contentView.frame.size.height + self.imageScroller.frame.size.height + self.navigationController.navigationBar.frame.size.height;
    [self.mainScrollView setContentSize:CGSizeMake(self.mainScrollView.frame.size.width, height)];
}

#pragma mark - Button Handling

-(void)deliverButtonPressed{
    OSUser *user =  [OSLoginManager sharedInstance].user;
    if (!user) {
        [[OSLoginManager sharedInstance] presentLoginPage:self successfullLogin:^{
            NSLog(@"USER LOGGED IN%@", [OSLoginManager sharedInstance].user);
        } canceldLogin:^{
             NSLog(@"User failed to log in");
        }];
    }
    else{
        [self performSegueWithIdentifier:@"toOrderController" sender:nil];
    }
   
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"toOrderController"]) {
        OSOrderTableViewController *vc = segue.destinationViewController;
        vc.item = self.item;
    }
}

@end
