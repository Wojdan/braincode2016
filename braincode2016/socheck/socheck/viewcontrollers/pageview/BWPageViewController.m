//
//  BWPageViewController.m
//  socheck
//
//  Created by Bartłomiej Wojdan on 19.03.2016.
//  Copyright © 2016 Bartłomiej Wojdan. All rights reserved.
//

#import "BWPageViewController.h"
#import "UIColor+BWSocheckColors.h"

@interface BWPageViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *containerScrollView;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (strong, nonatomic) NSArray *viewControllers;
@property (weak, nonatomic) IBOutlet UIView *pageBar;

@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *midButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftButtonLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *midButtonLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightButtonLeading;

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *midLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

@end

@implementation BWPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.containerScrollView.delegate = self;
    
    [self setupAppearance];
    [self setupControllers];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)setupAppearance {
    self.view.backgroundColor = [UIColor lightBackgroundColor];
    
    self.containerScrollView.pagingEnabled = YES;
    self.containerScrollView.bounces = NO;
    
    CGFloat lineWidth = 1.f / [UIScreen mainScreen].scale;
    CAShapeLayer *pageBarSeparatorLayer = [CAShapeLayer new];
    pageBarSeparatorLayer.frame = CGRectMake(0, CGRectGetMaxY(self.pageBar.bounds)-lineWidth, CGRectGetWidth(self.pageBar.frame), lineWidth);
    pageBarSeparatorLayer.backgroundColor = [UIColor accentColor].CGColor;
    [self.pageBar.layer addSublayer:pageBarSeparatorLayer];
    self.pageBar.backgroundColor = [UIColor lightBackgroundColor];
    
    
    self.leftButton.tintColor = [UIColor primaryColor];
    self.midButton.tintColor = [UIColor primaryColor];
    self.rightButton.tintColor = [UIColor primaryColor];
    
    self.leftButton.backgroundColor = [UIColor lightBackgroundColor];
    self.midButton.backgroundColor = [UIColor lightBackgroundColor];
    self.rightButton.backgroundColor = [UIColor lightBackgroundColor];
    
    self.leftLabel.text = @"BROWSE SOCHECKS";
    self.midLabel.text = @"YOUR SOCHECKS";
    self.rightLabel.text = @"CREATE NEW SOCHECK";
    
    self.leftLabel.textColor = [UIColor primaryTextColor];
    self.midLabel.textColor = [UIColor primaryTextColor];
    self.rightLabel.textColor = [UIColor primaryTextColor];
    
    self.leftLabel.alpha = 0;
    self.midLabel.alpha = 0;
    self.rightLabel.alpha = 0;
}

- (void)setupControllers {

    [self.view layoutIfNeeded];
    
    if (!self.viewControllers.count) {
        return;
    }
    
    for (UIViewController *viewController in self.viewControllers) {
        NSInteger index = [self.viewControllers indexOfObject:viewController];
        [self addChildViewController:viewController];
        [self.containerView addSubview:viewController.view];
        viewController.view.translatesAutoresizingMaskIntoConstraints = NO;
        [viewController didMoveToParentViewController:self];
        
        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:viewController.view
                                                               attribute:NSLayoutAttributeTop
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.containerView
                                                               attribute:NSLayoutAttributeTop
                                                              multiplier:1
                                                                constant:0];
        NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:viewController.view
                                                               attribute:NSLayoutAttributeHeight
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.containerScrollView
                                                               attribute:NSLayoutAttributeHeight
                                                              multiplier:1
                                                                constant:0];
        NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:viewController.view
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.containerScrollView
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:1
                                                                  constant:0];
        NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:viewController.view
                                                                 attribute:NSLayoutAttributeLeading
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.containerView
                                                                 attribute:NSLayoutAttributeLeading
                                                                multiplier:1
                                                                  constant:index * CGRectGetWidth(self.view.frame)];
        [NSLayoutConstraint activateConstraints:@[top, height, width, leading]];
    }
    
    
    UIViewController *lastController = [self.viewControllers lastObject];
    NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:self.containerView
                                                                attribute:NSLayoutAttributeTrailing
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:lastController.view
                                                                attribute:NSLayoutAttributeTrailing
                                                               multiplier:1
                                                                 constant:0];
    trailing.active = YES;
    
    
    CGFloat margin = 8.f;
    self.leftButtonLeading.constant = margin + CGRectGetWidth(self.leftButton.frame) * 0.5;
    self.midButtonLeading.constant = CGRectGetMidX(self.pageBar.frame);
    self.rightButtonLeading.constant = CGRectGetMaxX(self.pageBar.frame) - margin - CGRectGetWidth(self.rightButton.frame) * 0.5;
    
    [self.view layoutIfNeeded];
    
    [self scrollToViewController:[self.viewControllers objectAtIndex:1] animated:NO];
}

- (void)scrollToViewController:(UIViewController*)viewController animated:(BOOL)animated {
    [self.containerScrollView scrollRectToVisible:viewController.view.frame animated:animated];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat scrollWidth = scrollView.bounds.size.width;
    
    CGFloat rightButtonWidth = CGRectGetWidth(self.rightButton.frame) * 0.5;
    CGFloat rightButtonLeading = offsetX < scrollWidth ? (3*scrollWidth - offsetX) * 0.5 - (8.f + rightButtonWidth) : MIN(CGRectGetMaxX(self.pageBar.frame) - (8.f + rightButtonWidth), (3*scrollWidth - offsetX) * 0.5);
    self.rightButtonLeading.constant = rightButtonLeading;
    
    CGFloat midButtonWidth = CGRectGetWidth(self.midButton.frame) * 0.5;
    CGFloat midButtonLeading = MIN(MAX(8.f + midButtonWidth, (2*scrollWidth - offsetX) * 0.5), CGRectGetMaxX(self.pageBar.frame) - (8.f + midButtonWidth));
    self.midButtonLeading.constant = midButtonLeading;
    
    CGFloat leftButtonWidth = CGRectGetWidth(self.leftButton.frame) * 0.5;
    CGFloat leftButtonLeading = offsetX > scrollWidth ? (scrollWidth - offsetX) * 0.5 + 8.f + leftButtonWidth : MAX(8 + leftButtonWidth, (scrollWidth - offsetX) * 0.5);
    self.leftButtonLeading.constant = leftButtonLeading;
    
    CGFloat leftAlpha = 1.f - MIN(1.f, (offsetX / scrollWidth));
    self.leftButton.alpha = 1.f - leftAlpha;
    self.leftLabel.alpha = leftAlpha;
    
    CGFloat midAlpha = (offsetX / scrollWidth) <= 1 ? (offsetX / scrollWidth) : 1.f-ABS((offsetX / scrollWidth)-1.f);
    self.midButton.alpha = 1.f - midAlpha;
    self.midLabel.alpha = midAlpha;
    
    CGFloat rightAlpha = 1.f - MIN(1.f, ABS((offsetX - 2*scrollWidth) / scrollWidth));
    self.rightButton.alpha = 1.f - rightAlpha;
    self.rightLabel.alpha = rightAlpha;
    
    NSLog(@"%f", midAlpha);

    
    [self.view layoutIfNeeded];
}


- (NSArray *)viewControllers {
    
    if (!_viewControllers) {
        UIViewController *mockController1 = [UIViewController new];
        UIViewController *mockController2 = [UIViewController new];
        UIViewController *mockController3 = [UIViewController new];
        _viewControllers = @[mockController1, mockController2, mockController3];
    }
    
    return _viewControllers;
}

- (IBAction)leftButtonPressed:(id)sender {
    [self scrollToViewController:[self.viewControllers objectAtIndex:0] animated:YES];
}

- (IBAction)midButtonPressed:(id)sender {
    [self scrollToViewController:[self.viewControllers objectAtIndex:1] animated:YES];
}

- (IBAction)rightButtonPressed:(id)sender {
    [self scrollToViewController:[self.viewControllers objectAtIndex:2] animated:YES];
}

@end
