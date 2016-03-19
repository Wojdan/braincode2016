//
//  BWUserSochecksViewController.m
//  socheck
//
//  Created by Bartłomiej Wojdan on 19.03.2016.
//  Copyright © 2016 Bartłomiej Wojdan. All rights reserved.
//

#import "BWUserSochecksViewController.h"
#import "BWUserSocheckCell.h"
#import "UIColor+BWSocheckColors.h"

@interface BWUserSochecksViewController ()
@property (weak, nonatomic) IBOutlet UIView *tableHeaderView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@end

@implementation BWUserSochecksViewController

+ (instancetype)create {
    return [[UIStoryboard storyboardWithName:NSStringFromClass([BWUserSochecksViewController class])
                                      bundle:nil] instantiateInitialViewController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f);

    self.tableHeaderView.backgroundColor = [UIColor primaryColor];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    BWUserSocheckCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BWUserSocheckCell" forIndexPath:indexPath];
    
    cell.orderLabel.text = @(indexPath.row).stringValue;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, CGRectGetWidth(tableView.frame), 40.f)];
    headerView.backgroundColor = [UIColor accentColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectInset(headerView.frame, 16 , 8)];
    titleLabel.font = [UIFont fontWithName:@"Avenir-Heavy" size:11.f];
    titleLabel.text = section == 0 ? @"CREATED BY YOU" : @"CREATED BY OTHERS";
    titleLabel.textColor = [UIColor whiteColor];
    [headerView addSubview:titleLabel];
    
    return headerView;
}

@end
