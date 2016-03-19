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
#import "BWAPIClient.h"
#import "BWResultViewController.h"
#import "BWChecklistViewController.h"

@interface BWSearchViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (strong, nonatomic) NSMutableArray *results;

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
    
    self.searchField.textColor = [UIColor whiteColor];
    self.searchField.tintColor = [UIColor whiteColor];
    self.searchField.delegate = self;
    
    [self.view layoutIfNeeded];
    
    CGFloat lineWidth = 1.f;
    CAShapeLayer *underlineLayer = [CAShapeLayer new];
    underlineLayer.frame = CGRectMake(0, CGRectGetMaxY(self.searchField.bounds)-lineWidth, CGRectGetWidth(self.searchField.frame), lineWidth);
    underlineLayer.backgroundColor = [UIColor whiteColor].CGColor;
    [self.searchField.layer addSublayer:underlineLayer];
    self.searchField.backgroundColor = [UIColor clearColor];
    underlineLayer.rasterizationScale = [UIScreen mainScreen].scale;
    underlineLayer.shouldRasterize = YES;
    
    
    self.searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"What are you looking for?"
                                                                               attributes:@{
                                                                                            NSForegroundColorAttributeName : [UIColor colorWithWhite:0.9 alpha:1],
                                                                                            NSFontAttributeName:self.searchField.font
                                                                                            }];

}

#pragma mark - Table view data source

- (NSMutableArray *)results {
    if (!_results) {
        _results = [NSMutableArray new];
    }
    return _results;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.results.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BWSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BWSearchCell" forIndexPath:indexPath];
    
    BWChecklist *checklist = self.results[indexPath.row];
    
    cell.creatorLabel.text = checklist.creator;
    cell.nameLabel.text = checklist.title;
    cell.aboutLabel.text = checklist.about;
    cell.statsLabel.text = checklist.downloadCount.stringValue;
    return cell;
}

- (IBAction)searchButtonPressed:(id)sender {
    if (![self.searchField isFirstResponder]) {
        [self.searchField becomeFirstResponder];
    } else {
        [self.searchField resignFirstResponder];
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BWChecklist *checklist = self.results[indexPath.row];
    BWResultViewController *rVC = [BWResultViewController createWithChecklist:checklist];
    [self presentViewController:rVC animated:YES completion:nil];
    
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *replacementString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (replacementString.length) {
        [BWAPIClient searchChecklistByTag:replacementString success:^(NSArray *checklists) {
            self.results = [NSMutableArray arrayWithArray:checklists];
            [self.tableView reloadData];
        } failure:^(id responseObject, NSError *error) {
        
        }];
    } else {
        self.results = nil;
        [self.tableView reloadData];
    }
    
    return YES;
}


@end
