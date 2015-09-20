//
//  DialogTransitionDelegate.m
//  Search
//
//  Created by Meiwin Fu on 20/9/15.
//  Copyright © 2015 BlockThirty. All rights reserved.
//

#import "NgDialogTransitionDelegate.h"
#import "NgDialogAnimationController.h"
#import "NgDialogPresentationController.h"

@implementation NgDialogTransitionDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
  
  NgDialogAnimationController * animationController = [[NgDialogAnimationController alloc] init];
  return animationController;
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
  
  NgDialogAnimationController * animationController = [[NgDialogAnimationController alloc] init];
  animationController.dismissing = YES;
  return animationController;
}
- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
  
  NgDialogPresentationController * presentationController =
  [[NgDialogPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
  return presentationController;
}

@end
