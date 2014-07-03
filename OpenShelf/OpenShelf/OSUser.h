//
//  OSUser.h
//  OpenShelf
//
//  Created by Brian Strobach on 7/2/14.
//  Copyright (c) 2014 OpenShelf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OSUser : NSObject

@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSMutableArray *deliveryLocations;
@property (strong, nonatomic) NSMutableArray *creditCards;
@property (strong, nonatomic) NSMutableArray *rentedItems;

@end
