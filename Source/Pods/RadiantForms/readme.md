# RadiantForms

[![Build Status](https://travis-ci.org/radiantkit/radiantforms-ios.svg?branch=master)](https://travis-ci.org/radiantkit/radiantforms-ios)
[![Version](https://img.shields.io/cocoapods/v/RadiantForms.svg?style=flat)](http://cocoapods.org/pods/RadiantForms)
[![License](https://img.shields.io/cocoapods/l/RadiantForms.svg?style=flat)](http://cocoapods.org/pods/RadiantForms)
[![Platform](https://img.shields.io/cocoapods/p/RadiantForms.svg?style=flat)](http://cocoapods.org/pods/RadiantForms)

**RadiantForms is an iOS framework for creating forms.**

Because form code is hard to write, hard to read, hard to reason about. Has a slow turn around time. Is painful to maintain.

[Demo on YouTube](https://youtu.be/PKbVJ91uQdA)


## Requirements

- iOS 10.0+
- Xcode 10.2.1+
- Swift 5.0+


## Features

- [x] Several form items, such as textfield, buttons, sliders
- [x] Some form items can expand/collapse, such as datepicker, pickerview
- [x] You can create your own custom form items
- [x] Align textfields across multiple rows
- [x] Form validation rule engine
- [x] Shows with red text where there are problems with validation
- [x] Strongly Typed
- [x] Pure Swift
- [x] No 3rd party dependencies


# USAGE

### Tutorial 0 - Static text

```swift
import RadiantForms

class Tutorial0_StaticText_ViewController: RFFormViewController {
	override func populate(_ builder: RFFormBuilder) {
		builder += RFStaticTextFormItem().title("Hello").value("World")
	}
}
```

### Tutorial 1 - TextField

```swift
import RadiantForms

class Tutorial1_TextField_ViewController: RFFormViewController {
	override func populate(_ builder: RFFormBuilder) {
		builder += RFTextFieldFormItem().title("Email").placeholder("Please specify").keyboardType(.emailAddress)
	}
}
```

### Tutorial 2 - Open child view controller

```swift
import RadiantForms

class Tutorial2_ChildViewController_ViewController: RFFormViewController {
	override func populate(_ builder: RFFormBuilder) {
		builder += RFViewControllerFormItem().title("Go to view controller").viewController(FirstViewController.self)
	}
}
```


# INSTALLATION

## CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects.

You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate `RadiantForms` into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

pod 'RadiantForms'
```

Then, run the following command:

```bash
$ pod install
```

# Development

Development happens in the [`develop`](https://github.com/radiantkit/radiantforms-ios/tree/develop) branch.

- If you want to contribute, submit a pull request.
- If you found a bug, have suggestions or need help, please, open an issue.
- If you need help, feel free to write me: neoneye@gmail.com

