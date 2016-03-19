//
//  BWLoginViewController.m
//  socheck
//
//  Created by Bartłomiej Wojdan on 18.03.2016.
//  Copyright © 2016 Bartłomiej Wojdan. All rights reserved.
//

#import "BWLoginViewController.h"
#import "UIColor+BWSocheckColors.h"
#import "BWPageViewController.h"
#import "BWAPIClient.h"
#import "BWRegisterViewController.h"
#import "AppDelegate.h"

NSString * const kLoginControllerAutofillNotification = @"kLoginControllerAutofillNotification";

@interface BWLoginViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *loginTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginViewTop;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoBottom;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@end

@implementation BWLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAutofillNotification:) name:kLoginControllerAutofillNotification object:nil];
    [self setup];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardFrameChangeNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setup {
    
    [self.view layoutIfNeeded];
    
    self.view.backgroundColor = [UIColor lightBackgroundColor];
    
    self.logoBottom.constant = CGRectGetHeight([UIScreen mainScreen].bounds) * 0.25f - CGRectGetHeight(self.logoImageView.frame) * 0.5f;
    

    CGFloat lineWidth = .5f;
    
    CAShapeLayer *loginUnderlineLayer = [CAShapeLayer new];
    loginUnderlineLayer.frame = CGRectMake(0, CGRectGetMaxY(self.loginTextField.bounds)-lineWidth, CGRectGetWidth(self.loginTextField.frame), lineWidth);
    loginUnderlineLayer.backgroundColor = [UIColor accentColor].CGColor;
    [self.loginTextField.layer addSublayer:loginUnderlineLayer];
    self.loginTextField.backgroundColor = [UIColor clearColor];
    
    CAShapeLayer *passUnderlineLayer = [CAShapeLayer new];
    passUnderlineLayer.frame = CGRectMake(0, CGRectGetMaxY(self.loginTextField.bounds)-lineWidth, CGRectGetWidth(self.loginTextField.frame), lineWidth);
    passUnderlineLayer.backgroundColor = [UIColor accentColor].CGColor;
    [self.passwordTextField.layer addSublayer:passUnderlineLayer];
    self.passwordTextField.backgroundColor = [UIColor clearColor];
    self.passwordTextField.secureTextEntry = YES;
    
    loginUnderlineLayer.rasterizationScale = [UIScreen mainScreen].scale;
    passUnderlineLayer.rasterizationScale = [UIScreen mainScreen].scale;
    
    loginUnderlineLayer.shouldRasterize = YES;
    passUnderlineLayer.shouldRasterize = YES;
    
    self.loginTextField.textColor = [UIColor primaryTextColor];
    self.passwordTextField.textColor = [UIColor primaryTextColor];
    
    self.loginButton.layer.borderColor = [UIColor primaryColor].CGColor;
    self.loginButton.layer.borderWidth = 1.f;
    self.loginButton.layer.cornerRadius = 3.f;
    [self.loginButton setTitleColor:[UIColor primaryColor] forState:UIControlStateNormal];
    
    
    [self.registerButton setTitleColor:[UIColor secondaryTextColor] forState:UIControlStateNormal];
}

#pragma mark - Actions

- (void)handleAutofillNotification:(NSNotification*)note {
    
    self.loginTextField.text = [note.userInfo objectForKey:@"login"];
    self.passwordTextField.text = [note.userInfo objectForKey:@"password"];
    
}

- (void)handleKeyboardFrameChangeNotification:(NSNotification*)notification {
    
    NSDictionary* info = [notification userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGSize kbSize = kbRect.size;
    
    CGFloat loginViewMaxY = CGRectGetMaxY(self.passwordTextField.superview.frame);
    CGFloat keyboardMinY = CGRectGetHeight(self.view.frame) - kbSize.height;
    
    CGFloat diff = loginViewMaxY - keyboardMinY - self.loginViewTop.constant;
    
    [UIView animateWithDuration:0.2f animations:^{
        self.loginViewTop.constant = diff > 0 ? -diff : 0.f;
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)registerButtonPressed:(id)sender {
    
    id registerViewController = [[UIStoryboard storyboardWithName:NSStringFromClass([BWRegisterViewController class])
                                                           bundle:nil] instantiateInitialViewController];
    [self presentViewController:registerViewController animated:YES completion:nil];
    
}

- (IBAction)signInButtonPressed:(id)sender {
    
    if (!self.loginTextField.text.length ||
        !self.passwordTextField.text.length) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Invalid credentials" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil] show];
        return;
    }
    
    [BWAPIClient authenticateUserWithUsername:self.loginTextField.text password:self.passwordTextField.text success:^{
        BWPageViewController *pageViewController = [[UIStoryboard storyboardWithName:NSStringFromClass([BWPageViewController class])
                                                                              bundle:nil] instantiateInitialViewController];
        [AppDelegate setRootViewController:pageViewController animated:YES];
    } failure:^(id responseObject, NSError *error) {
        
    }];
    
}

- (IBAction)dismissKeyboard:(id)sender {
    [self.view endEditing:YES];
    
    [UIView animateWithDuration:0.2f animations:^{
        self.loginViewTop.constant = 0;
        [self.view layoutIfNeeded];
    }];
}

@end
