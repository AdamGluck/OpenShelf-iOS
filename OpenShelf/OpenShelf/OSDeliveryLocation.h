//
//  OSDeliveryLocation.h
//  OpenShelf
//
//  Created by Brian Strobach on 7/2/14.
//  Copyright (c) 2014 OpenShelf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OSAddress.h"
@interface OSDeliveryLocation : NSObject
@property (strong, nonatomic) NSNumber *id;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) OSAddress *address;

-(NSDictionary *)toJSONObject;
-(id)initWithAddress:(OSAddress *)address userID: (NSNumber *)userID  title:(NSString *)title;

@end
