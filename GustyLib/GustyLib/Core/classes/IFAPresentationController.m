//
// Created by Marcelo Schroeder on 24/09/2014.
// Copyright (c) 2014 InfoAccent Pty Ltd. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "GustyLibCore.h"

@interface IFAPresentationController ()
@property (nonatomic, strong) UIImageView *IFA_overlayImageView;
@end

@implementation IFAPresentationController {

}

#pragma mark - Overrides

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController
                       presentingViewController:(UIViewController *)presentingViewController {
    self = [super initWithPresentedViewController:presentedViewController
                         presentingViewController:presentingViewController];
    if (self) {
        __weak __typeof(self) l_weakSelf = self;
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidChangeStatusBarFrameNotification object:nil
                                                           queue:nil
                                                      usingBlock:^(NSNotification *note) {
                                                          // This will cause containerViewWillLayoutSubviews to be called - there is further info there as to why this is being done.
                                                          [l_weakSelf.containerView setNeedsLayout];
                                                          [l_weakSelf.containerView layoutIfNeeded];
                                                      }];
    }
   return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarFrameNotification
                                                  object:nil];
}

- (void)presentationTransitionWillBegin {

    UIImage *overlayImage = [[self.presentingViewController.view ifa_snapshotImage] ifa_imageWithBlurEffect:IFABlurEffectDark radius:3];
    self.IFA_overlayImageView.image = overlayImage;
    self.IFA_overlayImageView.alpha = 0;
    [self.containerView addSubview:self.IFA_overlayImageView];
    [self.IFA_overlayImageView ifa_addLayoutConstraintsToFillSuperview];

    [[self.presentedViewController transitionCoordinator] animateAlongsideTransition:^(id <UIViewControllerTransitionCoordinatorContext> context) {
        self.IFA_overlayImageView.alpha = 1;
    } completion:nil];

}

- (void)dismissalTransitionWillBegin {
    [[self.presentedViewController transitionCoordinator] animateAlongsideTransition:^(id <UIViewControllerTransitionCoordinatorContext> context) {
        self.IFA_overlayImageView.alpha = 0;
    } completion:nil];
}

- (void)dismissalTransitionDidEnd:(BOOL)completed {
    [self.IFA_overlayImageView removeFromSuperview];
}

- (void)containerViewWillLayoutSubviews {
    // I'm not sure if this is a UIKit bug but the container frame gets out of whack when the status bar frame changes size (i.e. double height),
    //  so I need to manually fix it here.
    self.containerView.frame = self.presentingViewController.view.frame;
}

#pragma mark - Private

- (UIImageView *)IFA_overlayImageView {
    if (!_IFA_overlayImageView) {
        _IFA_overlayImageView = [UIImageView new];
    }
    return _IFA_overlayImageView;
}

@end