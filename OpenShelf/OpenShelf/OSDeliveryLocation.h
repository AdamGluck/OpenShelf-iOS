//
//  OSDeliveryLocation.h
//  OpenShelf
//
//  Created by Brian Strobach on 7/2/14.
//  Copyright (c) 2014 OpenShelf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OSAddress.h"
@interface OSDeliveryLocation : OSAddress
@property (strong, nonatomic) NSNumber *userId;
@property (strong, nonatomic) NSString *title;

-(NSDictionary *)toJSONObject;

@end
