# ProtocolKit

[![CI Status](http://img.shields.io/travis/forkingdog/ProtocolKit.svg?style=flat)](https://travis-ci.org/forkingdog/ProtocolKit)
[![Version](https://img.shields.io/cocoapods/v/ProtocolKit.svg?style=flat)](http://cocoapods.org/pods/ProtocolKit)
[![License](https://img.shields.io/cocoapods/l/ProtocolKit.svg?style=flat)](http://cocoapods.org/pods/ProtocolKit)
[![Platform](https://img.shields.io/cocoapods/p/ProtocolKit.svg?style=flat)](http://cocoapods.org/pods/ProtocolKit)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

ProtocolKit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "ProtocolKit"
```

## Author

forkingdog

## License

ProtocolKit is available under the MIT license. See the LICENSE file for more info.

# ProtocolKit

Protocol extension for Objective-C

# Usage

Your protocol:  

```objc
@protocol Forkable <NSObject>

@optional
- (void)fork;

@required
- (NSString *)github;

@end
```

Protocol extension, add default implementation, use `@defs` magic keyword    

```objc
@defs(Forkable)

- (void)fork {
    NSLog(@"Forkable protocol extension: I'm forking (%@).", self.github);
}

- (NSString *)github {
    return @"This is a required method, concrete class must override me.";
}

@end
```

Your concrete class

```objc
@interface Forkingdog : NSObject <Forkable>
@end

@implementation Forkingdog

- (NSString *)github {
    return @"https://github.com/forkingdog";
}

@end
```

Run test

```objc
[[Forkingdog new] fork];
```

Result

```
[Console] Forkable protocol extension: I'm forking (https://github.com/forkingdog).
```