//
//  OSOrder.m
//  OpenShelf
//
//  Created by Brian Strobach on 7/2/14.
//  Copyright (c) 2014 OpenShelf. All rights reserved.
//

#import "OSOrder.h"

@implementation OSOrder

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
-(Boolean)isValid{
    if (self.objectId && self.userId && self.addressId && self.isPackage) {
        return TRUE;
    }
    else{
        return FALSE;
    }
}

@end
