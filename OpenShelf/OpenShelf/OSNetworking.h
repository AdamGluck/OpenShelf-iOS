//
//  OSNetworking.m
//
//  Created by Brian Strobach on 7/1/14.
//  Copyright (c) 2014 Brian Strobach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OSAddress.h"
#import "OSOrder.h"
@interface OSNetworking : NSObject

+ (id)sharedInstance;


- (void)loginWithEmail:(NSString *)email
              password:(NSString *)password
               success:(void (^)(NSDictionary *dictionary))successCompletion
               failure:(void (^)(NSError *error))failureCompletion;

- (void)downloadItemsForSearchTerms:(NSString *)searchTerms
                            success:(void (^)(NSDictionary *dictionary))successCompletion
                            failure:(void (^)(NSError *error))failureCompletion;

- (void)downloadInventoryListWithSuccessBlock:(void (^)(NSDictionary *dictionary))successCompletion
                                 failureBlock:(void (^)(NSError *error))failureCompletion;

- (void)createAccountWithEmail:(NSString *)email
                      password:(NSString *)password
          passwordConfirmation:(NSString *)passwordConfirmation
                       success:(void (^)(NSDictionary *dictionary))successCompletion
                       failure:(void (^)(NSError *error))failureCompletion;

- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock;
-(void)loadImageFromURLString:(NSString*)urlString forImageView:(UIImageView*)imageView;

- (void)addAddressToDatabase:(OSAddress *)address
                     success:(void (^)(NSDictionary *dictionary))successCompletion
                     failure:(void (^)(NSError *error))failureCompletion;

- (void)placeOrder:(OSOrder *)order
           success:(void (^)(NSDictionary *dictionary))successCompletion
           failure:(void (^)(NSError *error))failureCompletion;

-(void)addCreditCardWithId:(NSString *)token
                 forUserId:(NSNumber *)userId
                   success:(void (^)(NSDictionary *dictionary))successCompletion
                   failure:(void (^)(NSError *error))failureCompletion;
@end
