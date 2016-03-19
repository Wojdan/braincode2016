//
//  BWChecklist.m
//  Socheck
//
//  Created by Bartłomiej Wojdan on 19.03.2016.
//  Copyright © 2016 Bartłomiej Wojdan. All rights reserved.
//

#import "BWChecklist.h"

@implementation BWChecklist

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             NSStringFromSelector(@selector(identifier)) : @"chid",
             NSStringFromSelector(@selector(creator)) : @"author",
             NSStringFromSelector(@selector(title)) : @"title",
             NSStringFromSelector(@selector(about)) : @"description",
             NSStringFromSelector(@selector(downloadCount)) : @"stats.likes",
             NSStringFromSelector(@selector(tags))  : @"tags",
             NSStringFromSelector(@selector(items)) : @"items"
             };
}

@end
