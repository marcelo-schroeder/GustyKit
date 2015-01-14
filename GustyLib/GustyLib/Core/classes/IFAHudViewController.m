//
// Created by Marcelo Schroeder on 14/01/15.
// Copyright (c) 2015 InfoAccent Pty Ltd. All rights reserved.
//

#import "GustyLibCore.h"

//wip: handle rotation now?
//wip: does the dynamic font stuff work?
@interface IFAHudViewController ()
@property(nonatomic, strong) id <UIViewControllerTransitioningDelegate> IFA_viewControllerTransitioningDelegate;
@property(nonatomic, strong) UIView *IFA_contentView;
@property (nonatomic, strong) UILabel *IFA_textLabel;
@property (nonatomic, strong) UILabel *IFA_detailTextLabel;
@property(nonatomic, strong) NSMutableArray *IFA_contentHorizontalLayoutConstraints;
@property(nonatomic, strong) NSArray *IFA_contentVerticalLayoutConstraints;
@property(nonatomic, strong) NSArray *IFA_contentViewSizeConstraints;
@property(nonatomic, strong) UIActivityIndicatorView *IFA_activityIndicatorView;
@property(nonatomic, strong) UIProgressView *IFA_progressView;
@property (nonatomic, strong) UITapGestureRecognizer *IFA_tapGestureRecognizer;
@end

@implementation IFAHudViewController {

}

#pragma mark - Public

- (void)setText:(NSString *)text {
    _text = text;
    self.IFA_textLabel.text = _text;
    [self.IFA_textLabel sizeToFit];
    [self IFA_updateContentViewLayoutConstraints];
}

- (void)setDetailText:(NSString *)detailText {
    _detailText = detailText;
    self.IFA_detailTextLabel.text = _detailText;
    [self.IFA_detailTextLabel sizeToFit];
    [self IFA_updateContentViewLayoutConstraints];
}

- (void)setTapActionBlock:(void (^)())tapActionBlock {
    _tapActionBlock = tapActionBlock;
}

#pragma mark - Overrides

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.transitioningDelegate = self.IFA_viewControllerTransitioningDelegate;
        [self.IFA_contentView addSubview:self.IFA_activityIndicatorView];
        [self.IFA_contentView addSubview:self.IFA_progressView];
        [self.IFA_contentView addSubview:self.IFA_textLabel];
        [self.IFA_contentView addSubview:self.IFA_detailTextLabel];
        [self.view addSubview:self.IFA_contentView];
        [self.IFA_contentView ifa_addLayoutConstraintsToCenterInSuperview];
        [self.IFA_contentView addGestureRecognizer:self.IFA_tapGestureRecognizer];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self IFA_updateContentViewLayoutConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.IFA_activityIndicatorView startAnimating];
}

#pragma mark - Private

- (IFAViewControllerTransitioningDelegate *)IFA_viewControllerTransitioningDelegate {
    if (!_IFA_viewControllerTransitioningDelegate) {
        _IFA_viewControllerTransitioningDelegate = [IFADimmedFadingOverlayViewControllerTransitioningDelegate new];
    }
    return _IFA_viewControllerTransitioningDelegate;
}

- (UIView *)IFA_contentView {
    if (!_IFA_contentView) {
        _IFA_contentView = [UIView new];
        _IFA_contentView.translatesAutoresizingMaskIntoConstraints = NO;
        _IFA_contentView.backgroundColor = [UIColor whiteColor];
        CALayer *layer = _IFA_contentView.layer;
        layer.cornerRadius = 9.0;
        layer.masksToBounds = YES;
    }
    return _IFA_contentView;
}

- (UILabel *)IFA_textLabel {
    if (!_IFA_textLabel) {
        _IFA_textLabel = [UILabel new];
        _IFA_textLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _IFA_textLabel.textAlignment = NSTextAlignmentCenter;
        _IFA_textLabel.numberOfLines = 0;
        _IFA_textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];   //wip: move to theme?
    }
    return _IFA_textLabel;
}

- (UILabel *)IFA_detailTextLabel {
    if (!_IFA_detailTextLabel) {
        _IFA_detailTextLabel = [UILabel new];
        _IFA_detailTextLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _IFA_detailTextLabel.textAlignment = NSTextAlignmentCenter;
        _IFA_detailTextLabel.numberOfLines = 0;
        _IFA_detailTextLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];   //wip: move to theme?
    }
    return _IFA_detailTextLabel;
}

- (UIActivityIndicatorView *)IFA_activityIndicatorView {
    if (!_IFA_activityIndicatorView) {
        _IFA_activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _IFA_activityIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
        _IFA_activityIndicatorView.color = [UIColor blackColor];
    }
    return _IFA_activityIndicatorView;
}

- (UIProgressView *)IFA_progressView {
    if (!_IFA_progressView) {
        _IFA_progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _IFA_progressView.translatesAutoresizingMaskIntoConstraints = NO;
        _IFA_progressView.progress = 0.25;  //wip: hardcoded
        _IFA_progressView.progressTintColor = [UIColor blackColor];   //wip: move to theme?
    }
    return _IFA_progressView;
}

- (UITapGestureRecognizer *)IFA_tapGestureRecognizer {
    if (!_IFA_tapGestureRecognizer) {
        _IFA_tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(IFA_onTapGestureRecognizerAction)];
    }
    return _IFA_tapGestureRecognizer;
}

- (void)IFA_onTapGestureRecognizerAction {
    if (self.tapActionBlock) {
        self.tapActionBlock();
    }
}

- (NSMutableArray *)IFA_contentHorizontalLayoutConstraints {
    if (!_IFA_contentHorizontalLayoutConstraints) {
        _IFA_contentHorizontalLayoutConstraints = [@[] mutableCopy];
    }
    return _IFA_contentHorizontalLayoutConstraints;
}

- (void)IFA_updateContentViewLayoutConstraints {

    UIView *contentView = self.IFA_contentView;
    UIActivityIndicatorView *activityIndicatorView = self.IFA_activityIndicatorView;
    UIProgressView *progressView = self.IFA_progressView;
    UILabel *textLabel = self.IFA_textLabel;
    UILabel *detailTextLabel = self.IFA_detailTextLabel;
    NSDictionary *views = NSDictionaryOfVariableBindings(activityIndicatorView, progressView, textLabel, detailTextLabel);

    // Content horizontal layout constraints
    [contentView removeConstraints:self.IFA_contentHorizontalLayoutConstraints];
    [self.IFA_contentHorizontalLayoutConstraints removeAllObjects];
    [self.IFA_contentHorizontalLayoutConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=8)-[activityIndicatorView]-(>=8)-|"
                                                                                                             options:NSLayoutFormatAlignAllCenterY
                                                                                                             metrics:nil
                                                                                                               views:views]];
    [self.IFA_contentHorizontalLayoutConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[progressView]-|"
                                                                                                             options:NSLayoutFormatAlignAllCenterY
                                                                                                             metrics:nil
                                                                                                               views:views]];
    [self.IFA_contentHorizontalLayoutConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=8)-[textLabel]-(>=8)-|"
                                                                                                             options:NSLayoutFormatAlignAllCenterY
                                                                                                             metrics:nil
                                                                                                               views:views]];
    [self.IFA_contentHorizontalLayoutConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=8)-[detailTextLabel]-(>=8)-|"
                                                                                                             options:NSLayoutFormatAlignAllCenterY
                                                                                                             metrics:nil
                                                                                                               views:views]];
    [contentView addConstraints:self.IFA_contentHorizontalLayoutConstraints];

    // Content vertical layout constraints
    [contentView removeConstraints:self.IFA_contentVerticalLayoutConstraints];
    NSMutableString *contentVerticalLayoutConstraintsVisualFormat = [@"V:|" mutableCopy];
    [contentVerticalLayoutConstraintsVisualFormat appendString:@"-[activityIndicatorView]"];
    [contentVerticalLayoutConstraintsVisualFormat appendString:@"-[progressView]"];
    [contentVerticalLayoutConstraintsVisualFormat appendString:@"-[textLabel]"];
    [contentVerticalLayoutConstraintsVisualFormat appendString:@"-[detailTextLabel]"];
    [contentVerticalLayoutConstraintsVisualFormat appendString:@"-|"];
    self.IFA_contentVerticalLayoutConstraints = [NSLayoutConstraint constraintsWithVisualFormat:contentVerticalLayoutConstraintsVisualFormat
                                                                        options:NSLayoutFormatAlignAllCenterX
                                                                        metrics:nil
                                                                          views:views];
    [contentView addConstraints:self.IFA_contentVerticalLayoutConstraints];

    // Content container view size constraints
    [contentView removeConstraints:self.IFA_contentViewSizeConstraints];
    CGFloat contentViewMaxWidth = self.view.bounds.size.width - 20 - 20;   //wip: hardcoded
    NSLayoutConstraint *contentViewMaxWidthConstraint = [NSLayoutConstraint constraintWithItem:contentView
                                                                                  attribute:NSLayoutAttributeWidth
                                                                                  relatedBy:NSLayoutRelationLessThanOrEqual
                                                                                     toItem:nil
                                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                                 multiplier:1
                                                                                   constant:contentViewMaxWidth];
    [contentView addConstraint:contentViewMaxWidthConstraint];
    CGSize newContentViewSize = [contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    [contentView removeConstraint:contentViewMaxWidthConstraint];
    self.IFA_contentViewSizeConstraints = [contentView ifa_addLayoutConstraintsForSize:newContentViewSize];

}

@end