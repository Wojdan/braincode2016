//
//  BWChecklistViewController.m
//  Socheck
//
//  Created by Bartłomiej Wojdan on 19.03.2016.
//  Copyright © 2016 Bartłomiej Wojdan. All rights reserved.
//

#import "BWChecklistViewController.h"

#import "UIColor+BWSocheckColors.h"
#import "BWUserSocheckCell.h"
#import "BWAPIClient.h"
#import "BWChecklist.h"

@interface BWChecklistViewController () <UITextFieldDelegate, BWUserSocheckCellDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *descTextField;
@property (weak, nonatomic) IBOutlet UITextField *itemTextField;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progresWIdth;
@property (strong, nonatomic) BWChecklist *checklist;

@end

@implementation BWChecklistViewController

+ (instancetype)createWithChecklist:(BWChecklist*)checklist {
    BWChecklistViewController *vc = [[UIStoryboard storyboardWithName:NSStringFromClass([self class])
                                                            bundle:nil] instantiateInitialViewController];
    vc.checklist = checklist;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.progresWIdth.constant = 0.f;
    [self.view layoutIfNeeded];
    
    self.nameTextField.text = self.checklist.title;
    self.descTextField.text = self.checklist.about;
    
    self.topView.backgroundColor = [UIColor accentColor];
    self.descTextField.textColor = [UIColor whiteColor];
    self.nameTextField.textColor = [UIColor whiteColor];
    
    self.nameTextField.tintColor = [UIColor whiteColor];
    self.descTextField.tintColor = [UIColor whiteColor];
    
    self.descTextField.userInteractionEnabled = NO;
    self.nameTextField.userInteractionEnabled = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardFrameChangeNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [self.view layoutIfNeeded];
    
    
    self.nameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Type socheck name"
                                                                               attributes:@{
                                                                                            NSForegroundColorAttributeName : [UIColor colorWithWhite:0.9 alpha:1],
                                                                                            NSFontAttributeName:self.nameTextField.font
                                                                                            }];
    
    self.descTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Add brief description"
                                                                               attributes:@{
                                                                                            NSForegroundColorAttributeName : [UIColor colorWithWhite:0.9 alpha:1],
                                                                                            NSFontAttributeName:self.descTextField.font
                                                                                            }];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BWUserSocheckCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([BWUserSocheckCell class])];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.addButton.backgroundColor = [UIColor primaryColor];
    [self.addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat progress = [tableView indexPathsForSelectedRows].count;
    
    [UIView animateWithDuration:0.2f animations:^{
        self.progresWIdth.constant = CGRectGetWidth(self.view.bounds)* progress/self.checklist.items.count;
        [self.view layoutIfNeeded];
    }];
    
    self.topImageView.image = [UIImage imageNamed:progress/self.checklist.items.count == 1 ? @"bg_green" : @"bg_blue"];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat progress = [tableView indexPathsForSelectedRows].count;
    
    [UIView animateWithDuration:0.2f animations:^{
        self.progresWIdth.constant = CGRectGetWidth(self.view.bounds)* progress/self.checklist.items.count;
        [self.view layoutIfNeeded];
    }];
    
    self.topImageView.image = [UIImage imageNamed:progress/self.checklist.items.count == 1 ? @"bg_green" : @"bg_blue"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.checklist.items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BWUserSocheckCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BWUserSocheckCell" forIndexPath:indexPath];
    cell.orderLabel.text = @(indexPath.row+1).stringValue;
    cell.nameLabel.text = self.checklist.items[indexPath.row];
    cell.delegate = self;
    cell.deleteButton.hidden = YES;
    return cell;
}

- (void)cellDidPressDeleteButton:(BWUserSocheckCell *)cell {
    
}

- (IBAction)closeButtonPressed:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)finishButtonPressed:(id)sender {
    
    
}

- (void)handleKeyboardFrameChangeNotification:(NSNotification*)notification {
    
    NSDictionary* info = [notification userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:2.f animations:^{
        self.bottom.constant = (CGRectGetHeight([UIScreen mainScreen].bounds) - CGRectGetMinY(kbRect));
        [self.view layoutIfNeeded];
    }];
}


@end
