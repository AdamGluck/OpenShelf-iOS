//
//  OSCreditCard.h
//  OpenShelf
//
//  Created by Brian Strobach on 7/2/14.
//  Copyright (c) 2014 OpenShelf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STPCard.h"
@interface OSCreditCard : STPCard
@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *brand;
@property (strong, nonatomic) NSString *customer;
@end
