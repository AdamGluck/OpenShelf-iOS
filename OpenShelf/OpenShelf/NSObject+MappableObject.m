//
//  NSObject+PropertyList.m
//  OpenShelf
//
//  Created by Brian Strobach on 7/2/14.
//  Copyright (c) 2014 OpenShelf. All rights reserved.
//

#import "NSObject+MappableObject.h"
#import "NSString+StyleConversions.h"
#import <objc/runtime.h>

@implementation NSObject (MappableObject)

+ (instancetype)createFromInfo:(NSDictionary *)info {
    NSObject *object = [self new];
    
    for (NSString *property in object.propertyList) {
        id value = info[property];
        // look for the underscore form "firstName" -> "first_name"
        if (value == nil) {
            NSString *camelCaseProperty = [property underscoreToCamelCase];
            value = info[camelCaseProperty];
        }
        if (value == nil) {
            NSLog(@"No value in dictionary for key %@", property);
        }
        else{
        [object setValue:value
                  forKey:property];
        }
    }
    
    return object;
}

- (NSArray *)propertyList {
    Class currentClass = [self class];
    
    NSMutableArray *propertyList = [[NSMutableArray alloc]init];
    // class_copyPropertyList does not include properties declared in super classes
    // so we have to follow them until we reach NSObject
    do {
        unsigned int outCount, i;
        objc_property_t *properties = class_copyPropertyList(currentClass, &outCount);
        
        for (i = 0; i < outCount; i++) {
            objc_property_t property = properties[i];
            
            NSString *propertyName = [NSString stringWithFormat:@"%s", property_getName(property)];
            
            [propertyList addObject:propertyName];
        }
        free(properties);
        currentClass = [currentClass superclass];
    } while ([currentClass superclass]);
    
    return propertyList;
}
@end
