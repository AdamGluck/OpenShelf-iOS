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

+ (instancetype)createWithDataFromDictionary:(NSDictionary *)dictionary {
    NSObject *object = [self new];
    
    [object populateObjectWithDataFromDictionary:dictionary];
    
    
    //    for (NSString *key in [info allKeys]) {
    //        id value = info[key];
    //        NSString *keyToCamelCase = [key underscoreToCamelCase];
    //
    //        if ([object respondsToSelector:@selector(key)]) {
    //            [object setValue:value
    //                      forKey:key];
    //        }
    //        else if ([object.class instancesRespondToSelector:@selector(keyToCam)]) {
    //                [object setValue:value
    //                          forKey:keyToCamelCase];
    //
    //        }
    //    }
    
    return object;
}

-(void)populateObjectWithDataFromDictionary:(NSDictionary *)dictionary{
    NSObject *object = self;
    for (NSString *property in object.getPropertyList) {
        // look for the underscore in camelcase form first
        id value = dictionary[property];
        NSString *underscoreProperty;
        
        // if it doesn't exist, convert to underscore and check that
        if (value == nil) {
            underscoreProperty = [property camelCaseToUnderscores];
            value = dictionary[underscoreProperty];
        }
        
        // if it still doesn't exist, dictionary does not contain value for that property
        if (value == nil) {
            NSLog(@"No value in dictionary for keys %@, %@", property, underscoreProperty);
        }
        
        // else if it does, set the property to the value
        else{
            //Recursive calls to handle collections
            if ([value isKindOfClass:[NSArray class]]) {
                
                NSMutableArray *array = [[NSMutableArray alloc]init];
                for (NSObject *object in value) {
                    if ([object isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *objectDict = (NSDictionary *)object;
                        NSString *className = [self convertPluralKeyToClassName:property];
                        
                        NSObject *childObject = [NSClassFromString(className) createWithDataFromDictionary:objectDict];
                        [array addObject:childObject];
                        
                    }
                    else{
                        [array addObject:object];
                    }
                    
                }
                //                [object setValue:array forKey:property];
                value = array;
            }
            else if ([value isKindOfClass:[NSDictionary class]]){
                NSString *className = [self convertKeyToClassName:property];
                id someObject = [NSClassFromString(className) createWithDataFromDictionary:value];
                if (someObject) {
                    value = someObject;
                }
            }
            [object setValue:value forKey:property];
        }
    }

}

- (NSArray *)getPropertyList {
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

-(NSString *)convertPluralKeyToClassName:(NSString *)string{
    NSString *className = [self convertKeyToClassName:string];
    className = [className substringToIndex:[className length] - 1];
    return className;
}
-(NSString *)convertKeyToClassName:(NSString *)string{
    NSString *className = [string stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                          withString:[[string substringToIndex:1] capitalizedString]];
    className = [NSString stringWithFormat:@"OS%@",className];
    return className;
}

-(NSDictionary *)mapToDictionary{
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    NSArray *propertyList = self.getPropertyList;
    for (NSString *property in propertyList) {
        NSString *key = [property camelCaseToUnderscores];
        id value = [self valueForKey:property];
        if ([value isKindOfClass:NSArray.class]) {
            NSMutableArray *array = [NSMutableArray arrayWithArray:(NSArray *) value];
            if ([[array firstObject] respondsToSelector:@selector(mapToDictionary)]) {
                for (int i = 0; i < array.count; i++) {
                    NSObject *object = array[i];
                    NSDictionary *objectDict = [object mapToDictionary];
                    [array replaceObjectAtIndex:i withObject:objectDict];
                }
                
            }
            [dictionary setValue:array forKey:key];
        }
        else{
            if ([value respondsToSelector:@selector(getPropertyList)] && ![value isKindOfClass:NSString.class] && ((NSObject *)value).getPropertyList.count > 1) {
                NSObject *object = (NSObject *)value;
                NSDictionary *objectDict = [object mapToDictionary];
                [dictionary setValue:objectDict forKey:key];
            }
            else{
                [dictionary setValue:[self valueForKey:property] forKey:key];
            }
        }
    }
    
    return dictionary;
}


-(NSString *)convertClassNameToPluralKey:(NSString *)string{
    NSString *className = [self convertKeyToClassName:string];
    className = [className substringToIndex:[className length] - 1];
    return className;
}
-(NSString *)convertClassNameToKey:(NSString *)string{
    NSString *className = [string stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                          withString:[[string substringToIndex:1] capitalizedString]];
    className = [NSString stringWithFormat:@"OS%@",className];
    return className;
}
@end
