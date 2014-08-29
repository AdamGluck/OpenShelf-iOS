//
//  OSOrder.h
//  OpenShelf
//
//  Created by Brian Strobach on 7/2/14.
//  Copyright (c) 2014 OpenShelf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OSOrder : NSObject
@property (strong, nonatomic) NSNumber *isPackage;
@property (strong, nonatomic) NSNumber *objectId;
@property (strong, nonatomic) NSNumber *userId;
@property (strong, nonatomic) NSNumber *addressId;
@property (strong, nonatomic) NSString *cardId;
-(Boolean)isValid;
@end
