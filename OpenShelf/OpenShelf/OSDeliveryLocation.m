//
//  OSDeliveryLocation.m
//  OpenShelf
//
//  Created by Brian Strobach on 7/2/14.
//  Copyright (c) 2014 OpenShelf. All rights reserved.
//

#import "OSDeliveryLocation.h"

@implementation OSDeliveryLocation


-(NSDictionary *)toJSONObject{
    NSMutableDictionary *data = [[NSMutableDictionary alloc]initWithDictionary:[super toJSONObject]];
    NSDictionary *deliveryLocationData = @{@"user_id": self.userId, @"title" : self.title};
    [data setObject:deliveryLocationData forKey:@"delivery_location_data"];
    return data;
}

@end
