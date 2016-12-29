# LPDTableViewKit

[![CI Status](https://travis-ci.org/LPD-iOS/lpd-tableview-kit.svg?branch=master)](https://travis-ci.org/LPD-iOS/lpd-tableview-kit)
[![Version](https://img.shields.io/cocoapods/v/LPDTableViewKit.svg?style=flat)](http://cocoapods.org/pods/LPDTableViewKit)
[![License](https://img.shields.io/cocoapods/l/LPDTableViewKit.svg?style=flat)](http://cocoapods.org/pods/LPDTableViewKit)
[![Platform](https://img.shields.io/cocoapods/p/LPDTableViewKit.svg?style=flat)](http://cocoapods.org/pods/LPDTableViewKit)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

对ReactiveCocoa足够了解，也可以参阅[图解ReactiveCocoa基本函数](http://www.jianshu.com/p/38d39923ee81)

## Installation

LPDTableViewKit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "LPDTableViewKit"
```

## Author

foxsofter, foxsofter@gmail.com

## License

LPDTableViewKit is available under the MIT license. See the LICENSE file for more info.

##UITableView改造之路

**Cocoa Touch Framework**无疑是一个很好的框架，特别是对动画的支持，在我接触过的框架中可能是最好的（当然我接触的框架可能比较少），但是就UITableView来说确实存在很多吐槽点，从我个人理解的角度做些分析，尝试去解决这些吐槽点，并给到的解决方案。
## UITableView枚举滥用

枚举从来都是为了可扩展而存在的，UITableView中对UITableViewStyle的使用堪称滥用，先看看这个枚举的定义，枚举项的命名不够直观，源码的注释也得不到有效信息，

```objective-c
typedef NS_ENUM(NSInteger, UITableViewStyle) {
    UITableViewStylePlain,          // regular table view
    UITableViewStyleGrouped         // preferences style table view
};
```

再看看如下文档的说明，基本明确了设计者的本意，UITableViewStyle想要区分的是页眉或页脚（section headers or footers）是否浮动，接下来做个剖析：

```
case plain
A plain table view. Any section headers or footers are displayed as inline separators and float when the table view is scrolled.
case grouped
A table view whose sections present distinct groups of rows. The section headers and footers do not float.
```

UITableView的初始化函数

```objective-c
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style; // must specify style at creation. -initWithFrame: calls this with UITableViewStylePlain
```

- UITableViewStyle作为初始化函数的参数的不合理性，大多数的UIView及其子类都是一样风格的初始化函数，到了UITableView这里就显得有点另类，设计者将 UITableViewStyle放到初始化函数中作为参数，无非就是不希望style在UITableView初始化之后被改变，可能原因是UITableView滑动的过程中style被改变了，不管之前是否存在浮动的页眉或页脚，改变之后对UI的呈现可能是比较突兀的，另外这种变更可能并没有实际意义；
- UITableViewStyle的存在不合理，当一个枚举只存在两个选项时，很多时候会考虑使用BOOL来表示，可读性也不差，比如这里用isSectionGrouped，可能时不需要看注视或者文档就可以理解了；
- UITableViewStylePlain的命名不合理，我们知道UITableView总是会分section，
  Plain从其语义和StoryBoard默认值的显示可以联想UITableViewStylePlain可能是想表示只有一个section的情况，那么所谓的页眉或页脚是否浮动其实就没有太大意义，如果页眉或页脚不需要浮动其实就是一个Cell了，因为最终效果都是一样的，反过来假设需要多个section，但是页眉或页脚都不需要浮动，那么这些页眉或页脚其实用Cell来表示是不是更好呢！

综上得出结论：UITableViewStyle是不该用。

## UITableViewCell枚举乱用

UITableViewCell存在好几个枚举的乱用，乱用表示不该用的时候用了。

### UITableViewCellStyle的乱用

```objective-c
typedef NS_ENUM(NSInteger, UITableViewCellStyle) {
    UITableViewCellStyleDefault,	// Simple cell with text label and optional image view (behavior of UITableViewCell in iPhoneOS 2.x)
    UITableViewCellStyleValue1,		// Left aligned label on left and right aligned label on right with blue text (Used in Settings)
    UITableViewCellStyleValue2,		// Right aligned label on left with blue text and left aligned label on right (Used in Phone/Contacts)
    UITableViewCellStyleSubtitle	// Left aligned label on top and left aligned label on bottom with gray text (Used in iPod).
};
```

UITableViewCell的初始化方法中同样也带上了UITableViewCellStyle，先看代码

```objective-c
// Designated initializer.  If the cell can be reused, you must pass in a reuse identifier.  You should use the same reuse identifier for all cells of the same form.  
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier;
```

如果说UITableView设计者觉得就只存在两种style，那么UITableViewCell设计中加入UITableViewCellStyle就显得完全是乱用了。一样的道理，枚举从来就不是为了扩展而存在，UITableViewCell做为cell的基类，扩展是必须的，不可能所有的cell都长的跟UITableViewCellStyle中定义的几个枚举项所分类的完全一样，所以这个设计是有多恶心啊。

再看看UITableViewCellStyle的各个枚举项的命名，简直是残暴啊，UITableViewCellStyleValue1，UITableViewCellStyleValue2这些是什么鬼哦，再看看注释，分别说明Used in Settings和Used in Phone/Contacts，这就很明显了，这些实现完全就是系统组件用到了这样的实现，然后直接做为api开放出来的，并没有做很好的抽象，在初始化函数中加入UITableViewCellStyle，污染了初始化函数，限制了扩展，每每在写一个UITableViewCell的子类时，总是有一种莫名的哀伤，UITableViewCellStyle做为参数存在唯一的作用就是多写了点代码，然后没有任何意义。这些cell style所表示的cell完全应该通过子类化来实现的，所以UITableViewCellStyle的乱用是有点惨不忍睹的。

### UITableViewCellSeparatorStyle的乱用

```objective-c
typedef NS_ENUM(NSInteger, UITableViewCellSeparatorStyle) {
    UITableViewCellSeparatorStyleNone,
    UITableViewCellSeparatorStyleSingleLine,
    UITableViewCellSeparatorStyleSingleLineEtched   // This separator style is only supported for grouped style table views currently
};
```

怎么说也不应该存在这样一个枚举，CellSeparatorStyle这里针对不同的UITableViewStyle而设计的，不管是何种style，应该只需要isShowCellSeparatorLine这样一个BOOL值表示是否需要显示边框，如果是UITableViewStyleGrouped这种style，可能需要额外的一个isCellSeparatorLineEtched，如果根据前面的假设，页眉或页脚都是默认浮动的话，这样设计是很合理的。

当一个枚举各项的命名过于诡异时，这个枚举的存在实际上是要好好考虑下的，所以UITableViewCellSeparatorStyle也是典型的乱用。

### UITableViewCell对以下枚举的使用也是有待商榷的

```objective-c
typedef NS_ENUM(NSInteger, UITableViewCellSelectionStyle) {
    UITableViewCellSelectionStyleNone,
    UITableViewCellSelectionStyleBlue,
    UITableViewCellSelectionStyleGray,
    UITableViewCellSelectionStyleDefault NS_ENUM_AVAILABLE_IOS(7_0)
};
```

UITableViewCellSelectionStyle想表示cell选中的样式，这里大概是通过这种方式来提高几种默认值，因为CellSelectionStyle还是可以定制的,但是UITableViewCellSelectionStyleDefault放在最后UITableViewCellSelectionStyleNone放在最开始，到底谁是default哦；

```objective-c
typedef NS_ENUM(NSInteger, UITableViewCellFocusStyle) {
    UITableViewCellFocusStyleDefault,
    UITableViewCellFocusStyleCustom
} NS_ENUM_AVAILABLE_IOS(9_0);
```

UITableViewCellFocusStyle这个枚举的存在难道仅仅是为了无病呻吟吗？

## UITableView委托乱用

UITableViewDelegate，UITableViewDataSource，包括刚引入的UITableViewDataSourcePrefetching，这几个delegate的设计好像是缺少了些设计，更像是为了解决问题而写代码，作为一个基础框架，实在是不可取的。

### UITableViewDelegate设计之重

```objective-c
// Display customization

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section NS_AVAILABLE_IOS(6_0);
- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section NS_AVAILABLE_IOS(6_0);
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath NS_AVAILABLE_IOS(6_0);
- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section NS_AVAILABLE_IOS(6_0);
- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section NS_AVAILABLE_IOS(6_0);
```

这几个委托函数，都是与Cell、页眉、页脚相关的，但是全都集中在UITableViewDelegate这个委托中，且命名都是类似，**当一个protocol在定义时存在过多的@optional委托函数时，这个protocol的设计本身就是不合理的，应该拆分成更细的protocol，我们应该时在必要的时候选择相应的protocol，而不是实现存在的@optional委托函数**，然后UITableViewDelegate这个protocol本身所有的委托函数都是@optional，这是真的不合理，如果是我们来设计Cell、页眉、页脚实际上都是应该UIView，且存在诸多共同点（参考UICollectionView的设计，Cell、页眉、页脚就存在一个共同的基类UICollectionReusableView），应该设计一个UIReusableView，（UICollectionReusableView也可以不需要了）其中存在如下方法，这些方法可以在子类中重写

```objective-c
- (void)willAppear;
- (void)didAppear;
- (void)willDisappear;
- (void)didDisappear
```

且应该设计一个UIReusableViewDelegate，其包括如下委托函数

```objective-c
- (void)willAppear:(UIReusableView*)reusableView;
- (void)didAppear:(UIReusableView*)reusableView;
- (void)willDisappear:(UIReusableView*)reusableView;
- (void)didDisappear:(UIReusableView*)reusableView;
```

UIReusableView存在UIReusableViewDelegate的一个delegate，前面所提到的那六个委托函数，实际上应该在Cell、页眉、页脚各自需要的时候实现UIReusableViewDelegate。

综上，UITableViewDelegate实际上是太重了。

### UITableViewDelegate职责之乱

下面这些委托函数，实际上应该存在UITableViewDataSource中。页眉、页脚的数据源跟cell的数据源应该是平等的存在，不应该是说不常用了，我就放到UITableViewDelegate中，本来就应该放在UITableViewDataSource，不必须用的可以optional修饰下也还说得过去。

```objective-c
// Variable height support

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;

// Use the estimatedHeight methods to quickly calcuate guessed values which will allow for fast load times of the table.
// If these methods are implemented, the above -tableView:heightForXXX calls will be deferred until views are ready to be displayed, so more expensive logic can be placed there.
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(7_0);
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section NS_AVAILABLE_IOS(7_0);
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section NS_AVAILABLE_IOS(7_0);

// Section header & footer information. Views are preferred over title should you decide to provide both

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;   // custom view for header. will be adjusted to default or specified header height
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;   // custom view for footer. will be adjusted to default or specified footer height
```

### UITableViewDataSource设计之重

经过前面的梳理，那么UITableViewDataSource中应该包括以下这些函数

```objective-c
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section;
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;

- (nullable NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section;
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section;
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
……
```

跟前面提到UITableViewDelegate设计之重一个道理，Cell、页眉、页脚的DataSource也是应该分开的，在需要的时候实现对应的DataSource，需要定义额外的一个枚举UIReusableViewType

```objective-c
typedef NS_ENUM(NSInteger, UIReusableViewType) {
    UIReusableViewTypeNone,
    UIReusableViewTypeHeader,
    UIReusableViewTypeFooter
};
```

然后对页眉、页脚就有UIReusableViewDataSource，其中的委托函数如下：

```objective-c
- (nullable NSString *)reusableView:(UIReusableView*)reusableView reusableViewType:(UIReusableViewType)reusableViewType titleInSection:(NSInteger)section;
- (nullable UIView *)reusableView:(UIReusableView*)reusableViewreusableViewType:(UIReusableViewType)reusableViewType viewInSection:(NSInteger)section;
- (CGFloat)reusableView:(UIReusableView*)reusableView reusableViewType:(UIReusableViewType)reusableViewType estimatedHeightInSection:(NSInteger)section;
```

单独的针对cell，有UITableViewCellDataSource，其中的委托函数如下：

```objective-c
- (NSInteger)numberOfSections;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath;
```

至于UITableViewDataSourcePrefetching就不应该出现，为了优化滚动帧率，拆东墙补西墙之举。从开发者的角度，最简单的做法就是把整个的数据源给到，剩下的就应该是UITableView自身去实现了，数据都有了，想要什么预加载都是框架自身的事情了，减少对开发者的依赖，更是减少api的耦合度，对外暴露的接口越多越不好。

## 改造之路在何方？

前面在吐槽的时候，每每会给出自认为更合理的设计，然而并没有什么卵用，既有代码是无法修改的，那改造之路又在何方呢？不能改变既有代码，那么只能是将这么东西尽可能的封装起来，Objective-C语言还提供了一个蛮有意思的编译期常量**NS_UNAVAILABLE**，可以在编译期禁用父类的方法，算是不完美中的完全吧，我们可以禁用掉一些不合理的类成员，来达到一个比较好的封装效果。

### UITableView枚举滥用的解决

UITableView可以禁用被枚举污染的初始化函数，重写默认的initWithFrame初始化函数并默认设style为UITableViewStyleGrouped，参考类 [LPDTableView](https://github.com/LPD-iOS/lpd-tableview-kit/blob/master/LPDTableViewKit/Classes/LPDTableView.h)暂时并没有重写初始化函数，目前认为无伤大雅。

### UITableViewCell枚举乱用的解决

UITableViewCell无法禁用被枚举污染的初始化函数，因为重用时会调用到，参考类 [LPDTableViewCell](https://github.com/LPD-iOS/lpd-tableview-kit/blob/master/LPDTableViewKit/Classes/LPDTableViewCell.h)，选择无视UITableViewCellStyle，并将已存在的几种cellStyle都扩展成对应的子类，LPDTableViewDefaultCell，LPDTableViewValue1Cell，LPDTableViewValue2Cell，LPDTableViewSubtitleCell命名还是保留一致，毕竟大家都已经习惯了这种丑。

### UITableView委托乱用的解决

既然无法改造既有的UITableView，可以从另外一个侧面来解决。

#### UITableView如何数据驱动

引入MVVM的思想，为UITableView添加对应的ViewModel，有了ViewModel，则可以引入数据驱动的方式，当我们需要为Cell、页眉、页脚提供DataSource时，只需要调用[LPDTableViewModelProtocl](https://github.com/LPD-iOS/lpd-tableview-kit/blob/master/LPDTableViewKit/Classes/LPDTableViewModelProtocol.h)中的方法就好了，接口的粒度已经比较细了，但可能不是最合理的组合，相关的函数都在下面：

```objective-c
- (nullable NSIndexPath *)indexPathForCellViewModel:(__kindof id<LPDTableCellViewModelProtocol>)cellViewModel;

- (nullable __kindof id<LPDTableCellViewModelProtocol>)cellViewModelFromIndexPath:(NSIndexPath *)indexPath;

- (NSInteger)sectionIndexForHeaderViewModel:(__kindof id<LPDTableHeaderFooterViewModelProtocol>)headerViewModel;

- (nullable __kindof id<LPDTableHeaderFooterViewModelProtocol>)headerViewModelFromSection:(NSInteger)sectionIndex;

- (NSInteger)sectionIndexForFooterViewModel:(__kindof id<LPDTableHeaderFooterViewModelProtocol>)footerViewModel;

- (nullable __kindof id<LPDTableHeaderFooterViewModelProtocol>)footerViewModelFromSection:(NSInteger)sectionIndex;

- (void)addCellViewModel:(__kindof id<LPDTableCellViewModelProtocol>)cellViewModel;

- (void)addCellViewModel:(__kindof id<LPDTableCellViewModelProtocol>)cellViewModel
        withRowAnimation:(UITableViewRowAnimation)animation;

- (void)addCellViewModel:(__kindof id<LPDTableCellViewModelProtocol>)cellViewModel toSection:(NSUInteger)sectionIndex;

- (void)addCellViewModel:(__kindof id<LPDTableCellViewModelProtocol>)cellViewModel
               toSection:(NSUInteger)sectionIndex
        withRowAnimation:(UITableViewRowAnimation)animation;

- (void)addCellViewModels:(NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)cellViewModels;

- (void)addCellViewModels:(NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)cellViewModels
         withRowAnimation:(UITableViewRowAnimation)animation;

- (void)addCellViewModels:(NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)cellViewModels
                toSection:(NSUInteger)sectionIndex;

- (void)addCellViewModels:(NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)cellViewModels
                toSection:(NSUInteger)sectionIndex
         withRowAnimation:(UITableViewRowAnimation)animation;

- (void)insertCellViewModel:(__kindof id<LPDTableCellViewModelProtocol>)cellViewModel atIndex:(NSUInteger)index;

- (void)insertCellViewModel:(__kindof id<LPDTableCellViewModelProtocol>)cellViewModel
                    atIndex:(NSUInteger)index
           withRowAnimation:(UITableViewRowAnimation)animation;

- (void)insertCellViewModel:(__kindof id<LPDTableCellViewModelProtocol>)cellViewModel
                    atIndex:(NSUInteger)index
                  inSection:(NSUInteger)sectionIndex;

- (void)insertCellViewModel:(__kindof id<LPDTableCellViewModelProtocol>)cellViewModel
                    atIndex:(NSUInteger)index
                  inSection:(NSUInteger)sectionIndex
           withRowAnimation:(UITableViewRowAnimation)animation;

- (void)insertCellViewModels:(NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)cellViewModels
                     atIndex:(NSUInteger)index;

- (void)insertCellViewModels:(NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)cellViewModels
                     atIndex:(NSUInteger)index
            withRowAnimation:(UITableViewRowAnimation)animation;

- (void)insertCellViewModels:(NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)cellViewModels
                     atIndex:(NSUInteger)index
                   inSection:(NSUInteger)sectionIndex;

- (void)insertCellViewModels:(NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)cellViewModels
                     atIndex:(NSUInteger)index
               withAnimation:(UITableViewRowAnimation)animation;

- (void)insertCellViewModels:(NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)cellViewModels
                     atIndex:(NSUInteger)index
                   inSection:(NSUInteger)sectionIndex
            withRowAnimation:(UITableViewRowAnimation)animation;

- (void)reloadCellViewModelAtIndex:(NSUInteger)index inSection:(NSInteger)sectionIndex;

- (void)reloadCellViewModelAtIndex:(NSUInteger)index
                         inSection:(NSInteger)sectionIndex
                  withRowAnimation:(UITableViewRowAnimation)animation;

- (void)reloadCellViewModelsAtRange:(NSRange)range inSection:(NSInteger)sectionIndex;

- (void)reloadCellViewModelsAtRange:(NSRange)range
                          inSection:(NSInteger)sectionIndex
                   withRowAnimation:(UITableViewRowAnimation)animation;

- (void)removeLastCellViewModel;

- (void)removeLastCellViewModelWithRowAnimation:(UITableViewRowAnimation)animation;

- (void)removeLastCellViewModelFromSection:(NSUInteger)sectionIndex;

- (void)removeLastCellViewModelFromSection:(NSUInteger)sectionIndex withRowAnimation:(UITableViewRowAnimation)animation;

- (void)removeCellViewModelAtIndex:(NSUInteger)index;

- (void)removeCellViewModelAtIndex:(NSUInteger)index withRowAnimation:(UITableViewRowAnimation)animation;

- (void)removeCellViewModelAtIndex:(NSUInteger)index fromSection:(NSUInteger)sectionIndex;

- (void)removeCellViewModelAtIndex:(NSUInteger)index
                       fromSection:(NSUInteger)sectionIndex
                  withRowAnimation:(UITableViewRowAnimation)animation;

- (void)replaceCellViewModels:(NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)cellViewModels
                    fromIndex:(NSUInteger)index;

- (void)replaceCellViewModels:(NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)cellViewModels
                    fromIndex:(NSUInteger)index
             withRowAnimation:(UITableViewRowAnimation)animation;

- (void)replaceCellViewModels:(NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)cellViewModels
                    fromIndex:(NSUInteger)index
                    inSection:(NSUInteger)sectionIndex;

- (void)replaceCellViewModels:(NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)cellViewModels
                    fromIndex:(NSUInteger)index
                    inSection:(NSUInteger)sectionIndex
             withRowAnimation:(UITableViewRowAnimation)animation;

- (void)addSectionViewModel:(id<LPDTableSectionViewModelProtocol>)sectionViewModel;

- (void)addSectionViewModel:(id<LPDTableSectionViewModelProtocol>)sectionViewModel
           withRowAnimation:(UITableViewRowAnimation)animation;

- (void)addSectionViewModel:(id<LPDTableSectionViewModelProtocol>)sectionViewModel
         withCellViewModels:(NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)cellViewModels;

- (void)addSectionViewModel:(id<LPDTableSectionViewModelProtocol>)sectionViewModel
         withCellViewModels:(NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)cellViewModels
           withRowAnimation:(UITableViewRowAnimation)animation;

- (void)insertSectionViewModel:(id<LPDTableSectionViewModelProtocol>)sectionViewModel atIndex:(NSUInteger)index;

- (void)insertSectionViewModel:(id<LPDTableSectionViewModelProtocol>)sectionViewModel
                       atIndex:(NSUInteger)index
              withRowAnimation:(UITableViewRowAnimation)animation;

- (void)insertSectionViewModel:(id<LPDTableSectionViewModelProtocol>)sectionViewModel
            withCellViewModels:(NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)cellViewModels
                       atIndex:(NSUInteger)index;

- (void)insertSectionViewModel:(id<LPDTableSectionViewModelProtocol>)sectionViewModel
            withCellViewModels:(NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)cellViewModels
                       atIndex:(NSUInteger)index
              withRowAnimation:(UITableViewRowAnimation)animation;

- (void)reloadSectionAtIndex:(NSUInteger)index;

- (void)reloadSectionAtIndex:(NSUInteger)index withRowAnimation:(UITableViewRowAnimation)animation;

- (void)reloadSectionsAtRange:(NSRange)range;

- (void)reloadSectionsAtRange:(NSRange)range withRowAnimation:(UITableViewRowAnimation)animation;

- (void)removeSectionAtIndex:(NSUInteger)index;

- (void)removeAllSections;

- (void)removeSectionAtIndex:(NSUInteger)index withRowAnimation:(UITableViewRowAnimation)animation;

- (void)removeAllSectionsWithRowAnimation:(UITableViewRowAnimation)animation;

- (void)replaceSectionWithCellViewModels:(NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)cellViewModels;

- (void)replaceSectionWithCellViewModels:(NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)cellViewModels
                        withRowAnimation:(UITableViewRowAnimation)animation;

- (void)replaceSectionWithCellViewModels:(NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)cellViewModels
                               atSection:(NSUInteger)sectionIndex;

- (void)replaceSectionWithCellViewModels:(NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)cellViewModels
                               atSection:(NSUInteger)sectionIndex
                        withRowAnimation:(UITableViewRowAnimation)animation;
```

#### UITableView委托转RACSignal

引入ReactiveCocoa中的RACSignal，将UITableViewDelegate中的委函数都转成信号，当我们需要实现某一个委托函数，只需要订阅对应的RACSignal即可，不订阅没有任何副作用。

```objective-c
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

#### Cell、页眉、页脚也存在相应的ViewModel

Cell、页眉、页脚跟其ViewModel之间需要遵守约定好的命名规则，如此会自动匹配。另外Cell、页眉、页脚默认都是重用的，同一类型reuseIdentifier一样，重用相关的函数就都在 [LPDTableViewFactory](https://github.com/LPD-iOS/lpd-tableview-kit/blob/master/LPDTableViewKit/Classes/LPDTableViewFactory.h)。这个类中了当我们关心DataSource或者Delegate时，我们只需要跟对应的ViewModel交互即可，将Cell、页眉、页脚解耦合。

#### LPDTableSectionViewModelProtocol

这个protocol的实现类LPDTableSectionViewModel，只是在ViewModel层抽象出来，这样才好完善ViewModel层的实现，并不存在对应的SectionView。

#### 关于height

cell，header，footer的viewmodel中都有对应的height字段，需要根据viewmodel的model字段在bindingTo:viewModel函数中设置height值，可以针对model做height的缓存。

## 改造之后的例子

### 加载tableview的数据

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

### 添加一个cell

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

### 批量添加cell

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

### 删除一个cell

```Objective-c
        [self.tableViewModel removeCellViewModelAtIndex:0 withRowAnimation:UITableViewRowAnimationRight];
```

### Cell的didSelectRowAtIndexPathSignal

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

具体请下载[lpd-tableview-kit](https://github.com/LPD-iOS/lpd-tableview-kit)，看看其中的demo。
