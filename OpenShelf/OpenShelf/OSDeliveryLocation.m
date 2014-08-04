//
//  OSDeliveryLocation.m
//  OpenShelf
//
//  Created by Brian Strobach on 7/2/14.
//  Copyright (c) 2014 OpenShelf. All rights reserved.
//

#import "OSDeliveryLocation.h"

@implementation OSDeliveryLocation

-(id)initWithAddress:(OSAddress *)address userID:(NSNumber *)userID  title:(NSString *)title{
    self = [super init];
    if(self) {
        self.address = address;
        self.id = userID;
        self.title = title;
    }
    return self;
    
}

-(NSDictionary *)toJSONObject{
    NSMutableDictionary *data = [[NSMutableDictionary alloc]initWithDictionary:[self.address toJSONObject]];
    NSDictionary *deliveryLocationData = @{@"user_id": self.id, @"title" : self.title};
    [data setObject:deliveryLocationData forKey:@"delivery_location_data"];
    return data;
}

@end
