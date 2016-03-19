//
//  BWAPIClient.m
//  socheck
//
//  Created by Bartłomiej Wojdan on 19.03.2016.
//  Copyright © 2016 Bartłomiej Wojdan. All rights reserved.
//

#import "BWAPIClient.h"

@interface BWAPIClient () <NSURLSessionDelegate>

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSString *accessToken;

@end

#define kAPIHost @""
#define kAccessTokenDeafultsKey @"kAccessTokenDeafultsKey"

@implementation BWAPIClient

+ (instancetype)sharedClient {
    
    static BWAPIClient *_sharedClient = nil;
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        _sharedClient = [BWAPIClient new];
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionConfiguration.allowsCellularAccess = YES;
        _sharedClient.session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:_sharedClient delegateQueue:nil];
        _sharedClient.accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:kAccessTokenDeafultsKey];
    });
    
    return _sharedClient;
}

+ (BOOL)canPerformAutologin {
    return [BWAPIClient sharedClient].accessToken;
}

+ (void)setAccessToken:(NSString*)accessToken {
    
    [BWAPIClient sharedClient].accessToken = accessToken;
    
    if (!accessToken) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kAccessTokenDeafultsKey];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:kAccessTokenDeafultsKey];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Prepairing requests

+ (NSURL*)apiURLWithRelativePath:(NSString*)relativePath {
    if (!relativePath.length)
        return nil;
    NSString *absolutePath = [kAPIHost stringByAppendingString:relativePath];
    return [NSURL URLWithString:absolutePath];
}

+ (void)runDataTaskWithRequest:(NSURLRequest*)request
            allowCacheResponse:(BOOL)allowCacheResponse
                    completion:(void (^)(id responseObject, BOOL responseFromCache))completion
                       failure:(void (^)(id responseObject, NSError *error))failure {
    
    
    BWAPIClient *apiClient = [BWAPIClient sharedClient];
    
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    mutableRequest.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    
    NSURLSessionDataTask *dataTask = [apiClient.session dataTaskWithRequest:mutableRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        
        
    }];
    
    [dataTask resume];
}

#pragma mark - API methods

+ (void)authenticateUserWithUsername:(NSString*)username
                            password:(NSString*)password
                             success:(void(^)())success
                             failure:(void(^)(id responseObject, NSError *error))failure {
    
    NSDictionary *parameters = @{
                                 @"username" : username,
                                 @"password" : password
                                 };
    
    NSData *httpBody = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[BWAPIClient apiURLWithRelativePath:@"api/auth/"]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:httpBody];
    
    void (^successBlock)(id, BOOL) = ^(id responseObject, BOOL responseFromCache) {
        if (success) {
            success();
        }
    };
    
    void (^errorBlock)(id, NSError*) = ^(id responseObject, NSError *error) {
        if (failure) {
            failure(responseObject, error);
        }
    };
    
    [BWAPIClient runDataTaskWithRequest:request
                     allowCacheResponse:NO
                             completion:successBlock
                                failure:errorBlock];
    
}

+ (void)registerUserWithUsername:(NSString*)username
                        password:(NSString*)password
                           email:(NSString*)email
                         success:(void(^)())success
                         failure:(void(^)(id responseObject, NSError *error))failure {

    NSDictionary *parameters = @{
                                 @"email" : email,
                                 @"username" : username,
                                 @"password" : password
                                 };
    
    NSData *httpBody = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[BWAPIClient apiURLWithRelativePath:@"api/user/"]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:httpBody];
    
    void (^successBlock)(id, BOOL) = ^(id responseObject, BOOL responseFromCache) {
        if (success) {
            success();
        }
    };
    
    void (^errorBlock)(id, NSError*) = ^(id responseObject, NSError *error) {
        if (failure) {
            failure(responseObject, error);
        }
    };
    
    [BWAPIClient runDataTaskWithRequest:request
                     allowCacheResponse:NO
                             completion:successBlock
                                failure:errorBlock];
}

@end
