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


@interface OSItemDetailViewController()

@property (nonatomic, strong) UIScrollView *transparentScroller;
@property (nonatomic, strong) NSMutableArray *imageViews;

@end

@implementation OSItemDetailViewController


-(void)viewDidLoad{
    [self setupViews];
    self.imageViews = [NSMutableArray arrayWithCapacity:[self.item.imageUrls count]];
    [self.imageScroller setScrollViewContents:self.item.imageUrls];
    [self.imageScroller setExclusiveTouch:YES];

}




- (void)setupViews{
    
    //For testing
    for (int i =0; i < 200; i++) {
        self.item.description = [self.item.description stringByAppendingString:@"TESTING SCROLL"];
    }
    
    self.item.cost = [NSNumber numberWithDouble:10.0];
    
    //End testing
    
    [self.descriptionTextView resizeContentViewAfterSettingText:self.item.description];
   
    [self.contentView resizeHeightToFitSubviewsHeight];
    
    self.titleLabel.text = self.item.title;
    [self.titleLabel sizeToFit];
    self.priceLabel.text = [self.item.cost stringValue];
    [self.priceLabel sizeToFit];
}

-(void)viewWillLayoutSubviews{

    CGFloat height = 0;
    height = self.contentView.frame.size.height + self.imageScroller.frame.size.height + self.navigationController.navigationBar.frame.size.height;
    [self.mainScrollView setContentSize:CGSizeMake(self.mainScrollView.frame.size.width, height)];
}



@end
