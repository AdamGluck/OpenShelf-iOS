//
//  OSItemDetailViewController.h
//  OpenShelf
//
//  Created by Brian Strobach on 7/8/14.
//  Copyright (c) 2014 OpenShelf. All rights reserved.
//

#import "OSContentViewController.h"
#import "OSItem.h"
#import "GKLParallaxPicturesViewController.h"
@interface OSItemDetailViewController : GKLParallaxPicturesViewController
-(instancetype)initWithItem:(OSItem *)item;
@property (strong, nonatomic) OSItem *item;

@end
