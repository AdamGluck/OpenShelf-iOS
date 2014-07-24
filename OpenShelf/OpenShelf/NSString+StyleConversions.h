//
//  NSString+StyleConversions.h
//  OpenShelf
//
//  Created by Brian Strobach on 7/2/14.
//  Copyright (c) 2014 OpenShelf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (StyleConversions)
-(NSString*)underscoreToCamelCase;
-(NSString *)camelCaseToUnderscores;
@end
