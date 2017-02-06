#LPDMvvmKit

[![CI Status](https://travis-ci.org/LPD-iOS/lpd-mvvm-kit.svg?branch=master)](https://travis-ci.org/LPD-iOS/lpd-mvvm-kit)
[![Version](https://img.shields.io/cocoapods/v/LPDMvvmKit.svg?style=flat)](http://cocoapods.org/pods/LPDMvvmKit)
[![License](https://img.shields.io/cocoapods/l/LPDMvvmKit.svg?style=flat)](http://cocoapods.org/pods/LPDMvvmKit)
[![Platform](https://img.shields.io/cocoapods/p/LPDMvvmKit.svg?style=flat)](http://cocoapods.org/pods/LPDMvvmKit)

## Example

To run the example project, clone the repo, and run.

## Requirements

iOS 8.0 or later

## Installation

LPDMvvmKit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "LPDMvvmKit"
```

## Author

foxsofter, foxsofter@gmail.com

## License

LPDMvvmKit is available under the MIT license. See the LICENSE file for more info.

# Goal

LPDMvvmKit提供了一些常用的工具类，还有一些很轻巧的控件，以及最主要的是提供了MVVM开发框架，一直比较喜欢采用MVVM的框架来开发前端产品，所以会希望在iOS下也能找到类似的框架可以采用，但是一直没有找到合适的，所以就自己造了个轮子，代码未充分测试，欢迎各种issue。

# view controller和view model解耦

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

要让ViewController廋下来的，就需要将对应的业务逻辑移到ViewModel层，要做到并不难，invoke function、subscribe RACSignal、bind RACCommand就可以了，那么问题来了，如何在移到ViewModel层中的业务逻辑中进行页面跳转呢？目前的做法是对导航做了精简，重写导航相关的接口，所有需要push，pop，present，dismiss操作的接口都封装到navigation相关的两个protocol [LPDNavigationControllerProtocol](https://github.com/LPD-iOS/lpd-mvvm-kit/blob/master/LPDMvvmKit/Classes/ViewControllers/LPDNavigationControllerProtocol.h) ，[LPDNavigationViewModelProtocol](https://github.com/LPD-iOS/lpd-mvvm-kit/blob/master/LPDMvvmKit/Classes/ViewModels/LPDNavigationViewModelProtocol.h) 中，当需要present或者push一个view controller，必须要嵌套在navigation view controller中，同样的present或者push一个view model时，必须要嵌套在navigation view model中，这样并不会带来更多的复杂性，但是在需要用navigation时，不需要做任何改动。

|#|ViewModel与ViewController解藕存在的问题|解决方案对应的protocol
|---|---|---
|1|导航同步问题| [LPDNavigationControllerProtocol](https://github.com/LPD-iOS/lpd-mvvm-kit/blob/master/LPDMvvmKit/Classes/ViewControllers/LPDNavigationControllerProtocol.h) [LPDNavigationViewModelProtocol](https://github.com/LPD-iOS/lpd-mvvm-kit/blob/master/LPDMvvmKit/Classes/ViewModels/LPDNavigationViewModelProtocol.h)
|2|子ViewController问题|[LPDViewControllerProtocol](https://github.com/LPD-iOS/lpd-mvvm-kit/blob/master/LPDMvvmKit/Classes/ViewControllers/LPDViewControllerProtocol.h), [LPDViewModelProtocol](https://github.com/LPD-iOS/lpd-mvvm-kit/blob/master/LPDMvvmKit/Classes/ViewModels/LPDViewModelProtocol.h)
|3|表单提交进度条|[LPDViewModelReactProtocol](https://github.com/LPD-iOS/lpd-mvvm-kit/blob/master/LPDMvvmKit/Classes/ViewModels/LPDViewModelReactProtocol.h)
|4|加载进度条、下拉刷新、上拉加载更多|[LPDScrollViewModelProtocol](https://github.com/LPD-iOS/lpd-mvvm-kit/blob/master/LPDMvvmKit/Classes/ViewModels/LPDScrollViewModelProtocol.h), [LPDScrollViewControllerProtocol](https://github.com/LPD-iOS/lpd-mvvm-kit/blob/master/LPDMvvmKit/Classes/ViewControllers/LPDScrollViewControllerProtocol.h)
|5|toast|[LPDToastView](https://github.com/LPD-iOS/lpd-controls-kit/tree/master/LPDControlsKit/Classes/LPDToastView/LPDToastView.h)
|6|alert|[LPDAlertView](https://github.com/LPD-iOS/lpd-controls-kit/tree/master/LPDControlsKit/Classes/LPDAlertView/LPDAlertView.h)

更多细节请参考源码，可能不是最好的解决方案，欢迎issue

###导航一一对应的例子
```Objective-c
  LPDHomeViewModel *vm = [[LPDHomeViewModel alloc] init];
  LPDHomeViewController *vc = [[LPDHomeViewController alloc] initWithViewModel:vm];
  [self.navigation pushViewController:vc animated:YES];

  LPDHomeViewModel *vm = [[LPDHomeViewModel alloc] init];
  [self.navigation pushViewModel:vm animated:YES];
```

```Objective-c
  [self.navigation popViewControllerAnimated:YES];

  [self.navigation popViewModelAnimated:YES];
```

```Objective-c
  [self.navigation popToRootViewControllerAnimated];

  [self.navigation popToRootViewModelAnimated:YES];
```

```Objective-c
  LPDHomeViewModel *vm = [[LPDHomeViewModel alloc] init];
  LPDNavigationViewModel *nvm = [[LPDNavigationViewModel alloc] initWithRootViewModel:vm];
  [self.navigation presentViewController:[[LPDNavigationController alloc] initWithViewModel:nvm] animated:YES completion:nil];

  LPDHomeViewModel *vm = [[LPDHomeViewModel alloc] init];
  [self.navigation presentViewModel:[[LPDNavigationViewModel alloc] initWithRootViewModel:vm] animated:YES completion:nil];

```

```Objective-c
  [self.navigation dismissViewControllerAnimated:YES completion:nil];
  
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

###上拉加载更多的例子
上拉加载更多默认使用MJRefresh，目前暂时不支持定制，上拉加载更多的实现也很简单，在LPDScrollViewController的子类中添加一行代码，剩下的就是在对应的ViewModel中实现loadingMoreSignal

```Objective-c
  self.needLoadingMore = YES;
```
更多细节请参考demo


#data binding

数据绑定是MVVM解藕的根本，前面提到的解决view model和view controller耦合的问题，也是通过ReactiveCocoa的信号流来做到导航同步等。数据绑定的对象有两种，property，collection，这两者的变更能发出通知是数据绑定的必须条件，相对应的在Objective-C中property的变更可以通过KVO实现，当然用RAC的方式更简单了，这里不再阐述。然而collection的变更并没有很好的方式能发出相应的通知，可以扩展相对应的类（如NSMutableArray，NSMutableDictionary等集合类）来达到这类目的。些集合最终是做为UITableView或者UICollectionView的数据源存在，系统框架现在的UITableView和UICollectionView都是通过委托来实现，相关的代码实在繁琐（应该不会只有我一个人这么认为）。我很希望能彻底解决这两个问题，所以有了[LPDTableViewModelProtocol](https://github.com/LPD-iOS/lpd-mvvm-kit/blob/master/LPDMvvmKit/Classes/ViewModels/LPDTableViewModelProtocol.h)，[LPDCollectionViewModelProtocol](https://github.com/LPD-iOS/lpd-mvvm-kit/blob/master/LPDMvvmKit/Classes/ViewModels/LPDCollectionViewModelProtocol.h) 等一系列的代码，主要是为了解决UITableView和UICollectionView的ViewModel的数据绑定并简化相关的代码，实现所需的代码量还是比较多的，有兴趣还是看代码更为直观。
主要是的设计思路是这样的：将增删接口都通过protocol的方式封装，避免每次都是通过delegate去实现，只需要调用对应的接口就好了，另外对一些常用的操作如 didSelect 等都从delegate method改成RACSignal，通过这些改变，让代码可以聚合起来，相关的代码逻辑不需要在多个零散的函数中去添加代码。

###demo中的一些例子，加载tableview的数据

```Objective-c
-(void)reloadTable {
  if (self.datas && self.datas.count > 0) {
    NSMutableArray *cellViewModels = [NSMutableArray array];
    for (LPDPostModel *model in self.datas) {
      LPDTablePostCellViewModel *cellViewModel = [[LPDTablePostCellViewModel alloc]initWithViewModel:self.tableViewModel];
      cellViewModel.model = model;
      [cellViewModels addObject:cellViewModel];
    }
    [self.tableViewModel replaceSectionWithCellViewModels:cellViewModels withRowAnimation:UITableViewRowAnimationTop];
  }else{
    [self.tableViewModel removeAllSections];
  }
}

```

###添加一个cell

```Objective-c
        LPDPostModel *model = [[LPDPostModel alloc]init];
        model.userId = 111111;
        model.identifier = 1003131;
        model.title = @"First Chapter";
        model.body = @"GitBook allows you to organize your book into chapters, each chapter is stored in a separate file like this one.";
        LPDTablePostCellViewModel *cellViewModel = [[LPDTablePostCellViewModel alloc]initWithViewModel:self.tableViewModel];
        cellViewModel.model = model;
        [self.tableViewModel insertCellViewModel:cellViewModel atIndex:0 withRowAnimation:UITableViewRowAnimationLeft];

```

###批量添加cell
```Objective-c
        NSMutableArray *cellViewModels = [NSMutableArray array];
        LPDTableDefaultCellViewModel *cellViewModel1 =
          [[LPDTableDefaultCellViewModel alloc] initWithViewModel:self.tableViewModel];
        cellViewModel1.text = @"芬兰无法";
        cellViewModel1.detail = @"蜂王浆发了";
        cellViewModel1.image = [UIImage imageNamed:@"01"];
        [cellViewModels addObject:cellViewModel1];
        LPDTableValue1CellViewModel *cellViewModel2 =
          [[LPDTableValue1CellViewModel alloc] initWithViewModel:self.tableViewModel];
        cellViewModel2.text = @"芬兰无法";
        cellViewModel2.detail = @"蜂王浆发了";
        cellViewModel2.image = [UIImage imageNamed:@"02"];
        [cellViewModels addObject:cellViewModel2];
        LPDTableValue2CellViewModel *cellViewModel3 =
          [[LPDTableValue2CellViewModel alloc] initWithViewModel:self.tableViewModel];
        cellViewModel3.text = @"芬兰无法";
        cellViewModel3.detail = @"蜂王浆发了";
        [cellViewModels addObject:cellViewModel3];
        LPDTableSubtitleCellViewModel *cellViewModel4 =
          [[LPDTableSubtitleCellViewModel alloc] initWithViewModel:self.tableViewModel];
        cellViewModel4.text = @"芬兰无法";
        cellViewModel4.detail = @"蜂王浆发了";
        cellViewModel4.image = [UIImage imageNamed:@"03"];
        [cellViewModels addObject:cellViewModel4];

        [self.tableViewModel insertCellViewModels:cellViewModels atIndex:0 withRowAnimation:UITableViewRowAnimationLeft];
```

###删除一个cell
```Objective-c
        [self.tableViewModel removeCellViewModelAtIndex:0 withRowAnimation:UITableViewRowAnimationRight];
```

###cell的didSelect
```Objective-c
      [[[self.waybillsTableViewModel.didSelectRowAtIndexPathSignal deliverOnMainThread]
        takeUntil:[self rac_willDeallocSignal]] subscribeNext:^(RACTuple *tuple) {
        @strongify(self);
        __kindof id<LPDTableCellViewModelProtocol> cellViewModel = tuple.second;
        LPDWaybillModel *waybillModel = cellViewModel.model;
        if (waybillModel.cancelCode == 0) {
          LPDWaybillDetailViewModel *detailViewModel = [[LPDWaybillDetailViewModel alloc] init];
          detailViewModel.waybillId = waybillModel.waybillId;
          [self.navigation pushViewModel:detailViewModel animated:YES];
        }
      }];
```

###目前支持的操作
```Objective-c
@property (nonatomic, strong, readonly) RACSignal *willDisplayCellSignal;
@property (nonatomic, strong, readonly) RACSignal *willDisplayHeaderViewSignal;
@property (nonatomic, strong, readonly) RACSignal *willDisplayFooterViewSignal;
@property (nonatomic, strong, readonly) RACSignal *didEndDisplayingCellSignal;
@property (nonatomic, strong, readonly) RACSignal *didEndDisplayingHeaderViewSignal;
@property (nonatomic, strong, readonly) RACSignal *didEndDisplayingFooterViewSignal;
@property (nonatomic, strong, readonly) RACSignal *didHighlightRowAtIndexPathSignal;
@property (nonatomic, strong, readonly) RACSignal *didUnhighlightRowAtIndexPathSignal;
@property (nonatomic, strong, readonly) RACSignal *didSelectRowAtIndexPathSignal;
@property (nonatomic, strong, readonly) RACSignal *didDeselectRowAtIndexPathSignal;
@property (nonatomic, strong, readonly) RACSignal *willBeginEditingRowAtIndexPathSignal;
@property (nonatomic, strong, readonly) RACSignal *didEndEditingRowAtIndexPathSignal;
```


## License

MIT
