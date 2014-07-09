//
//  OSItemDetailViewController.m
//  OpenShelf
//
//  Created by Brian Strobach on 7/8/14.
//  Copyright (c) 2014 OpenShelf. All rights reserved.
//

#import "OSItemDetailViewController.h"
@interface OSItemDetailViewController()
@end
@implementation OSItemDetailViewController

-(instancetype)initWithItem:(OSItem *)item{
    
    if (self = [super initWithImages:item.imageUrls andContentView:[[UIView alloc]init]]) {
        self.item = item;
        
    }
    return  self;
}

@end
