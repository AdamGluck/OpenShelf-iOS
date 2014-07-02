//
//  OSNetworking.m
//
//  Created by Brian Strobach on 7/1/14.
//  Copyright (c) 2014 Brian Strobach. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OSNetworking : NSObject

+ (id)sharedInstance;


- (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
                  success:(void (^)(NSDictionary *dictionary, NSError *error))successCompletion
                  failure:(void (^)(void))failureCompletion;

- (void)downloadItemsForSearchTerms:(NSString *)searchTerms
                            success:(void (^)(NSDictionary *dictionary, NSError *error))successCompletion
                               failure:(void (^)(void))failureCompletion;

- (void)createAccountWithUsername:(NSString *)username
                            email:(NSString *)email
                         password:(NSString *)password
             passwordConfirmation:(NSString *)passwordConfirmation
                          success:(void (^)(NSDictionary *dictionary, NSError *error))successCompletion
                          failure:(void (^)(void))failureCompletion;

@end
