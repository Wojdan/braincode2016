//
//  BWUserSocheckCell.h
//  socheck
//
//  Created by Bartłomiej Wojdan on 19.03.2016.
//  Copyright © 2016 Bartłomiej Wojdan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BWUserSocheckCell;
@protocol BWUserSocheckCellDelegate <NSObject>

- (void)cellDidPressDeleteButton:(BWUserSocheckCell*)cell;

@end

@interface BWUserSocheckCell : UITableViewCell

@property (weak, nonatomic) id<BWUserSocheckCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *orderLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *separator;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UILabel *checkedLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *checkmarkButton;

@end
