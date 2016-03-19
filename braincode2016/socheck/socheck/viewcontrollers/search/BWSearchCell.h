//
//  BWSearchCell.h
//  Socheck
//
//  Created by Bartłomiej Wojdan on 19.03.2016.
//  Copyright © 2016 Bartłomiej Wojdan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BWSearchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *creatorLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *separator;
@property (weak, nonatomic) IBOutlet UILabel *statsLabel;
@property (weak, nonatomic) IBOutlet UILabel *aboutLabel;

@end
