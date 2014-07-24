//
//  OSItemDetailViewController.h
//  OpenShelf
//
//  Created by Brian Strobach on 7/8/14.
//  Copyright (c) 2014 OpenShelf. All rights reserved.
//

#import "OSItem.h"
#import "OSPagingImageScrollView.h"
@interface OSItemDetailViewController : UIViewController <UIScrollViewDelegate, UITextViewDelegate>

@property (strong, nonatomic) OSItem *item;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;

@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UIButton *deliverButton;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet OSPagingImageScrollView *imageScroller;




@end
