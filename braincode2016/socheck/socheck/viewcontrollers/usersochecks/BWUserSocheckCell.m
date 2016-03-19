//
//  BWUserSocheckCell.m
//  socheck
//
//  Created by Bartłomiej Wojdan on 19.03.2016.
//  Copyright © 2016 Bartłomiej Wojdan. All rights reserved.
//

#import "BWUserSocheckCell.h"
#import "UIColor+BWSocheckColors.h"

@interface BWUserSocheckCell()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *separatorHeight;
@property (weak, nonatomic) IBOutlet UIView *progressView;

@end

@implementation BWUserSocheckCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    self.containerView.layer.masksToBounds = YES;
    
    self.orderLabel.textColor = [UIColor secondaryTextColor];
    self.orderLabel.layer.borderColor = [UIColor secondaryTextColor].CGColor;
    self.orderLabel.layer.borderWidth = 1.f;
    self.orderLabel.layer.cornerRadius = 8.f;
    
    self.nameLabel.textColor = [UIColor primaryTextColor];
    self.separatorHeight.constant = 1.f / [UIScreen mainScreen].scale;
    self.separator.backgroundColor = [UIColor colorWithWhite:0.75 alpha:1.f];
    self.progressView.backgroundColor = [UIColor primaryColor];
    self.progressLabel.textColor = [UIColor primaryColor];
    
    self.checkmarkButton.hidden = YES;
    self.checkmarkButton.tintColor = [UIColor primaryColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.checkmarkButton.hidden = !selected || !self.deleteButton.hidden;
}

- (IBAction)deleteBUttonPressed:(id)sender {
    [self.delegate cellDidPressDeleteButton:self];
}
@end
