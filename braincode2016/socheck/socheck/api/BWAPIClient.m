//
//  BWAPIClient.m
//  socheck
//
//  Created by Bartłomiej Wojdan on 19.03.2016.
//  Copyright © 2016 Bartłomiej Wojdan. All rights reserved.
//

@import UIKit;

#import "BWAPIClient.h"
#import "Mantle.h"
#import "EVLogger.h"

@interface BWAPIClient () <NSURLSessionDelegate>

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSString *accessToken;

@end

#define kAPIHost @"http://54.93.79.160/socheck/api/"
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
    
    if (apiClient.accessToken.length) {
        [mutableRequest setValue:apiClient.accessToken forHTTPHeaderField:@"AccessToken"];
    }
    
    NSURLSessionDataTask *dataTask = [apiClient.session dataTaskWithRequest:mutableRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        __unused NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data ? data : [NSData data] options:0 error:nil];
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
        
        [EVLogger logRequest:request response:httpResponse];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error && completion) {
                completion(json, NO);
            } else if (error && failure) {
                failure(json, error);
            }
        });
    }];
    
    [dataTask resume];
}

#pragma mark - API methods

+ (void)authenticateUserWithUsername:(NSString*)username
                            password:(NSString*)password
                             success:(void(^)())success
                             failure:(void(^)(id responseObject, NSError *error))failure {
    
    NSDictionary *parameters = @{
                                 @"login" : username,
                                 @"password" : password
                                 };
    
    NSData *httpBody = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[BWAPIClient apiURLWithRelativePath:@"auth/"]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:httpBody];
    
    void (^successBlock)(id, BOOL) = ^(id responseObject, BOOL responseFromCache) {
        
        NSDictionary *json = (NSDictionary*)responseObject;
        [BWAPIClient setAccessToken:[json objectForKey:@"token"]];
        
        if (![BWAPIClient sharedClient].accessToken.length) {
            
            [[[UIAlertView alloc] initWithTitle:@"Login error" message:@"Invalid credentials" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil] show];
            
            if (failure) {
                failure(responseObject, nil);
            }
            return;
        }
        
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
                                 @"login" : username,
                                 @"password" : password
                                 };
    
    NSData *httpBody = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[BWAPIClient apiURLWithRelativePath:@"user/"]];
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


+ (void)postChecklist:(BWChecklist*)checklist
              success:(void(^)())success
              failure:(void(^)(id responseObject, NSError *error))failure {
    
    NSDictionary *parameters = [MTLJSONAdapter JSONDictionaryFromModel:checklist error:nil];
    
    NSData *httpBody = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[BWAPIClient apiURLWithRelativePath:@"checklist/"]];
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


+ (void)searchChecklistByTag:(NSString*)tag
                     success:(void(^)(NSArray *checklists))success
                     failure:(void(^)(id responseObject, NSError *error))failure {
    
    NSURL *url = [NSURL URLWithString:[tag stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] relativeToURL:[BWAPIClient apiURLWithRelativePath:@"checklist/tag/"]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setHTTPMethod:@"GET"];
    
    void (^successBlock)(id, BOOL) = ^(id responseObject, BOOL responseFromCache) {
        
        NSArray *results = [responseObject objectForKey:@"results"];
        NSArray *checklists = [MTLJSONAdapter modelsOfClass:[BWChecklist class] fromJSONArray:results error:nil];
        
        if (success) {
            success(checklists);
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


+ (void)getUserWithSuccess:(void(^)(NSArray *checklists, NSString *username))success
                   failure:(void(^)(id responseObject, NSError *error))failure {

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[BWAPIClient apiURLWithRelativePath:@"opt/user"]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setValue:[BWAPIClient sharedClient].accessToken forHTTPHeaderField:@"AccessToken"];
    [request setHTTPMethod:@"GET"];
    
    void (^successBlock)(id, BOOL) = ^(id responseObject, BOOL responseFromCache) {
        
        NSArray *results = [responseObject objectForKey:@"checklists"];
        NSArray *checklists = [MTLJSONAdapter modelsOfClass:[BWChecklist class] fromJSONArray:results error:nil];
        NSString *username = [responseObject objectForKey:@"username"];
        if (success) {
            success(checklists, username);
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


+ (void)storeChecklistWithId:(NSNumber*)identifier
                     success:(void(^)())success
                     failure:(void(^)(id responseObject, NSError *error))failure {
    
    NSURL *url = [NSURL URLWithString:[identifier.stringValue stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] relativeToURL:[BWAPIClient apiURLWithRelativePath:@"checklist/"]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setValue:[BWAPIClient sharedClient].accessToken forHTTPHeaderField:@"AccessToken"];
    [request setHTTPMethod:@"GET"];
    
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
