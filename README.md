# NgDialogPresentationController

Objective-c custom UIPresentationController for presenting UIViewController with dialog style.

![](https://github.com/meiwin/ngdialogpresentationcontroller/blob/master/demo.png)

## Adding to your project

If you are using CocoaPods, add to your Podfile:

```ruby
pod 'NgDialogPresentationController'
```

To manually add to your projects:

1. Add files in `NgDialogPresentationController` folder to your project.
2. Add these frameworks to your project: `UIKit`.

Since the library has dependency to [`NgKeyboardTracker`](https://github.com/meiwin/ngkeyboardtracker) pod, you need to also manually add it to your project.

## Usage

To present a view controller with dialog presentation style, create instance of `DialogTransitionStyle` and set it as the view controller's transition delegate.

You can refer to demo application file `TextFieldDialogViewController.m` for example.