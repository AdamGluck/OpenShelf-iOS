//
//  OSAddress.m
//  OpenShelf
//
//  Created by Brian Strobach on 7/2/14.
//  Copyright (c) 2014 OpenShelf. All rights reserved.
//

#import "OSAddress.h"

@implementation OSAddress

-(NSDictionary *)toJSONObject{
    return @{@"address_data" : @{@"street_number": self.streetNumber, @"zip_code" : self.zip, @"state" : self.state, @"city" : self.city}};
}

@end
