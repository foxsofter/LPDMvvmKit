# lpd-mvvm-kit
Objective-c下采用MVVM开发的另外一个选择

# Goal

LPDMvvmKit提供了一些常用的工具类，还有一些很轻巧的控件，以及最主要的是提供了MVVM开发框架，一直比较喜欢采用MVVM的框架来开发前端产品，所以会希望在iOS下也能找到类似的框架可以采用，但是一直没有找到合适的，所以就自己造了个轮子，代码未充分测试，欢迎各种issue。

# How to use

LPDMvvmKit支持 [CocoaPods](http://cocoapods.org)，在 [Podfile](https://guides.cocoapods.org/using/the-podfile.html)文件中添加如下行

```ruby
	pod 'LPDMvvmKit'
```

分为三个Subspecs

LPDMvvmKit/Additions 主要提供一些常用的工具类的代码

```ruby
	pod 'LPDMvvmKit/Additions'
```

LPDMvvmKit/Controls 目前提供一些控件，LPDToastView，LPDAlertView可以了解下

```ruby
	pod 'LPDMvvmKit/Controls'
```

LPDMvvmKit/Mvvm 就是LPDMvvmKit主要提供的功能了，因为对前两个Subspecs都有依赖，所以一般使用直接添加以下行就好了

```ruby
	pod 'LPDMvvmKit'
```

# LPDMvvmKit/Additions的亮点

```objective-c
@interface NSObject (LPDAssociatedObject)

- (id)object:(SEL)key;

- (void)setRetainNonatomicObject:(id)object withKey:(SEL)key;

- (void)setCopyNonatomicObject:(id)object withKey:(SEL)key;

- (void)setRetainObject:(id)object withKey:(SEL)key;

- (void)setCopyObject:(id)object withKey:(SEL)key;

@end
```




# Learn more

* Read the [Getting Started guide](http://www.componentkit.org/docs/getting-started.html)
* Get the [sample projects](https://github.com/facebook/componentkit/tree/master/Examples/WildeGuess)
* Read the [objc.io article](http://www.objc.io/issue-22/facebook.html) by Adam Ernst
* Watch the [@Scale talk](https://youtu.be/mLSeEoC6GjU?t=24m18s) by Ari Grant



# License

MIT
