//
//  OSPackage.h
//  OpenShelf
//
//  Created by Brian Strobach on 7/23/14.
//  Copyright (c) 2014 OpenShelf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OSItem.h"

@interface OSPackage : OSItem

@property (strong, nonatomic) NSArray *packagedItems;

@end
