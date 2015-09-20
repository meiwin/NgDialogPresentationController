Pod::Spec.new do |spec|
spec.name         = 'NgDialogPresentationController'
spec.version      = '1.0'
spec.summary      = 'Custom UIPresentationController for presenting view controller with dialog style.'
spec.homepage     = 'https://github.com/meiwin/NgDialogPresentationController'
spec.author       = { 'Meiwin Fu' => 'meiwin@blockthirty.com' }
spec.source       = { :git => 'https://github.com/meiwin/NgDialogPresentationController.git', :tag => "v#{spec.version}" }
spec.source_files = 'NgDialogPresentationController/**/*.{h,m}'
spec.requires_arc = true
spec.license      = { :type => 'MIT', :file => 'LICENSE' }
spec.frameworks   = 'UIKit'
spec.ios.deployment_target = "8.0"
spec.ios.dependency 'NgKeyboardTracker'
end