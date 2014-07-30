//
//  OSExpandableView.h
//  OpenShelf
//
//  Created by Brian Strobach on 7/29/14.
//  Copyright (c) 2014 OpenShelf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OSCornerButton.h"
@interface OSExpandableView : UIView
@property (strong, nonatomic) OSCornerButton *expandButton;
@property (strong, nonatomic) UILabel *shortDescriptionLabel;
@property (strong, nonatomic) UIButton *detailButton;
@property (nonatomic) Boolean isExpanded;
@end
