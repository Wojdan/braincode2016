//
//  BWSearchCell.m
//  Socheck
//
//  Created by Bartłomiej Wojdan on 19.03.2016.
//  Copyright © 2016 Bartłomiej Wojdan. All rights reserved.
//

#import "BWSearchCell.h"
#import "UIColor+BWSocheckColors.h"

@interface BWSearchCell ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *separatorHeight;

@end


@implementation BWSearchCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor clearColor];
    self.containerView.layer.masksToBounds = YES;
    
    self.separatorHeight.constant = 1.f / [UIScreen mainScreen].scale;
    self.statsLabel.textColor = [UIColor primaryColor];
    self.separator.backgroundColor = [UIColor colorWithWhite:0.75 alpha:1.f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
