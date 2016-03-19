//
//  AppDelegate.h
//  socheck
//
//  Created by Bartłomiej Wojdan on 18.03.2016.
//  Copyright © 2016 Bartłomiej Wojdan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (void)setRootViewController:(UIViewController*)viewController animated:(BOOL)animated;

@end

