//
//  DialogAnimationController.m
//  Search
//
//  Created by Meiwin Fu on 20/9/15.
//  Copyright © 2015 BlockThirty. All rights reserved.
//

#import "NgDialogAnimationController.h"

@implementation NgDialogAnimationController

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
  return self.dismissing ? .7 : .3f;
}
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  
  UIView * containerView = [transitionContext containerView];

  if (!self.dismissing) {
    
    UIView * toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIViewController * toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGRect finalFrame =
    [transitionContext finalFrameForViewController:toViewController];
    
    CGRect initialFrame = finalFrame;
    initialFrame.origin.y = containerView.bounds.size.height + 20;
    toView.frame = initialFrame;
    [containerView addSubview:toView];

    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:1
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                       
                       toView.frame = finalFrame;
                       
                     } completion:^(BOOL finished) {
                       
                       [transitionContext completeTransition:finished];
                       
                     }];
  } else {

    UIViewController * fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    CGRect initialFrame =
    [transitionContext initialFrameForViewController:fromViewController];
    
    CGRect finalFrame = initialFrame;
    finalFrame.origin.y += containerView.bounds.size.height;

    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:1
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                       
                       fromViewController.view.frame = finalFrame;
                       
                     } completion:^(BOOL finished) {
                       
                       [transitionContext completeTransition:finished];
                       
                     }];
    
  }
  
}
@end
