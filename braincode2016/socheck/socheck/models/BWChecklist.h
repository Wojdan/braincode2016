//
//  BWChecklist.h
//  Socheck
//
//  Created by Bartłomiej Wojdan on 19.03.2016.
//  Copyright © 2016 Bartłomiej Wojdan. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface BWChecklist : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *about;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, strong) NSArray *items;

@end
