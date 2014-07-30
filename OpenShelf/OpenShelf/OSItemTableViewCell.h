//
//  OSItemTableViewCell.h
//  OpenShelf
//
//  Created by Brian Strobach on 7/2/14.
//  Copyright (c) 2014 OpenShelf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OSItem.h"
#import "OSExpandableView.h"
@interface OSItemTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet OSExpandableView *expandableView;
@property (strong, nonatomic) IBOutlet UIImageView *itemImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UIButton *deliverButton;

- (id)populateCellWithItem:(OSItem *)item;

@end
