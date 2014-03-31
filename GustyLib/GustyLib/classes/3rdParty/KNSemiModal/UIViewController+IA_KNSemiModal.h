//
//  KNSemiModalViewController.h
//  KNSemiModalViewController
//
//  Created by Kent Nguyen on 2/5/12.
//  Copyright (c) 2012 Kent Nguyen. All rights reserved.
//

#define kSemiModalAnimationDuration   0.3

@interface UIViewController (IA_KNSemiModal)

@property (nonatomic, readonly) BOOL p_presentingSemiModal;
@property (nonatomic, readonly) BOOL p_presentedAsSemiModal;

-(void)presentSemiModalViewController:(UIViewController*)vc;
-(void)presentSemiModalView:(UIView*)vc;
-(void)dismissSemiModalView;
//-(void)handleWillAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;

- (void)dismissSemiModalViewWithChangesMade:(BOOL)a_changesMade data:(id)a_data;
@end
