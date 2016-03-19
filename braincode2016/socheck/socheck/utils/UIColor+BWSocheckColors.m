//
//  UIColor+BWSocheckColors.m
//  socheck
//
//  Created by Bartłomiej Wojdan on 18.03.2016.
//  Copyright © 2016 Bartłomiej Wojdan. All rights reserved.
//

#import "UIColor+BWSocheckColors.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation UIColor (BWSocheckColors)

+ (instancetype)primaryColor {
    return UIColorFromRGB(0x4CAF50);
}
+ (instancetype)darkPrimaryColor {
    return UIColorFromRGB(0x4CAF50);
}
+ (instancetype)lightPrimaryColor {
    return UIColorFromRGB(0xC8E6C9);
}
+ (instancetype)accentColor {
    return UIColorFromRGB(0x607D8B);
}
+ (instancetype)primaryTextColor {
    return UIColorFromRGB(0x212121);
}
+ (instancetype)secondaryTextColor {
    return UIColorFromRGB(0x727272);
}
+ (instancetype)randomColor {
    return UIColorFromRGB(arc4random() % 0x1000000);
}
+ (instancetype)lightBackgroundColor {
    return [UIColor colorWithWhite:.98f alpha:1.f];
}

@end
