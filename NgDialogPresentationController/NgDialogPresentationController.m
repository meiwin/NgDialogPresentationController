//
//  NgDialogPresentationController.m
//  NgDialogPresentationController
//
//  Created by Meiwin Fu on 20/9/15.
//  Copyright © 2015 Meiwin Fu. All rights reserved.
//

#import "NgDialogPresentationController.h"
#import <NgKeyboardTracker/NgKeyboardTracker.h>

#pragma mark -
@interface NgDialogTransitionCoordinator : NSObject <UIViewControllerTransitionCoordinator>
@property (nonatomic, strong, readonly) NSMutableArray * animationBlocks;
@property (nonatomic, strong, readonly) NSMutableArray * completionBlocks;
@property (nonatomic, weak, readonly) NgDialogPresentationController * presentationController;
- (instancetype)initWithDialogPresentationController:(NgDialogPresentationController *)pc;
- (instancetype)init __unavailable;
@end

@interface NgDialogTransitionCoordinator ()
@property (nonatomic, strong) NSMutableArray * animationBlocks;
@property (nonatomic, strong) NSMutableArray * completionBlocks;
@property (nonatomic) BOOL completed;
@end

@implementation NgDialogTransitionCoordinator

- (instancetype)initWithDialogPresentationController:(NgDialogPresentationController *)pc {
  self = [super init];
  if (self) {
    _presentationController = pc;
    self.animationBlocks = [NSMutableArray array];
    self.completionBlocks = [NSMutableArray array];
  }
  return self;
}

- (BOOL)animateAlongsideTransition:(void (^)(id<UIViewControllerTransitionCoordinatorContext>))animation
                        completion:(void (^)(id<UIViewControllerTransitionCoordinatorContext>))completion {
  
  if (animation) [self.animationBlocks addObject:animation];
  if (completion) [self.completionBlocks addObject:completion];
  return YES;
}

- (BOOL)animateAlongsideTransitionInView:(UIView *)view
                               animation:(void (^)(id<UIViewControllerTransitionCoordinatorContext>))animation
                              completion:(void (^)(id<UIViewControllerTransitionCoordinatorContext>))completion {
  return NO;
}
- (void)notifyWhenInteractionEndsUsingBlock:(void (^)(id<UIViewControllerTransitionCoordinatorContext>))handler {}
- (BOOL)isInteractive { return NO; }
- (BOOL)initiallyInteractive { return NO; }
- (UIViewAnimationCurve)completionCurve {
  return UIViewAnimationCurveEaseInOut;
}
- (UIViewController *)viewControllerForKey:(NSString *)key {
  return [self.presentationController presentedViewController];
}
- (UIView *)viewForKey:(NSString *)key {
  return [self.presentationController presentedView];
}
- (CGFloat)percentComplete {
  return self.completed ? 1 : 0;
}
- (UIView *)containerView {
  return [self.presentationController containerView];
}
- (NSTimeInterval)transitionDuration {
  return .3;
}
- (BOOL)isCancelled { return NO; }
- (CGAffineTransform)targetTransform {
  return [self.presentationController presentedView].transform;
}
- (UIModalPresentationStyle)presentationStyle {
  return UIModalPresentationCustom;
}
- (BOOL)isAnimated { return YES; }
- (CGFloat)completionVelocity { return 1; }
@end

#pragma mark -
@interface NgDialogPresentationController () <NgKeyboardTrackerDelegate>
@property (nonatomic, strong) UIView        * dimmingView;
@property (nonatomic) CGSize                previousContentSize;
@end

@implementation NgDialogPresentationController
- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController
                       presentingViewController:(UIViewController *)presentingViewController {
  
  self = [super initWithPresentedViewController:presentedViewController
                       presentingViewController:presentingViewController];
  if (self) {
    [self loadDialogPresentationController];
  }
  return self;
}
- (void)dealloc {
  [[NgKeyboardTracker sharedTracker] removeDelegate:self];
}
- (void)loadDialogPresentationController {
  
  UIView * dimmingView = [UIView new];
  self.dimmingView = dimmingView;
  
  self.dimmingView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
  
  UITapGestureRecognizer * dimmingTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dimmingViewTapped:)];
  [self.dimmingView addGestureRecognizer:dimmingTapGR];
}
- (void)presentationTransitionWillBegin {
  
  UIView * containerView = [self containerView];
  UIViewController * presentedViewController = [self presentedViewController];
  
  self.dimmingView.frame = containerView.bounds;
  self.dimmingView.alpha = 0;
  [containerView insertSubview:self.dimmingView atIndex:0];
  
  if ([presentedViewController transitionCoordinator]) {
    
    [[presentedViewController transitionCoordinator] animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
      
      self.dimmingView.alpha = 1.f;
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {}];
    
  } else {
    
    self.dimmingView.alpha = 1.f;
  }
}
- (void)presentationTransitionDidEnd:(BOOL)completed {
  [[NgKeyboardTracker sharedTracker] addDelegate:self];
}
- (void)dismissalTransitionWillBegin {
  
  [[NgKeyboardTracker sharedTracker] removeDelegate:self];
  UIViewController * presentedViewController = [self presentedViewController];
  
  if ([presentedViewController transitionCoordinator]) {
    
    [[presentedViewController transitionCoordinator] animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
      
      self.dimmingView.alpha = 0;
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {}];
    
  } else {
    
    self.dimmingView.alpha = 0;
  }
  
}
- (CGRect)frameOfPresentedViewInContainerView {
  
  UIView * containerView = [self containerView];
  CGRect kbFrame = [[NgKeyboardTracker sharedTracker] keyboardCurrentFrameForView:containerView];
  CGFloat kbBottomInset = 0;
  if (!CGRectEqualToRect(CGRectZero, kbFrame)) {
    CGRect intersection = CGRectIntersection(containerView.bounds, kbFrame);
    kbBottomInset = containerView.bounds.size.height - intersection.origin.y;
  }

  CGFloat containerUsableHeight = containerView.bounds.size.height - kbBottomInset;
  CGFloat maxDialogHeight = containerUsableHeight - 40; // 40 = vertical padding 20 and 20
  
  UIViewController * presentedViewController = [self presentedViewController];
  CGSize preferredSize = [presentedViewController preferredContentSize];
  if (preferredSize.width == 0) preferredSize.width = 300.f;
  if (preferredSize.height == 0) preferredSize.height = 200.f;
  preferredSize.height = MIN(maxDialogHeight, preferredSize.height);
  
  CGSize containerSize = containerView.bounds.size;
  CGRect frame =
  CGRectMake((containerSize.width - preferredSize.width)/2.f,
             (containerUsableHeight - preferredSize.height)/2.f,
             preferredSize.width,
             preferredSize.height);
  
  return frame;
}
- (void)containerViewWillLayoutSubviews {
  self.dimmingView.frame = [self containerView].bounds;
}

- (void)preferredContentSizeDidChangeForChildContentContainer:(id<UIContentContainer>)container {
  
  if (![self containerView]) return;
  if (container == [self presentedViewController]) {
    
    [self repositionOrResizePresentedView:YES];
  }
}
- (BOOL)shouldPresentInFullscreen {
  return YES;
}

- (void)dimmingViewTapped:(UIGestureRecognizer *)gesture
{
  if([gesture state] == UIGestureRecognizerStateRecognized)
  {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:NULL];
  }
}

#pragma mark Resize and repositioning
- (void)repositionOrResizePresentedView:(BOOL)animated {
  
  CGRect frame = [self frameOfPresentedViewInContainerView];
  if (!CGSizeEqualToSize(frame.size, self.previousContentSize)) {
   
    NgDialogTransitionCoordinator * tc = [[NgDialogTransitionCoordinator alloc] initWithDialogPresentationController:self];
    [[self presentedViewController] viewWillTransitionToSize:frame.size withTransitionCoordinator:tc];
    
    void (^performLayout)() = ^{
      self.presentedView.frame = frame;
      for (void(^animation)(id<UIViewControllerTransitionCoordinatorContext>) in tc.animationBlocks) animation(tc);
    };
    void (^performCompletions)() = ^{
      tc.completed = YES;
      for (void(^completion)(id<UIViewControllerTransitionCoordinatorContext>) in tc.completionBlocks) completion(tc);
    };

    if (animated) {
      [UIView animateWithDuration:[tc transitionDuration]
                            delay:0
           usingSpringWithDamping:0.8
            initialSpringVelocity:1
                          options:UIViewAnimationOptionCurveEaseInOut
                       animations:^{
                         performLayout();
                       } completion:^(BOOL finished) {
                         performCompletions();
                       }];
    } else {
      performLayout();
      performCompletions();
    }
    
  } else {
    
    if (!CGRectEqualToRect(self.presentedView.frame, frame)) {
      
      if (animated) {
        [UIView animateWithDuration:.3
                              delay:0
             usingSpringWithDamping:0.8
              initialSpringVelocity:1
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                           
                           self.presentedView.frame = frame;
                           
                         } completion:nil];
      } else {
        self.presentedView.frame = frame;
      }
    }
  }
  
  self.previousContentSize = frame.size;
}
#pragma mark <NgKeyboardTrackerDelegate>
- (void)keyboardTrackerDidChangeAppearanceState:(NgKeyboardTracker *)tracker {
  [self repositionOrResizePresentedView:NO];
}
- (void)keyboardTrackerDidUpdate:(NgKeyboardTracker *)tracker {
  [self repositionOrResizePresentedView:NO];
}
@end
