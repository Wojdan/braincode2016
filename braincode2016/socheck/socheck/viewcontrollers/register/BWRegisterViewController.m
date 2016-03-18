//
//  BWRegisterViewController.m
//  socheck
//
//  Created by Bartłomiej Wojdan on 19.03.2016.
//  Copyright © 2016 Bartłomiej Wojdan. All rights reserved.
//

#import "BWRegisterViewController.h"
#import "UIColor+BWSocheckColors.h"

@interface BWRegisterViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *loginTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *repasswordTextField;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginViewTop;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoBottom;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UILabel *registerLabel;

@end



@implementation BWRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardFrameChangeNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [self setup];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setup {
    
    [self.view layoutIfNeeded];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.98f alpha:1.f];
    
    self.logoBottom.constant = CGRectGetHeight([UIScreen mainScreen].bounds) * 0.25f - CGRectGetHeight(self.logoImageView.frame) * 0.5f;
    
    
    CGFloat lineWidth = .5f;
    
    for (UITextField *textField in @[self.emailTextField, self.loginTextField, self.passwordTextField, self.repasswordTextField]) {
        CAShapeLayer *underlineLayer = [CAShapeLayer new];
        underlineLayer.frame = CGRectMake(0, CGRectGetMaxY(textField.bounds)-lineWidth, CGRectGetWidth(textField.frame), lineWidth);
        underlineLayer.backgroundColor = [UIColor accentColor].CGColor;
        [textField.layer addSublayer:underlineLayer];
        textField.backgroundColor = [UIColor clearColor];
        underlineLayer.rasterizationScale = [UIScreen mainScreen].scale;
        underlineLayer.shouldRasterize = YES;
        textField.textColor = [UIColor primaryTextColor];
        
        UIView *insetView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 40)];
        textField.leftView = insetView;
        textField.leftViewMode = UITextFieldViewModeAlways;
    }
    
    self.passwordTextField.secureTextEntry = YES;
    self.repasswordTextField.secureTextEntry = YES;
    self.loginButton.layer.borderColor = [UIColor primaryColor].CGColor;
    self.loginButton.layer.borderWidth = 1.f;
    self.loginButton.layer.cornerRadius = 3.f;
    [self.loginButton setTitleColor:[UIColor primaryColor] forState:UIControlStateNormal];
    
    self.registerLabel.textColor = [UIColor accentColor];
    
    [self.registerButton setTitleColor:[UIColor secondaryTextColor] forState:UIControlStateNormal];
    
}

#pragma mark - Actions
- (void)handleKeyboardFrameChangeNotification:(NSNotification*)notification {
    
    NSDictionary* info = [notification userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGSize kbSize = kbRect.size;
    
    CGFloat loginViewMaxY = CGRectGetMaxY(self.passwordTextField.superview.frame);
    CGFloat keyboardMinY = CGRectGetHeight(self.view.frame) - kbSize.height;
    
    CGFloat diff = loginViewMaxY - keyboardMinY - self.loginViewTop.constant;
    
    [UIView animateWithDuration:0.2f animations:^{
        self.loginViewTop.constant = diff > 0 ? -130 : 0.f;
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)dismissKeyboard:(id)sender {
    [self.view endEditing:YES];
    
    [UIView animateWithDuration:0.2f animations:^{
        self.loginViewTop.constant = 0;
        [self.view layoutIfNeeded];
    }];
}

@end
