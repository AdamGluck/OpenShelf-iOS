//
//  OSUser.h
//  OpenShelf
//
//  Created by Brian Strobach on 7/2/14.
//  Copyright (c) 2014 OpenShelf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OSUser : NSObject

@property (strong, nonatomic) NSNumber *id;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSMutableArray *cards;

//@property (strong, nonatomic) NSMutableArray *deliveryLocations;
//@property (strong, nonatomic) NSMutableArray *rentedItems;

@end
