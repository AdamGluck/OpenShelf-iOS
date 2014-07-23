//
//  OSLoginManager.m
//  OpenShelf
//
//  Created by Brian Strobach on 7/23/14.
//  Copyright (c) 2014 OpenShelf. All rights reserved.
//

#import "OSLoginManager.h"

@implementation OSLoginManager

#pragma mark - Public Method

+ (id)sharedInstance
{
    static dispatch_once_t pred;
    static OSLoginManager *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[self alloc] init];
    });
    return shared;
}



@end
