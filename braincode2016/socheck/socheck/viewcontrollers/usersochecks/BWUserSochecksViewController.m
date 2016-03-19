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
#import "BWAPIClient.h"
#import "BWSearchCell.h"
#import "BWChecklistViewController.h"


@interface BWUserSochecksViewController ()
@property (weak, nonatomic) IBOutlet UIView *tableHeaderView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (strong, nonatomic) NSMutableArray *myItems;
@property (strong, nonatomic) NSMutableArray *otherItems;

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
    [self reloadData];
}

- (void)reloadData {
    
    self.myItems = [NSMutableArray new];
    self.otherItems = [NSMutableArray new];
    
    [BWAPIClient getUserWithSuccess:^(NSArray *checklists, NSString*username) {
        
        for (BWChecklist *checklist in checklists) {
            if ([checklist.creator isEqualToString:username]) {
                [self.myItems addObject:checklist];
            } else {
                [self.otherItems addObject:checklist];
            }
        }
        
        [self.tableView reloadData];
        
    } failure:^(id responseObject, NSError *error) {
        
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (self.myItems.count != 0) + (self.otherItems.count != 0);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? self.myItems.count : self.otherItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    BWSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BWSearchCell" forIndexPath:indexPath];
    
    BWChecklist *checklist = indexPath.section == 0 ? self.myItems[indexPath.row] : self.otherItems[indexPath.row];
    
    cell.creatorLabel.text = checklist.creator;
    cell.nameLabel.text = checklist.title;
    cell.aboutLabel.text = checklist.about;
    cell.statsLabel.text = checklist.downloadCount.stringValue;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, CGRectGetWidth(tableView.frame), 50.f)];
    headerView.backgroundColor = [UIColor accentColor];
    headerView.clipsToBounds = YES;
    
    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:headerView.bounds];
    backgroundImage.image = [UIImage imageNamed:section == 0 ? @"bg_green" : @"bg_blue"];
    backgroundImage.contentMode = UIViewContentModeScaleAspectFill;
    [headerView addSubview:backgroundImage];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectInset(headerView.frame, 16 , 13)];
    titleLabel.font = [UIFont fontWithName:@"Avenir-Heavy" size:11.f];
    titleLabel.text = section == 0 ? @"CREATED BY YOU" : @"CREATED BY OTHERS";
    titleLabel.textColor = [UIColor whiteColor];
    [headerView addSubview:titleLabel];
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BWChecklist *checklist = indexPath.section == 0 ? self.myItems[indexPath.row] : self.otherItems[indexPath.row];
    BWChecklistViewController *rVC = [BWChecklistViewController createWithChecklist:checklist];
    [self presentViewController:rVC animated:YES completion:nil];
}

@end
