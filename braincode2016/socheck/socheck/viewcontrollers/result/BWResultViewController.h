//
//  BWResultViewController.h
//  Socheck
//
//  Created by Bartłomiej Wojdan on 19.03.2016.
//  Copyright © 2016 Bartłomiej Wojdan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BWChecklist;
@interface BWResultViewController : UIViewController
+ (instancetype)createWithChecklist:(BWChecklist*)checklist;
@end
