
[![Build Status](https://travis-ci.org/facebook/componentkit.svg)](https://travis-ci.org/facebook/componentkit)

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

LPDMvvmKit/Mvvm 就是LPDMvvmKit主要提供的功能了，因为对前两个Subspecs都有依赖，所以使用直接添加以下行就好了

```ruby
	pod 'LPDMvvmKit'
```

# why

目前在github上能搜到的与MVVM相关的Objective-c库有下面几个：

[lizelu/MVVM](https://github.com/lizelu/MVVM)

[shenAlexy/MVVM](https://github.com/shenAlexy/MVVM)

[leichunfeng/MVVMReactiveCocoa](https://github.com/leichunfeng/MVVMReactiveCocoa)

[lovemo/MVVMFramework](https://github.com/lovemo/MVVMFramework)

这些库都不错，都可以了解下，以上这些库各有各的使用场景，因为这些场景未能满足LPDMvvmKit对各层的定义，以及各层之间的分界线，所以这个轮子还得造。

LPDMvvmKit对各层的定义

|#|层|定义|
|---|---|----
|1|Model|[POCO model](http://stackoverflow.com/questions/725348/poco-vs-dto)
|2|View|View 或者 ViewController，一般情况下在ViewController中进行View与ViewModel之间的数据绑定，如果View是UITableViewCell和UICollectionViewCell等，也会在View中进行数据绑定
|3|ViewModel| 维护数据属性（持有Model），维护状态属性，响应用户操作的逻辑（function，RACSignal、RACCommand）
|4|Service|这一层提供系统依赖的外部接口，如网络调用层、系统定位等

要让ViewController廋下来的，就需要将对应的业务逻辑移到ViewModel层，要做到并不难，invoke function、subscribe RACSignal、bind RACCommand就可以了，那么问题来了，如何在移到ViewModel层中的业务逻辑中进行页面跳转呢？

|#|ViewModel与ViewController解藕
|---|---
|1|导航同步问题
|2|表单提交进度条
|3|加载进度条
|4|下拉刷新
|5|上拉加载
|6|toast
|7|alert

##解决导航同步问题
* 抽象出导航相关的页面跳转行为的一个子集
* 所有的页面跳转都归类到```objective-c
LPDNavigationControllerProtocol
```下
* 提供ViewModel层对应的```objective-c
LPDNavigationControllerProtocol
```跟 ```objective-c
LPDNavigationControllerProtocol
```一一对应

```Objective-c
@protocol LPDNavigationViewModelProtocol <NSObject>

@required

- (instancetype)initWithRootViewModel:(__kindof id<LPDViewModelProtocol>)viewModel;

@property (nullable, nonatomic, strong, readonly) __kindof id<LPDViewModelProtocol> topViewModel;

@property (nullable, nonatomic, strong, readonly) __kindof id<LPDViewModelProtocol> visibleViewModel;

@property (nullable, nonatomic, strong) __kindof id<LPDNavigationViewModelProtocol> presentedViewModel;

@property (nullable, nonatomic, strong) __kindof id<LPDNavigationViewModelProtocol> presentingViewModel;

@property (nonatomic, strong, readonly) NSArray<__kindof id<LPDViewModelProtocol>> *viewModels;

@optional

- (void)pushViewModel:(__kindof id<LPDViewModelProtocol>)viewModel animated:(BOOL)animated;

- (void)popViewModelAnimated:(BOOL)animated;

- (void)popToRootViewModelAnimated:(BOOL)animated;

- (void)presentViewModel:(__kindof id<LPDNavigationViewModelProtocol>)viewModel
                animated:(BOOL)animated
              completion:(nullable void (^)())completion;

- (void)dismissViewModelAnimated:(BOOL)animated completion:(nullable void (^)())completion;

@end

```






### Learn more



## License

MIT
