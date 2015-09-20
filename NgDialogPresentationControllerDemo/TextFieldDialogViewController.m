//
//  EmptyDialogViewController.m
//  NgDialogPresentationController
//
//  Created by Meiwin Fu on 20/9/15.
//  Copyright © 2015 BlockThirty. All rights reserved.
//

#import "TextFieldDialogViewController.h"
#import "NgDialogTransitionDelegate.h"

@interface TextFieldDialogView : UIView
@property (nonatomic, weak, readonly) UILabel     * titleLabel;
@property (nonatomic, weak, readonly) UITextField * textField;
@end

@implementation TextFieldDialogView
- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    
    self.layer.cornerRadius = 8;
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel * titleLabel = [UILabel new];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    [self addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    UITextField * textField = [[UITextField alloc] initWithFrame:CGRectZero];
    textField.placeholder = @"Typing something";
    textField.textAlignment = NSTextAlignmentCenter;
    [self addSubview:textField];
    _textField = textField;
  }
  return self;
}
- (void)layoutSubviews {
  [super layoutSubviews];
  
  CGSize s = self.bounds.size;
  _titleLabel.frame = CGRectMake(10, 20, s.width-20, 20);
  _textField.frame = CGRectMake(10, 30 + floorf((s.height-40-30)/2.f), s.width-20, 30);
}
@end

#pragma mark -
@interface TextFieldDialogViewController ()
@property (nonatomic, strong) NgDialogTransitionDelegate * dialogTransitionDelegate;
@property (nonatomic, weak) TextFieldDialogView * dialogView;
@end

@implementation TextFieldDialogViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    
    NgDialogTransitionDelegate * dialogTransitionDelegate =
    [[NgDialogTransitionDelegate alloc] init];
    
    self.dialogTransitionDelegate = dialogTransitionDelegate;
    
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.transitioningDelegate = self.dialogTransitionDelegate;
    
    self.preferredContentSize = CGSizeMake(300, 200);
  }
  return self;
}
- (void)loadView {
  [super loadView];
  
  TextFieldDialogView * dview = [[TextFieldDialogView alloc] initWithFrame:self.view.bounds];
  dview.titleLabel.text = self.title;
  self.view = dview;
  self.dialogView = dview;
}
- (void)viewDidLoad {
  [super viewDidLoad];

  self.view.backgroundColor = [UIColor whiteColor];
  self.view.layer.cornerRadius = 5;
}
- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  
  [self.dialogView.textField resignFirstResponder];
}
@end
