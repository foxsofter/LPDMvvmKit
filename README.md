
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

可以clone并运行，主流程都是有demo可循的。

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

要让ViewController廋下来的，就需要将对应的业务逻辑移到ViewModel层，要做到并不难，invoke function、subscribe RACSignal、bind RACCommand就可以了，那么问题来了，如何在移到ViewModel层中的业务逻辑中进行页面跳转呢？主要一个解决办法就是让ViewController与ViewModel一一对应。

|#|ViewModel与ViewController解藕|对应的protocol
|---|---|---
|1|导航同步问题| [LPDNavigationControllerProtocol](https://github.com/foxsofter/lpd-mvvm-kit/blob/master/LPDMvvmKit/Classes/Mvvm/ViewControllers/LPDNavigationControllerProtocol.h) [LPDNavigationViewModelProtocol](https://github.com/foxsofter/lpd-mvvm-kit/blob/master/LPDMvvmKit/Classes/Mvvm/ViewModels/LPDNavigationViewModelProtocol.h)
|2|子ViewController问题|[LPDViewControllerProtocol](https://github.com/foxsofter/lpd-mvvm-kit/blob/master/LPDMvvmKit/Classes/Mvvm/ViewControllers/LPDViewControllerProtocol.h), [LPDViewModelProtocol](https://github.com/foxsofter/lpd-mvvm-kit/blob/master/LPDMvvmKit/Classes/Mvvm/ViewModels/LPDViewModelProtocol.h)
|3|表单提交进度条|[LPDViewModelReactProtocol](https://github.com/foxsofter/lpd-mvvm-kit/blob/master/LPDMvvmKit/Classes/Mvvm/ViewModels/LPDViewModelReactProtocol.h)
|4|加载进度条、下拉刷新、上拉加载更多|[LPDScrollViewModelProtocol](https://github.com/foxsofter/lpd-mvvm-kit/blob/master/LPDMvvmKit/Classes/Mvvm/ViewModels/LPDScrollViewModelProtocol.h), [LPDScrollViewControllerProtocol](https://github.com/foxsofter/lpd-mvvm-kit/blob/master/LPDMvvmKit/Classes/Mvvm/ViewControllers/LPDScrollViewControllerProtocol.h)
|5|toast|[LPDToastView](https://github.com/foxsofter/lpd-mvvm-kit/blob/master/LPDMvvmKit/Classes/Controls/LPDToastView/LPDToastView.h)
|6|alert|[LPDAlertView](https://github.com/foxsofter/lpd-mvvm-kit/blob/master/LPDMvvmKit/Classes/Controls/LPDAlertView/LPDAlertView.h)

###导航一一对应的例子
```Objective-c
  LPDHomeViewModel *vm = [[LPDHomeViewModel alloc] init];
  LPDHomeViewController *vc = [[LPDHomeViewController alloc] initWithViewModel:vm];
  [self.navigation lpd_pushViewController:vc animated:YES];

  LPDHomeViewModel *vm = [[LPDHomeViewModel alloc] init];
  [self.navigation pushViewModel:vm animated:YES];
```

```Objective-c
  [self.navigation lpd_popViewControllerAnimated:YES];

  [self.navigation popViewModelAnimated:YES];
```

```Objective-c
  [self.navigation lpd_popToRootViewControllerAnimated];

  [self.navigation popToRootViewModelAnimated:YES];
```

```Objective-c
  LPDHomeViewModel *vm = [[LPDHomeViewModel alloc] init];
  LPDNavigationViewModel *nvm = [[LPDNavigationViewModel alloc] initWithRootViewModel:vm];
  [self.navigation lpd_presentViewController:[[LPDNavigationController alloc] initWithViewModel:nvm] animated:YES completion:nil];

  LPDHomeViewModel *vm = [[LPDHomeViewModel alloc] init];
  [self.navigation presentViewModel:[[LPDNavigationViewModel alloc] initWithRootViewModel:vm] animated:YES completion:nil];

```

```Objective-c
  [self.navigation lpd_dismissViewControllerAnimated:YES completion:nil];
  
  [self.navigation dismissViewModelAnimated:YES completion:nil];
```

###子ViewController的例子
要实现子ViewController，现在可以这么做了

```Objective-c
	LPDWaybillsViewModel *waybillsViewModel = [[LPDWaybillsViewModel alloc] init];
	waybillsViewModel.title = @"待取餐";
	waybillsViewModel.waybillStatus = LPDWaybillStatusFetching;
	[self addChildViewModel:waybillsViewModel];
	waybillsViewModel = [[LPDWaybillsViewModel alloc] init];
	waybillsViewModel.title = @"待送达";
	waybillsViewModel.waybillStatus = LPDWaybillStatusDelivering;
	[self addChildViewModel:waybillsViewModel];
```

###表单提交的进度条的例子
更简单了,一行代码

```Objective-c
  self.submitting = YES;  // Show

  self.submitting = NO;  // hide
```

###加载的进度条的例子
需要设置beginLodingBlock和endLodingBlock来实现显示和取消加载进度条，然后不需要做其它事情了，剩下的交给框架来实现就好了，后面会说到tableview和collectionview加载的实现

```Objective-c
    [self beginLodingBlock:^(UIView *_Nonnull view) {
      UIView *contentView = [view viewWithTag:777777];
      if (contentView) {
        return;
      }
      contentView = [[UIView alloc] initWithFrame:view.bounds];
      contentView.tag = 777777;
      contentView.backgroundColor = [UIColor clearColor];
      [view addSubview:contentView];
      UIView *loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
      loadingView.layer.cornerRadius = 10;
      loadingView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];

      UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 57, 42)];
      imageView.animationImages = @[
        [UIImage imageNamed:@"01"],
        [UIImage imageNamed:@"02"],
        [UIImage imageNamed:@"03"],
        [UIImage imageNamed:@"04"],
        [UIImage imageNamed:@"05"],
        [UIImage imageNamed:@"06"]
      ];
      [loadingView addSubview:imageView];
      imageView.center = CGPointMake(loadingView.width / 2, loadingView.height / 2);
      [contentView addSubview:loadingView];
      //      loadingView.center = CGPointMake(contentView.width / 2, contentView.height / 2);

      if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8) {
        loadingView.center = [[UIApplication sharedApplication]
                                .keyWindow convertPoint:CGPointMake(UIScreen.width / 2, UIScreen.height / 2)
                                                 toView:view];
      } else {
        loadingView.center = CGPointMake([UIApplication sharedApplication].keyWindow.center.x,
                                         [UIApplication sharedApplication].keyWindow.center.y - 64);
      }
      [imageView startAnimating];
    }];
    [self endLodingBlock:^(UIView *_Nonnull view) {
      UIView *contentView = [view viewWithTag:777777];
      if (contentView) {
        [contentView removeFromSuperview];
      }
    }];
```

###下拉刷新的例子
下拉刷新默认使用MJRefresh，可以扩展然后通过initHeaderBlock来定制自己的下拉刷新效果，要实现下拉刷新不要太简单了，在LPDScrollViewController的子类中添加两行代码，在对应的ViewModel中实现loadingSignal

```Objective-c
  self.scrollView = self.tableView;
  self.needLoading = YES;
```

###上拉加载更多
上拉加载更多默认使用MJRefresh，目前暂时不支持定制，上拉加载更多的实现也很简单，在LPDScrollViewController的子类中添加一行代码，剩下的就是在对应的ViewModel中实现loadingMoreSignal

```Objective-c
  self.needLoadingMore = YES;
```

### Learn more



## License

MIT
