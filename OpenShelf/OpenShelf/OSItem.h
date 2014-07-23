//
//  OSItem.h
//  OpenShelf
//
//  Created by Brian Strobach on 7/2/14.
//  Copyright (c) 2014 OpenShelf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OSItem : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSString *shortDescription;
@property (nonatomic) BOOL isFeatured;
@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) NSNumber *timesRented;
@property (strong, nonatomic) NSNumber *cost;
@property (strong, nonatomic) NSNumber *pk;
@property (strong, nonatomic) NSArray *imageUrls;

//@property (strong, nonatomic) NSNumber *itemId;
@end
