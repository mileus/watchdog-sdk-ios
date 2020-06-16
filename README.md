# iOS SDK for Mileus Watchdog

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Pods compatible](https://img.shields.io/cocoapods/v/MileusWatchdogKit.svg?style=flat)](https://cocoapods.org/pods/MileusKit)
[![SPM compatible](https://img.shields.io/badge/SPM-supported-DE5C43.svg?style=flat)](https://swift.org/package-manager)
[![Platform](https://img.shields.io/cocoapods/p/LFAlertController.svg?style=flat)](https://github.com/skoumalcz)
[![Swift Version](https://img.shields.io/badge/swift-5.1-orange.svg)](https://swift.org/)

This library supports an asynchronous background search for journey plans through Mileus, with the base use case of commuting home from the user's current location.

Please see the [Watchdog search docs](https://docs.mileus.com/watchdog-search/) for more details about the functionality, or the [SDK docs](https://docs.mileus.com/watchdog-search/frontend-integration/sdk/ios/) for more details about the usage of this SDK.

## Requirements

* iOS 11.0+
* Xcode 11.0+
* Swift 5.0+

## Installation

### Carthage

```
github "mileus/watchdog-sdk-ios" ~> 0.1.0
```

### Cocoapods

```
pod 'MileusWatchdogKit', '~> 0.1'
```

### Swift Package Manager
We are waiting for Swift 5.3 official release. It does not work yet.

```
dependencies: [
    .package(url: "https://github.com/mileus/watchdog-sdk-ios.git", .upToNextMajor(from: "0.1.0"))
]
```
