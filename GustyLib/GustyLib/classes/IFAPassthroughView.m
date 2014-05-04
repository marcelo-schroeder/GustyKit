//
// Created by Marcelo Schroeder on 29/01/2014.
// Copyright (c) 2014 InfoAccent Pty Limited. All rights reserved.
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

#import "IFAPassthroughView.h"
#import "NSObject+IFACategory.h"

@interface IFAPassthroughView ()

@property(nonatomic) BOOL ifa_excludeMyself;
@end

@implementation IFAPassthroughView {

}

#pragma mark - Private

- (UIView *)hitTestChildrenOfView:(UIView *)a_parentView point:(CGPoint)a_point withEvent:(UIEvent *)a_event {
    self.ifa_excludeMyself = YES;
    UIView *l_view = nil;
    for (UIView *l_subView in a_parentView.subviews) {
        CGPoint l_point = [l_subView convertPoint:a_point fromView:self];
        l_view = [l_subView hitTest:l_point withEvent:a_event];
        if (l_view) {
            break;
        }
    }
    self.ifa_excludeMyself = NO;
    return l_view;
}

#pragma mark - Overrides

- (void)IFA_commonInit {
    [super IFA_commonInit];
    self.backgroundColor = [UIColor clearColor];
}

- (id)init {
    self = [super init];
    if (self) {
        [self IFA_commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self IFA_commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self IFA_commonInit];
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.ifa_excludeMyself) {
        return nil;
    }
    UIView *l_topLevelView = self.window;
    UIView *l_view = [self hitTestChildrenOfView:l_topLevelView point:point withEvent:event];
    if (self.shouldDismissKeyboardOnNonTextInputInteractions) {
        BOOL l_viewIsATextInput = [l_view conformsToProtocol:@protocol(UITextInput)];
        BOOL l_viewIsAButtonInsideATextInput = [l_view isKindOfClass:[UIButton class]] && [l_view.superview conformsToProtocol:@protocol(UITextInput)]; //e.g. the clear button in a text field
        if (!l_viewIsATextInput && !l_viewIsAButtonInsideATextInput) {
            [self.window endEditing:YES];
        }
    }
    if (self.hitTestBlock) {
        self.hitTestBlock(point, event, l_view);
    }
    return l_view;
}

@end