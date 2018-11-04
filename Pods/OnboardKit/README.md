![OnboardKit](Assets/banner.png)

[![Swift 4.2](https://img.shields.io/badge/Swift-4.2-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![Version](https://img.shields.io/cocoapods/v/OnboardKit.svg?style=flat)](http://cocoapods.org/pods/OnboardKit)
[![License](https://img.shields.io/cocoapods/l/OnboardKit.svg?style=flat)](http://cocoapods.org/pods/OnboardKit)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Twitter](https://img.shields.io/badge/twitter-@NikolaKirev-blue.svg?style=flat)](https://twitter.com/NikolaKirev)

# OnboardKit
*Customizable user onboarding for your UIKit app in Swift*

<p align="center"><img src="https://media.giphy.com/media/3ohjV8gDG3kE5dbWSI/giphy.gif" /></p>

## Requirements

* Swift 4.2
* Xcode 10
* iOS 11.0+

## Installation

#### [Carthage](https://github.com/Carthage/Carthage)

````bash
github "NikolaKirev/OnboardKit"
````

#### [CocoaPods](http://cocoapods.org)

````ruby
use_frameworks!

# Latest release in CocoaPods
pod 'OnboardKit'

# Get the latest on master
pod 'OnboardKit', :git => 'https://github.com/NikolaKirev/OnboardKit.git', :branch => 'master'
````

Don't forget to `import OnboardKit` in the file you intend to use it.

## Usage

1. Create and populate a bunch of `OnboardPage` instances
````swift
let page = OnboardPage(title: "Welcome to OnboardKit",
                       imageName: "Onboarding1",
                       description: "OnboardKit helps you add onboarding to your iOS app")
````
2. Create an `OnboardViewController`
````swift
let onboardingViewController = OnboardViewController(pageItems: [pageOne, ...]])
````
3. Present the view controller
````swift
onboardingVC.presentFrom(self, animated: true)
````
(use this convenience method to make sure you present it modally)

## Customization

![Custom examples](Assets/custom_examples.png)

You can customize the look of your onboarding by changing the default colors.
````swift
AppearanceConfiguration(tintColor: .orange,
                        titleColor: .red,
                        textColor: .white,
                        backgroundColor: .black,
                        titleFont: UIFont.boldSystemFont(ofSize: 32.0),
                        textFont: UIFont.boldSystemFont(ofSize: 17.0))
````

## Author

### Nikola Kirev

* Website: [http://nikolakirev.com](http://nikolakirev.com)
* Twitter: [@NikolaKirev](http://twitter.com/nikolakirev)

## License

OnboardKit is available under the MIT license. See the [LICENSE](https://github.com/NikolaKirev/OnboardKit/blob/master/LICENSE) file for more info.
