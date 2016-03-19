//
//  EVLogger.m
//  eventory
//
//  Created by Bartomiej  Wojdan on 22.04.2015.
//  Copyright (c) 2015 coders-mill. All rights reserved.
//

#import "EVLogger.h"

@implementation EVLogger

#pragma mark - Network traffic

+ (void)logRequest:(NSURLRequest*)request response:(NSHTTPURLResponse*)response{
    
#if LOGGER_ENABLED == 0
    return;
#endif
    
    NSMutableString *log = [[NSMutableString alloc] initWithString:@"\n\n----------------------------------------\n"];
    
    if (request) [log appendFormat:@"HOST: %@\n", request.URL.host];
    if (request) [log appendFormat:@"REQUEST: %@\n", request.URL.relativePath];
    if ([[request.URL.absoluteString componentsSeparatedByString:@"?"] count] > 1)
        if (request) [log appendFormat:@"PARAMETERS: \n\t%@\n", [[[[request.URL.absoluteString componentsSeparatedByString:@"?"] objectAtIndex:1] stringByReplacingOccurrencesOfString:@"&" withString:@"\n\t"] stringByReplacingOccurrencesOfString:@"=" withString:@" : "]? : @"none"];
    if (request) [log appendFormat:@"HTTPMethod: %@\n", request.HTTPMethod];
    if (request) [log appendFormat:@"HTTPHeaders: %@\n", request.allHTTPHeaderFields];
    if (request) [log appendFormat:@"HTTPBody: %@\n", request.HTTPBody ? [NSJSONSerialization JSONObjectWithData:request.HTTPBody options:0 error:nil] : @"none"];
    if (request && response) [log appendFormat:@"RESPONSE STATUS CODE: %d\n",(int)response.statusCode];
    if (request) [log appendFormat:@"----------------------------------------\n"];
    
    if (request) NSLog(@"%@",log);
}

+ (void)logKVOMessage:(NSString *)message {
    
#if LOGGER_ENABLED == 0
    return;
#endif
    
    NSMutableString *log = [[NSMutableString alloc] initWithString:@"\n\n----------------------------------------\n"];
    [log appendString:@"KEY-VALUE-OBSERVING - DEBUG LOG:\n\n"];
    [log appendFormat:@"\tMESSAGE: %@\n\n", message];
    [log appendFormat:@"----------------------------------------\n"];
    
    NSLog(@"%@", log);
}

@end
