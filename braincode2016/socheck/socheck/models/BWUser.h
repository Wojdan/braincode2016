//
//  BWUser.h
//  socheck
//
//  Created by Bartłomiej Wojdan on 19.03.2016.
//  Copyright © 2016 Bartłomiej Wojdan. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface BWUser : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *identifier;

@end
