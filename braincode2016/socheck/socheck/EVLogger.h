//
//  EVLogger.h
//  eventory
//
//  Created by Bartomiej  Wojdan on 22.04.2015.
//  Copyright (c) 2015 coders-mill. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
#define LOGGER_ENABLED 1
#else
#define LOGGER_ENABLED 0
#endif
@interface EVLogger : NSObject

+ (void)logRequest:(NSURLRequest*)request response:(NSHTTPURLResponse*)response;
+ (void)logKVOMessage:(NSString*)message;

@end
