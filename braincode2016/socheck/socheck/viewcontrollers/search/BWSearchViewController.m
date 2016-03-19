//
//  BWSearchViewController.m
//  Socheck
//
//  Created by Bartłomiej Wojdan on 19.03.2016.
//  Copyright © 2016 Bartłomiej Wojdan. All rights reserved.
//

#import "BWSearchViewController.h"
#import "BWSearchCell.h"
#import "UIColor+BWSocheckColors.h"

@interface BWSearchViewController () <UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation BWSearchViewController

+ (instancetype)create {
    return [[UIStoryboard storyboardWithName:NSStringFromClass([BWSearchViewController class])
                                      bundle:nil] instantiateInitialViewController];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.headerView.backgroundColor = [UIColor primaryColor];
    
    self.searchBar.barTintColor = [UIColor primaryColor];
    self.searchBar.layer.borderColor = [UIColor primaryColor].CGColor;
    self.searchBar.layer.borderWidth = 1.f;
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"";
    self.searchBar.tintColor = [UIColor primaryTextColor];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BWSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BWSearchCell" forIndexPath:indexPath];
    
    
    return cell;
}

@end
