//
//  OSItemCell.h
//  OpenShelf
//
//  Created by Brian Strobach on 7/3/14.
//  Copyright (c) 2014 OpenShelf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OSItemCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *itemImageView;
@property (strong, nonatomic) IBOutlet UILabel *itemTitleLabel;

@end
