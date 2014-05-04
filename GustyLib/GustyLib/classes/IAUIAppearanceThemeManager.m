//
//  IAUIAppearanceThemeManager.m
//  Gusty
//
//  Created by Marcelo Schroeder on 1/08/12.
//  Copyright (c) 2012 InfoAccent Pty Limited. All rights reserved.
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

#import "IACommon.h"

@interface IAUIAppearanceThemeManager()

@property (nonatomic, strong) id<IAUIAppearanceTheme> loadedAppearanceTheme;
@property (nonatomic, strong) IAUIColorScheme *loadedColorScheme;

@property(nonatomic, strong) NSMutableSet *ifa_alreadyLoadedThemeNames;
@end

@implementation IAUIAppearanceThemeManager

#pragma mark - Private

- (void)ifa_setThemeAppearanceIfRequired {
    NSString *l_themeName = [self.loadedAppearanceTheme themeName];
    if (![self.ifa_alreadyLoadedThemeNames containsObject:l_themeName]) {
//        NSLog(@"Setting appearance theme: %@", l_themeName);
        [self.loadedAppearanceTheme setAppearance];
        [self.ifa_alreadyLoadedThemeNames addObject:l_themeName];
    }
}

- (void)ifa_transitionViewsWithAnimationDuration:(NSTimeInterval)a_animationDuration
                                animationOptions:(UIViewAnimationOptions)a_animationOptions
                                 completionBlock:(void (^)(BOOL finished))a_completionBlock {

    UIWindow *l_window = [self ifa_window];
    [UIView
            transitionWithView:l_window
                      duration:a_animationDuration
                       options:a_animationOptions
                    animations:^(void) {
                        BOOL oldState = [UIView areAnimationsEnabled];
                        [UIView setAnimationsEnabled:NO];
                        l_window.rootViewController = [[self.loadedAppearanceTheme storyboard] instantiateInitialViewController];
                        [UIView setAnimationsEnabled:oldState];
                    }
                    completion:^(BOOL finished) {
                        if (a_completionBlock) {
                            a_completionBlock(finished);
                        }
                    }];

}

- (UIWindow *)ifa_window {
    return [UIApplication sharedApplication].delegate.window;
}

#pragma mark - Overrides

- (id)init{
    self = [super init];
    if (self) {
        self.ifa_alreadyLoadedThemeNames = [NSMutableSet new];
    }
    return self;
}

#pragma mark - Public

- (void)reloadUiWithNoTransitionAnimation {
    [self applyAppearanceTheme];
    UIWindow *l_window = [self ifa_window];
    UIViewController *l_newViewController = [[self.loadedAppearanceTheme storyboard] instantiateInitialViewController];
    l_window.rootViewController = l_newViewController;
}

-(void)reloadUiWithAnimationOptions:(UIViewAnimationOptions)a_animationOptions{
    [self reloadUiWithAnimationDuration:IA_UI_ANIMATION_DURATION animationOptions:a_animationOptions
                        completionBlock:nil];
}

- (void)reloadUiWithAnimationDuration:(NSTimeInterval)a_animationDuration
                     animationOptions:(UIViewAnimationOptions)a_animationOptions
                      completionBlock:(void (^)(BOOL finished))a_completionBlock {
    [self applyAppearanceTheme];
    [self ifa_transitionViewsWithAnimationDuration:a_animationDuration animationOptions:a_animationOptions
                                   completionBlock:a_completionBlock];
}

/*
-(void)reloadUiWithTransitionAnimation:(SMUiReloadTransitionAnimation)a_transitionAnimation{
    [self m_reloadUiWithTransitionAnimation:a_transitionAnimation completionBlock:nil];
}
*/

/*
-(void)reloadUiWithTransitionAnimation:(SMUiReloadTransitionAnimation)a_transitionAnimation completionBlock:(void (^)(BOOL finished))a_completionBlock{

    [self applyAppearanceTheme];

    // Configuration transition animation
    BOOL l_isPush = a_transitionAnimation == SM_UI_RELOAD_TRANSITION_ANIMATION_PUSH;
    CATransition *l_transition = [CATransition animation];
    [l_transition setDuration:0.3];
    [l_transition setType:kCATransitionPush];
    NSString *l_subType = nil;
    UIInterfaceOrientation l_statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
    switch (l_statusBarOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
            l_subType = l_isPush ? kCATransitionFromBottom : kCATransitionFromTop;
            break;
        case UIInterfaceOrientationLandscapeRight:
            l_subType = l_isPush ? kCATransitionFromTop : kCATransitionFromBottom;
            break;
        case UIInterfaceOrientationPortrait:
            l_subType = l_isPush ? kCATransitionFromRight : kCATransitionFromLeft;
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            l_subType = l_isPush ? kCATransitionFromLeft : kCATransitionFromRight;
            break;
        default:
            NSAssert(NO, @"Unexpected l_statusBarOrientation: %u", l_statusBarOrientation);
            break;
    }
    [l_transition setSubtype:l_subType];
    [[[UIApplication sharedApplication].keyWindow layer] addAnimation:l_transition forKey:kCATransition];

    // Transition views
    [self m_transitionViewsWithAnimationDuration:0 animationOptions:UIViewAnimationOptionTransitionNone completionBlock:a_completionBlock];

}
*/

-(id<IAUIAppearanceTheme>)activeAppearanceTheme {
    id<IAUIAppearanceTheme> l_appearanceTheme = self.loadedAppearanceTheme;
    if (!l_appearanceTheme) {
        l_appearanceTheme = [[IAUIApplicationDelegate sharedInstance] appearanceTheme];
    }
    return l_appearanceTheme;
}

+ (IAUIAppearanceThemeManager*)sharedInstance {
    static dispatch_once_t c_dispatchOncePredicate;
    static IAUIAppearanceThemeManager *c_instance = nil;
    dispatch_once(&c_dispatchOncePredicate, ^{
        c_instance = [self new];
    });
    return c_instance;
}

+(NSBundle*)bundleForThemeNamed:(NSString*)a_themeName{
    if ([a_themeName isEqualToString:@""]) {
        return nil;
    }else{
        NSString *l_bundlePath = [[NSBundle mainBundle] pathForResource:a_themeName ofType:@"bundle"];
        NSBundle *l_bundle = [NSBundle bundleWithPath:l_bundlePath];
        //    NSLog(@"l_bundle: %@", [l_bundle description]);
        return l_bundle;
    }
}

-(void)applyAppearanceTheme {

    // Obtain and save the appearance theme & color scheme
    self.loadedAppearanceTheme = [[IAUIApplicationDelegate sharedInstance] appearanceTheme];
    self.loadedColorScheme = [[IAUIApplicationDelegate sharedInstance] colorScheme];

    // Notify theme we're about to reload the UI
    if ([self.loadedAppearanceTheme respondsToSelector:@selector(willReloadUi)]) {
        [self.loadedAppearanceTheme willReloadUi];
    }

    // Dismiss activity view controller popover
    [[IAUIApplicationDelegate sharedInstance].popoverControllerPresenter IFA_dismissModalViewControllerWithChangesMade:NO
                                                                                                                  data:nil ];

    // Dismiss popover menu if using the custom split view controller
    [IAUIUtils dismissSplitViewControllerPopover];

    [self ifa_setThemeAppearanceIfRequired];

}

@end
