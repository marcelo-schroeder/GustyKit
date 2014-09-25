//
// Created by Marcelo Schroeder on 19/09/2014.
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

#import "GustyLibHelp.h"

@interface IFAHelpContentViewController ()
@property (nonatomic, weak) UIViewController *IFA_targetViewController;
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) IFAHtmlDocument *IFA_htmlDocument;
@property(nonatomic, strong) UIBarButtonItem *closeBarButtonItem;
@end

@implementation IFAHelpContentViewController {

}

#pragma Overrides

- (instancetype)initWithTargetViewController:(UIViewController *)a_targetViewController {
    self = [super init];
    if (self) {
        self.IFA_targetViewController = a_targetViewController;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.IFA_targetViewController.title;
    self.closeBarButtonItem = [[IFAHelpManager sharedInstance] newHelpBarButtonItemForViewController:self.IFA_targetViewController selected:YES];
    [self ifa_addRightBarButtonItem:self.closeBarButtonItem];
    [self.view addSubview:self.webView];
    [self.webView ifa_addLayoutConstraintsToFillSuperview];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSString *htmlBody = [[IFAHelpManager sharedInstance] helpForViewController:self.IFA_targetViewController];
    NSString  *l_htmlString = [self.IFA_htmlDocument htmlStringWithBody:htmlBody];
    [self.webView loadHTMLString:l_htmlString baseURL:nil];
}

#pragma mark - UIWebViewDelegate protocol

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    __weak __typeof(self) l_weakSelf = self;
    void (^animations)() = ^{
        l_weakSelf.webView.alpha = 1;
    };
    void (^completion)(BOOL) = ^(BOOL finished) {
        [l_weakSelf.webView.scrollView flashScrollIndicators];
    };
    [UIView animateWithDuration:0.3 animations:animations
                     completion:completion];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self webViewDidFinishLoad:webView];
}

#pragma mark - Private

- (UIWebView *)webView {
    if (!_webView) {

        _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        _webView.delegate = self;
        _webView.opaque = NO;
        _webView.alpha = 0;
        _webView.backgroundColor = [UIColor clearColor];

        // Configure scroll view
        UIScrollView *scrollView = _webView.scrollView;
        scrollView.contentInset = UIEdgeInsetsMake(8, 0, 8, 0);
        scrollView.alwaysBounceVertical = NO;
        scrollView.scrollIndicatorInsets = scrollView.contentInset;
        scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;

    }
    return _webView;
}

- (IFAHtmlDocument *)IFA_htmlDocument {
    if (!_IFA_htmlDocument) {
        NSString *l_htmlStyleResourceName = [[IFAUtils infoPList] valueForKey:@"IFAHelpViewControllerWebViewCss"];
        if (!l_htmlStyleResourceName) {
            l_htmlStyleResourceName = @"IFAHelpViewControllerWebView.css";
        }
        _IFA_htmlDocument = [[IFAHtmlDocument alloc] initWithHtmlStyleResourceName:l_htmlStyleResourceName];
        _IFA_htmlDocument.htmlMetaString = @"";
        UIFont *bodyFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        UIFont *SubHeadlineFont = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        _IFA_htmlDocument.htmlStyleStringFormatArguments = @[
                bodyFont.familyName,
                @(bodyFont.pointSize).stringValue,
                @(SubHeadlineFont.pointSize).stringValue,
        ];
    }
    return _IFA_htmlDocument;
}

@end