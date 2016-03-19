//
//  BWAPIClient.h
//  socheck
//
//  Created by Bartłomiej Wojdan on 19.03.2016.
//  Copyright © 2016 Bartłomiej Wojdan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BWChecklist.h"

@interface BWAPIClient : NSObject

+ (instancetype)sharedClient;
+ (BOOL)canPerformAutologin;

+ (void)authenticateUserWithUsername:(NSString*)username
                            password:(NSString*)password
                             success:(void(^)())success
                             failure:(void(^)(id responseObject, NSError *error))failure;

+ (void)registerUserWithUsername:(NSString*)username
                        password:(NSString*)password
                           email:(NSString*)email
                         success:(void(^)())success
                         failure:(void(^)(id responseObject, NSError *error))failure;

+ (void)postChecklist:(BWChecklist*)checklist
                         success:(void(^)())success
                         failure:(void(^)(id responseObject, NSError *error))failure;
@end
