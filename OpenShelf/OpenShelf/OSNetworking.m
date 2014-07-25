//
//  OSNetworking.m
//
//  Created by Brian Strobach on 7/1/14.
//  Copyright (c) 2014 Brian Strobach. All rights reserved.
//

#import "OSNetworking.h"

static NSString *kBaseURL = @"http://openshelf.herokuapp.com/";

@implementation OSNetworking

#pragma mark - Initialization

+ (id)sharedInstance
{
    static dispatch_once_t pred;
    static OSNetworking *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

#pragma - Requests

- (void)askServerForRequest:(NSMutableURLRequest *)request
                    success:(void (^)(NSDictionary *dictionary, NSError *error))successCompletion
                    failure:(void (^)(void))failureCompletion
{
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request
                                     completionHandler:^(NSData *data,
                                                         NSURLResponse *response,
                                                         NSError *error) {
                                         
                                         // handle response
                                         //NSLog(@"Data:%@",data);
                                         NSLog(@"Response:%@",response);
                                         NSLog(@"Server Error:%@",[error localizedDescription]);
                                         NSError *jsonError;
                                         NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
                                         NSLog(@"DownloadeJSONData:%@",dictionary);

                                         
                                         NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
                                         if (httpResp.statusCode == 200) {
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 successCompletion(dictionary,nil);
                                             });
                                         } else {
                                             NSLog(@"Fail Not 200:");
                                             NSLog(@"Errors:%@", dictionary);
                                             
                                             NSMutableString *errorMessage = [dictionary objectForKey:@"errors"];
                                             NSLog(@"ERROR MESSAGE%@", errorMessage);

                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 failureCompletion();
                                             });
                                         }
                                         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                     }] resume];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

/* 
 Attempts to create a new account in the database.
 */
- (void)createAccountWithUsername:(NSString *)username
                            email:(NSString *)email
                         password:(NSString *)password
             passwordConfirmation:(NSString *)passwordConfirmation
                          success:(void (^)(NSDictionary *dictionary, NSError *error))successCompletion
                          failure:(void (^)(void))failureCompletion{

    NSString *accountParameterString = @"NEED TO CREATE PARAMETER STRING";
    
    NSURL *url = [NSURL URLWithString:accountParameterString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //request.HTTPBody = [playerDataParametersString dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPMethod = @"POST";
    [self askServerForRequest:request success:successCompletion failure:failureCompletion];
    
}

/* 
 Attempts to log the user in on the server.
 */
- (void)loginWithEmail:(NSString *)email
                 password:(NSString *)password
                  success:(void (^)(NSDictionary *dictionary, NSError *error))successCompletion
                  failure:(void (^)(void))failureCompletion{

    NSString *loginParameterString = [NSString stringWithFormat:@"%@api/users/account/email=%@&password=%@", kBaseURL, email, password];
    NSURL *url = [NSURL URLWithString: loginParameterString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    [self askServerForRequest:request success:successCompletion failure:failureCompletion];
}

/* 
 Downloads a list items based on a search request.
 */

- (void)downloadItemsForSearchTerms:(NSString *)searchTerms
                            success:(void (^)(NSDictionary *dictionary, NSError *error))successCompletion
                            failure:(void (^)(void))failureCompletion{

    NSString *searchTermsParemterString = [NSString stringWithFormat:@"http://echo.jsontest.com/title/testtitle/description/testdescription"];
    NSURL *url = [NSURL URLWithString: searchTermsParemterString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [self askServerForRequest:request success:successCompletion failure:failureCompletion];
    
}

- (void)downloadInventoryListWithSuccessBlock:(void (^)(NSDictionary *dictionary, NSError *error))successCompletion
                            failureBlock:(void (^)(void))failureCompletion{
    
    NSString *parameterString = [NSString stringWithFormat:@"%@api/items/all", kBaseURL];
    NSURL *url = [NSURL URLWithString: parameterString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [self askServerForRequest:request
                      success:successCompletion
                      failure:failureCompletion];
    
}



#pragma mark - Asynchronous image downloading

- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}

-(void)loadImageFromURLString:(NSString*)urlString forImageView:(UIImageView*)imageView{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:urlString]];
        dispatch_sync(dispatch_get_main_queue(), ^{
            UIImage *downloadedImage = [[UIImage alloc] initWithData:imageData];
            [imageView setImage:downloadedImage];
        });
    });
}




@end