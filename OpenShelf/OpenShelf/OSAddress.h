//
//  OSAddress.h
//  OpenShelf
//
//  Created by Brian Strobach on 7/2/14.
//  Copyright (c) 2014 OpenShelf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OSAddress : NSObject

@property (strong, nonatomic) NSString *streetNumber;
@property (strong, nonatomic) NSString *zip;
@property (strong, nonatomic) NSString *city;

@end
