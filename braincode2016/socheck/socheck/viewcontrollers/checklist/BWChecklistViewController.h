//
//  BWChecklistViewController.h
//  Socheck
//
//  Created by Bartłomiej Wojdan on 19.03.2016.
//  Copyright © 2016 Bartłomiej Wojdan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BWChecklist;
@interface BWChecklistViewController : UIViewController
+ (instancetype)createWithChecklist:(BWChecklist*)checklist;
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@end
