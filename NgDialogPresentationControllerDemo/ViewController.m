//
//  ViewController.m
//  NgDialogPresentationControllerDemo
//
//  Created by Meiwin Fu on 20/9/15.
//  Copyright © 2015 Meiwin Fu. All rights reserved.
//

#import "ViewController.h"
#import "NgDialogTransitionDelegate.h"
#import "NgDialogPresentationController.h"
#import "TextFieldDialogViewController.h"

@interface ViewController ()
@end

@implementation ViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.title = @"Dialog Demo";
  }
  return self;
}
- (void)viewDidLoad {
  [super viewDidLoad];
 
  self.view.backgroundColor = [UIColor colorWithWhite:.98 alpha:1];
  
  UIBarButtonItem * dialogBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Open Dialog" style:UIBarButtonItemStyleDone target:self action:@selector(openDialog:)];
  self.navigationItem.rightBarButtonItem = dialogBarItem;
}
- (void)openDialog:(id)sender {

  TextFieldDialogViewController * c = [[TextFieldDialogViewController alloc] initWithNibName:nil bundle:nil];
  c.title = @"Hello World";
  [self presentViewController:c animated:YES completion:nil];
}
@end
