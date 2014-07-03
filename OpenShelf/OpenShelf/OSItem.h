//
//  OSItem.h
//  OpenShelf
//
//  Created by Brian Strobach on 7/2/14.
//  Copyright (c) 2014 OpenShelf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OSSubscription.h"

@interface OSItem : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) OSSubscription *subscription;
@property (strong, nonatomic) NSNumber *dailyRate;
@property (strong, nonatomic) NSArray *reviews;
@property (strong, nonatomic) NSArray *imageUrls;

//@property (strong, nonatomic) NSNumber *itemId;
@end
