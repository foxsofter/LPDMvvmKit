#UITableView改造之路

cocoa touch framework无疑是一个很好的框架，特别是对动画的支持，在我接触过的框架中可能是最好的（当然我接触的框架可能比较少），但是UITableView确实存在很多吐槽点，从我个人理解的角度做些分析。

###UITableView初始化方法之丑

UITableView的初始化方法中带上了UITableViewStyle，先看代码

```objective-c
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style NS_DESIGNATED_INITIALIZER; // must specify style at creation. -initWithFrame: calls this with UITableViewStylePlain
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;
```


```objective-c
typedef NS_ENUM(NSInteger, UITableViewStyle) {
    UITableViewStylePlain,          // regular table view
    UITableViewStyleGrouped         // preferences style table view
};
```

可能设计者觉得UITableView无非就是这两种，不过从注释没能完全理解什么意思，查找文档有如下说明：
```
case plain
A plain table view. Any section headers or footers are displayed as inline separators and float when the table view is scrolled.
case grouped
A table view whose sections present distinct groups of rows. The section headers and footers do not float.
```
大概表示区别在于页眉和页脚是否浮动，至此大概了解设计者的本意了，因为实现上可能不好动态切换两种style，注释中写了：must specify style at creation，所以将UITableViewStyle做为参数加入到初始化函数中，且默认为UITableViewStylePlain。

真的需要UITableViewStylePlain吗？

假设不需要页眉和页脚浮动，然而提供这个页眉和页脚的意义何在，不如抽象成cell，这个cell可能不同于其它大部分的cell，仅此而已，这样反过来所有的页眉和页脚都是默认可以浮动的，确实是不需要UITableViewStylePlain，更不需要UITableViewStyle的存在，所以何必存在着么特殊的一个初始化方法呢？


###UITableViewCell初始化方法之丑

UITableViewCell的初始化方法中同样也带上了UITableViewCellStyle，先看代码

```objective-c
// Designated initializer.  If the cell can be reused, you must pass in a reuse identifier.  You should use the same reuse identifier for all cells of the same form.  
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier NS_AVAILABLE_IOS(3_0) NS_DESIGNATED_INITIALIZER;
```
如果说UITableView设计者觉得就是存在两种style，那么UITableViewCell设计中加入UITableViewCellStyle就显得很不可取了，UITableViewCell的扩展是必须的，但是加入UITableViewCellStyle后，明显就是不让扩展嘛，枚举从来都不是为了可扩展而存在，所以这个设计是有多恶心啊，再看看UITableViewCellStyle的定义吧，命名就让人抓狂，UITableViewCellStyleValue1，UITableViewCellStyleValue2这些是什么鬼哦，再看看注释，分别说明Used in Settings和Used in Phone/Contacts，这就很明显了，这些实现完全就是系统组件用到了这样的实现，然后直接做为api开放出来的，并没有做很好的抽象，在初始化函数中加入UITableViewCellStyle，污染了初始化函数，限制了扩展，每每在写一个UITableViewCell的子类时，总是有一种莫名的哀伤，UITableViewCellStyle做为参数存在唯一的作用就是多写了点代码，然后没有任何意义。

```objective-c
typedef NS_ENUM(NSInteger, UITableViewCellStyle) {
    UITableViewCellStyleDefault,	// Simple cell with text label and optional image view (behavior of UITableViewCell in iPhoneOS 2.x)
    UITableViewCellStyleValue1,		// Left aligned label on left and right aligned label on right with blue text (Used in Settings)
    UITableViewCellStyleValue2,		// Right aligned label on left with blue text and left aligned label on right (Used in Phone/Contacts)
    UITableViewCellStyleSubtitle	// Left aligned label on top and left aligned label on bottom with gray text (Used in iPod).
};             // available in iPhone OS 3.0
```

类似的在UITableViewCell中还存在很多枚举的使用，看看这些代码

```objective-c
typedef NS_ENUM(NSInteger, UITableViewCellSeparatorStyle) {
    UITableViewCellSeparatorStyleNone,
    UITableViewCellSeparatorStyleSingleLine,
    UITableViewCellSeparatorStyleSingleLineEtched   // This separator style is only supported for grouped style table views currently
} __TVOS_PROHIBITED;

typedef NS_ENUM(NSInteger, UITableViewCellSelectionStyle) {
    UITableViewCellSelectionStyleNone,
    UITableViewCellSelectionStyleBlue,
    UITableViewCellSelectionStyleGray,
    UITableViewCellSelectionStyleDefault NS_ENUM_AVAILABLE_IOS(7_0)
};

typedef NS_ENUM(NSInteger, UITableViewCellFocusStyle) {
    UITableViewCellFocusStyleDefault,
    UITableViewCellFocusStyleCustom
} NS_ENUM_AVAILABLE_IOS(9_0);

typedef NS_ENUM(NSInteger, UITableViewCellEditingStyle) {
    UITableViewCellEditingStyleNone,
    UITableViewCellEditingStyleDelete,
    UITableViewCellEditingStyleInsert
};

typedef NS_ENUM(NSInteger, UITableViewCellAccessoryType) {
    UITableViewCellAccessoryNone,                                                      // don't show any accessory view
    UITableViewCellAccessoryDisclosureIndicator,                                       // regular chevron. doesn't track
    UITableViewCellAccessoryDetailDisclosureButton __TVOS_PROHIBITED,                 // info button w/ chevron. tracks
    UITableViewCellAccessoryCheckmark,                                                 // checkmark. doesn't track
    UITableViewCellAccessoryDetailButton NS_ENUM_AVAILABLE_IOS(7_0)  __TVOS_PROHIBITED // info button. tracks
};
```

UITableViewCellSeparatorStyle, UITableViewCellSelectionStyle, UITableViewCellFocusStyle, UITableViewCellEditingStyle, UITableViewCellAccessoryType 这些枚举都存在一些共同点，为了设计而设计，也许设计者的初衷就是限死这些扩展性，但是很明显没有任何效果，该扩展的还是得扩展，cell不可能就这么几个样式。

###UITableView的几个delegate之乱

UITableViewDelegate，UITableViewDataSource，包括刚引入的UITableViewDataSourcePrefetching，这几个delegate的设计好像是缺少了些面向对象的思想，更像是解决问题的套路，整个框架皆如此，那就如此的意思更多点。
```objective-c
// Display customization

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section NS_AVAILABLE_IOS(6_0);
- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section NS_AVAILABLE_IOS(6_0);
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath NS_AVAILABLE_IOS(6_0);
- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section NS_AVAILABLE_IOS(6_0);
- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section NS_AVAILABLE_IOS(6_0);
```
看看上面这些代码，其实都是跟cell，header，footer相关的，如果将其抽象到UIView这一层某种程度上也是合理的，如下

```objective-c
- (void)willDisplay;
- (void)didEndDisplaying;
```

代码是不是更简单，至于UIView这一层，其实目前是在view controller中存在对应的函数的

```objective-c
- (void)viewWillAppear:(BOOL)animated;    // Called when the view is about to made visible. Default does nothing
- (void)viewDidAppear:(BOOL)animated;     // Called when the view has been fully transitioned onto the screen. Default does nothing
- (void)viewWillDisappear:(BOOL)animated; // Called when the view is dismissed, covered or otherwise hidden. Default does nothing
- (void)viewDidDisappear:(BOOL)animated;  // Called after the view was dismissed, covered or otherwise hidden. Default does nothing
```
但是并不是说UIview层就不应该存在对应的函数，所以更好的版本可能是在UIView中有如下函数
```objective-c
- (void)willAppear;
- (void)didAppear;
- (void)willDisappear;
- (void)didDisappear
```
再看看下面这些函数，也是存在于UITableViewDelegate中的
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

这些是存在于UITableViewDelegate这个delegate中的，然后谁再看看UITableViewDataSource的函数

```objective-c
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
```

这么函数划分大概是根据用户的使用频次来的吧，觉得大部分场景不需要header和footer，然后高频的rows相关的放到UITableViewDataSource中，难道header和footer就不是data source嘛，为什么单独cell放到UITableViewDataSource这个delegate中来呢？看的人莫名其妙有没有，更甚的是将 heightForRowAtIndexPath 放到UITableViewDelegate中，诶，该说什么呢。。。。
还有，既然将header和footer相关的函数放到UITableViewDelegate中，下面这两个

```objective-c
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;    // fixed font style. use custom view (UILabel) if you want something different
- (nullable NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section;
```

为什么又放到UITableViewDataSource中呢，乱就一个字。。。

先打住，假设设计者的本意是将data source跟相关的一些operations分开，那么其实也是蛮合理的，那么UITableViewDataSource中只留下以下这些函数
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
至于UITableViewDataSourcePrefetching，不再说什么了，前面就有estimatedHeightForXXX，时序啊，开发者严重不友好的存在，从开发者的角度，最简单的做法就是把整个的数据源给到，剩下的就应该是UItableView自身去实现了，数据都有了，想要什么预加载都是框架自身的事情了，减少对开发者的依赖，更是减少api的耦合度，对外暴露的接口越多越不好。
如果从面向对象的角度，上面这些都应该是每个对象自身去实现就好了，比如cell，header，footer的height的获取。不吐槽了，想想如何做些改造吧。


此处略去一万个思考点。。。。


###改造的成果
先把我所做尝试的成果说下，都在在我开源出来的一个库中[lpd-mvvm-kit](https://github.com/foxsofter/lpd-mvvm-kit)。以上几个吐槽点中，UITableView初始化方法之丑这个我只能默默的接受了，因为在我的解决方案里面，也不需要对UITableView进行更多的扩展，主要的扩展还是在header，footer，cell这个层面进行的；UITableViewCell初始化方法之丑这个我选择了无视UITableViewCellStyle，将既有的几个UITableViewCellStyle扩展成对应的子类LPDTableViewDefaultCell，LPDTableViewValue1Cell，LPDTableViewValue2Cell，LPDTableViewSubtitleCell命名还是保留一致，毕竟大家都已经习惯了这种丑；
UITableView的几个delegate之乱这个问题的解决才是重点，为了解决这个问题，引入了MVVM的思想，以达成数据驱动的效果，注意的点如下

* 引入MVVM的思想，tableview，header，footer，cell都有相对应的viewmodel，其中header，footer，cell根据约定好的命名规则，自动匹配；
* 所有的cell，header，footer默认是重用的，同一类型reuseIdentifier一样，重用相关的函数就都在 [LPDTableViewFactory](https://github.com/foxsofter/lpd-mvvm-kit/blob/master/Classes/Mvvm/ViewModels/LPDTableViewFactory.h)这个类中了；
* 所有的cell在初始化时默认传入UITableViewCellStyleDefault，当然这个不重要了，因为不可能去调用初始化方法了；
* LPDTableSectionViewModelProtocol等相关的LPDTableSectionViewModel实际上并没有对应的sectionview，只是做为ViewModel的一个抽象；
* 所有的cell，header，footer的viewmodel中都有对应的height字段，需要根据viewmodel的model字段在bindingTo:viewModel函数中设置height值，可以针对model做height的缓存；
* 写好cell，header，footer以及相对应的viewmodel之后，通过LPDTableViewModelProtocol所提供的方法增删相对应的viewmodel就可以完成tableview的数据源变更，没有delegate之痛了。

[LPDTableViewModelProtocol](https://github.com/foxsofter/lpd-mvvm-kit/blob/master/Classes/Mvvm/ViewModels/LPDTableViewModelProtocol.h) 这个protocol是重头，来看看，接口的粒度已经比较细了，但可能不是最合理的组合，要实现一个UITableView，现在只需要关心这个protocol下的接口就好了，没有delegate了，因为已经不需要关心了。

数据源相关的都在下面这些函数中了，

```objective-c
- (nullable NSIndexPath *)indexPathForCellViewModel:(__kindof id<LPDTableCellViewModelProtocol>)cellViewModel;

- (nullable __kindof id<LPDTableCellViewModelProtocol>)cellViewModelFromIndexPath:(NSIndexPath *)indexPath;

- (NSInteger)sectionIndexForHeaderViewModel:(__kindof id<LPDTableHeaderFooterViewModelProtocol>)headerViewModel;

- (nullable __kindof id<LPDTableHeaderFooterViewModelProtocol>)headerViewModelFromSection:(NSInteger)sectionIndex;

- (NSInteger)sectionIndexForFooterViewModel:(__kindof id<LPDTableHeaderFooterViewModelProtocol>)footerViewModel;

- (nullable __kindof id<LPDTableHeaderFooterViewModelProtocol>)footerViewModelFromSection:(NSInteger)sectionIndex;

/**
 *  @brief 添加cellViewModel到最后一个section，如果不存在section默认添加一个section
 *
 *  @param cellViewModel 同一个cellViewModel不可添加多次
 */
- (void)addCellViewModel:(__kindof id<LPDTableCellViewModelProtocol>)cellViewModel;

/**
 *  @brief 添加cellViewModel到最后一个section，如果不存在section默认添加一个section
 *
 *  @param cellViewModel 同一个cellViewModel不可添加多次
 *  @param animation      animation
 */
- (void)addCellViewModel:(__kindof id<LPDTableCellViewModelProtocol>)cellViewModel
        withRowAnimation:(UITableViewRowAnimation)animation;

/**
 *  @brief 添加cellViewModel
 *
 *  @param cellViewModel 同一个cellViewModel不可添加多次
 *  @param sectionIndex   sectionIndex
 */
- (void)addCellViewModel:(__kindof id<LPDTableCellViewModelProtocol>)cellViewModel toSection:(NSUInteger)sectionIndex;

/**
 *  @brief 添加cellViewModel
 *
 *  @param cellViewModel 同一个cellViewModel不可添加多次
 *  @param sectionIndex   sectionIndex
 *  @param animation      animation
 */
- (void)addCellViewModel:(__kindof id<LPDTableCellViewModelProtocol>)cellViewModel
               toSection:(NSUInteger)sectionIndex
        withRowAnimation:(UITableViewRowAnimation)animation;

/**
 *  @brief 添加cellViewModels到最后一个section，如果不存在section默认添加一个section
 *
 *  @param cellViewModels 同一个cellViewModel不可添加多次
 */
- (void)addCellViewModels:(NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)cellViewModels;

/**
 *  @brief 添加cellViewModel到最后一个section，如果不存在section默认添加一个section
 *
 *  @param cellViewModels 同一个cellViewModel不可添加多次
 *  @param animation      animation
 */
- (void)addCellViewModels:(NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)cellViewModels
         withRowAnimation:(UITableViewRowAnimation)animation;

/**
 *  @brief 添加cellViewModels到最后一个section，如果不存在section默认添加一个section
 *
 *  @param cellViewModels 同一个cellViewModel不可添加多次
 *  @param sectionIndex   sectionIndex
 */
- (void)addCellViewModels:(NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)cellViewModels
                toSection:(NSUInteger)sectionIndex;

/**
 *  @brief 添加cellViewModels
 *
 *  @param cellViewModels 同一个cellViewModel不可添加多次
 *  @param sectionIndex   sectionIndex
 *  @param animation      animation
 */
- (void)addCellViewModels:(NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)cellViewModels
                toSection:(NSUInteger)sectionIndex
         withRowAnimation:(UITableViewRowAnimation)animation;

/**
 *  @brief 插入cellViewModel到最后一个section，如果不存在section默认添加一个section
 *
 *  @param cellViewModel 同一个cellViewModel不可添加多次
 *  @param index         index
 */
- (void)insertCellViewModel:(__kindof id<LPDTableCellViewModelProtocol>)cellViewModel atIndex:(NSUInteger)index;

/**
 *  @brief 插入cellViewModel到最后一个section，如果不存在section默认添加一个section
 *
 *  @param cellViewModel 同一个cellViewModel不可添加多次
 *  @param index         index
 *  @param animation     animation
 */
- (void)insertCellViewModel:(__kindof id<LPDTableCellViewModelProtocol>)cellViewModel
                    atIndex:(NSUInteger)index
           withRowAnimation:(UITableViewRowAnimation)animation;

/**
 *  @brief 插入cellViewModel
 *
 *  @param cellViewModel 同一个cellViewModel不可添加多次
 *  @param index         index
 *  @param sectionIndex  sectionIndex
 */
- (void)insertCellViewModel:(__kindof id<LPDTableCellViewModelProtocol>)cellViewModel
                    atIndex:(NSUInteger)index
                  inSection:(NSUInteger)sectionIndex;

/**
 *  @brief 插入cellViewModel
 *
 *  @param cellViewModel 同一个cellViewModel不可添加多次
 *  @param index         index
 *  @param sectionIndex  sectionIndex
 *  @param animation     animation
 */
- (void)insertCellViewModel:(__kindof id<LPDTableCellViewModelProtocol>)cellViewModel
                    atIndex:(NSUInteger)index
                  inSection:(NSUInteger)sectionIndex
           withRowAnimation:(UITableViewRowAnimation)animation;

/**
 *  @brief 插入cellViewModels到最后一个section，如果不存在section默认添加一个section
 *
 *  @param cellViewModels 同一个cellViewModel不可添加多次
 *  @param index          index
 */
- (void)insertCellViewModels:(NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)cellViewModels
                     atIndex:(NSUInteger)index;

/**
 *  @brief 插入cellViewModels到最后一个section，如果不存在section默认添加一个section
 *
 *  @param cellViewModels 同一个cellViewModel不可添加多次
 *  @param index          index
 *  @param animation      animation
 */
- (void)insertCellViewModels:(NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)cellViewModels
                     atIndex:(NSUInteger)index
            withRowAnimation:(UITableViewRowAnimation)animation;

/**
 *  @brief 插入cellViewModels
 *
 *  @param cellViewModels 同一个cellViewModel不可添加多次
 *  @param index          index
 *  @param sectionIndex   sectionIndex
 */
- (void)insertCellViewModels:(NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)cellViewModels
                     atIndex:(NSUInteger)index
                   inSection:(NSUInteger)sectionIndex;

/**
 *  @brief 插入cellViewModels
 *
 *  @param cellViewModels 同一个cellViewModel不可添加多次
 *  @param index          index
 *  @param sectionIndex   sectionIndex
 *  @param animation      animation
 */
- (void)insertCellViewModels:(NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)cellViewModels
                     atIndex:(NSUInteger)index
               withAnimation:(UITableViewRowAnimation)animation;

- (void)insertCellViewModels:(NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)cellViewModels
                     atIndex:(NSUInteger)index
                   inSection:(NSUInteger)sectionIndex
            withRowAnimation:(UITableViewRowAnimation)animation;

/**
 *  @brief 重载cellViewModel
 *
 *  @param index         index
 *  @param sectionIndex  sectionIndex
 */
- (void)reloadCellViewModelAtIndex:(NSUInteger)index inSection:(NSInteger)sectionIndex;

/**
 *  @brief 重载cellViewModel
 *
 *  @param index         index
 *  @param sectionIndex  sectionIndex
 *  @param animation     animation
 */
- (void)reloadCellViewModelAtIndex:(NSUInteger)index
                         inSection:(NSInteger)sectionIndex
                  withRowAnimation:(UITableViewRowAnimation)animation;

/**
 *  @brief 重载cellViewModels
 *
 *  @param range         range
 *  @param sectionIndex  sectionIndex
 *  @param animation     animation
 */
- (void)reloadCellViewModelsAtRange:(NSRange)range inSection:(NSInteger)sectionIndex;

/**
 *  @brief 重载cellViewModels
 *
 *  @param range         range
 *  @param sectionIndex  sectionIndex
 *  @param animation     animation
 */
- (void)reloadCellViewModelsAtRange:(NSRange)range
                          inSection:(NSInteger)sectionIndex
                   withRowAnimation:(UITableViewRowAnimation)animation;

/**
 *  @brief 移除最后一个section的最后一个cellViewModel
 */
- (void)removeLastCellViewModel;

/**
 *  @brief 移除最后一个section的最后一个cellViewModel
 */
- (void)removeLastCellViewModelWithRowAnimation:(UITableViewRowAnimation)animation;

/**
 *  @brief 移除指定section的最后一个cellViewModel
 */
- (void)removeLastCellViewModelFromSection:(NSUInteger)sectionIndex;

/**
 *  @brief 移除指定section的最后一个cellViewModel
 */
- (void)removeLastCellViewModelFromSection:(NSUInteger)sectionIndex withRowAnimation:(UITableViewRowAnimation)animation;

/**
 *  @brief 移除最后一个section的指定cellViewModel
 */
- (void)removeCellViewModelAtIndex:(NSUInteger)index;

/**
 *  @brief 移除最后一个section的指定cellViewModel
 */
- (void)removeCellViewModelAtIndex:(NSUInteger)index withRowAnimation:(UITableViewRowAnimation)animation;

/**
 *  @brief 移除指定section的指定cellViewModel
 */
- (void)removeCellViewModelAtIndex:(NSUInteger)index fromSection:(NSUInteger)sectionIndex;

/**
 *  @brief 移除指定section的指定cellViewModel
 */
- (void)removeCellViewModelAtIndex:(NSUInteger)index
                       fromSection:(NSUInteger)sectionIndex
                  withRowAnimation:(UITableViewRowAnimation)animation;

/**
 *  @brief 替换最后一个section指定的index之后的cellViewModels
 *
 *  @param cellViewModels 同一个cellViewModel不可添加多次
 *  @param index          index
 */
- (void)replaceCellViewModels:(NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)cellViewModels
                    fromIndex:(NSUInteger)index;

/**
 *  @brief 替换最后一个section指定的index之后的cellViewModels
 *
 *  @param cellViewModels 同一个cellViewModel不可添加多次
 *  @param index          index
 *  @param animation      animation
 */
- (void)replaceCellViewModels:(NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)cellViewModels
                    fromIndex:(NSUInteger)index
             withRowAnimation:(UITableViewRowAnimation)animation;

/**
 *  @brief 替换指定section指定的index之后的cellViewModels
 *
 *  @param cellViewModels 同一个cellViewModel不可添加多次
 *  @param index          index
 *  @param sectionIndex   sectionIndex
 */
- (void)replaceCellViewModels:(NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)cellViewModels
                    fromIndex:(NSUInteger)index
                    inSection:(NSUInteger)sectionIndex;

/**
 *  @brief 替换指定section指定的index之后的cellViewModels
 *
 *  @param cellViewModels 同一个cellViewModel不可添加多次
 *  @param index          index
 *  @param sectionIndex   sectionIndex
 *  @param animation      animation
 */
- (void)replaceCellViewModels:(NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)cellViewModels
                    fromIndex:(NSUInteger)index
                    inSection:(NSUInteger)sectionIndex
             withRowAnimation:(UITableViewRowAnimation)animation;

/**
 *  @brief 添加sectionViewModel
 *
 *  @param sectionViewModel 同一个sectionViewModel不可添加多次
 */
- (void)addSectionViewModel:(id<LPDTableSectionViewModelProtocol>)sectionViewModel;

/**
 *  @brief 添加sectionViewModel
 *
 *  @param sectionViewModel 同一个sectionViewModel不可添加多次
 *  @param animation        animation
 */
- (void)addSectionViewModel:(id<LPDTableSectionViewModelProtocol>)sectionViewModel
           withRowAnimation:(UITableViewRowAnimation)animation;

/**
 *  @brief 添加sectionViewModel
 *
 *  @param sectionViewModel 同一个sectionViewModel不可添加多次
 *  @param cellViewModels   同一个cellViewModel不可添加多次
 */
- (void)addSectionViewModel:(id<LPDTableSectionViewModelProtocol>)sectionViewModel
         withCellViewModels:(NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)cellViewModels;

/**
 *  @brief 添加sectionViewModel
 *
 *  @param sectionViewModel 同一个sectionViewModel不可添加多次
 *  @param cellViewModels   同一个cellViewModel不可添加多次
 *  @param animation        animation
 */
- (void)addSectionViewModel:(id<LPDTableSectionViewModelProtocol>)sectionViewModel
         withCellViewModels:(NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)cellViewModels
           withRowAnimation:(UITableViewRowAnimation)animation;

/**
 *  @brief 插入sectionViewModel
 *
 *  @param sectionViewModel 同一个sectionViewModel不可添加多次
 *  @param index            index
 */
- (void)insertSectionViewModel:(id<LPDTableSectionViewModelProtocol>)sectionViewModel atIndex:(NSUInteger)index;

/**
 *  @brief 插入sectionViewModel
 *
 *  @param sectionViewModel 同一个sectionViewModel不可添加多次
 *  @param index            index
 *  @param animation        animation
 */
- (void)insertSectionViewModel:(id<LPDTableSectionViewModelProtocol>)sectionViewModel
                       atIndex:(NSUInteger)index
              withRowAnimation:(UITableViewRowAnimation)animation;

/**
 *  @brief 插入sectionViewModel
 *
 *  @param sectionViewModel 同一个sectionViewModel不可添加多次
 *  @param cellViewModels   同一个cellViewModel不可添加多次
 *  @param index            index
 */
- (void)insertSectionViewModel:(id<LPDTableSectionViewModelProtocol>)sectionViewModel
            withCellViewModels:(NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)cellViewModels
                       atIndex:(NSUInteger)index;

/**
 *  @brief 插入sectionViewModel到指定index
 *
 *  @param sectionViewModel 同一个sectionViewModel不可添加多次
 *  @param cellViewModels   同一个cellViewModel不可添加多次
 *  @param index            index
 *  @param animation        animation
 */
- (void)insertSectionViewModel:(id<LPDTableSectionViewModelProtocol>)sectionViewModel
            withCellViewModels:(NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)cellViewModels
                       atIndex:(NSUInteger)index
              withRowAnimation:(UITableViewRowAnimation)animation;

/**
 *  @brief 重载section
 *
 *  @param index        index
 */
- (void)reloadSectionAtIndex:(NSUInteger)index;

/**
 *  @brief 重载cellViewModel
 *
 *  @param index         index
 *  @param sectionIndex  sectionIndex
 *  @param animation     animation
 */
- (void)reloadSectionAtIndex:(NSUInteger)index withRowAnimation:(UITableViewRowAnimation)animation;

/**
 *  @brief 重载cellViewModels
 *
 *  @param range         range
 *  @param sectionIndex  sectionIndex
 *  @param animation     animation
 */
- (void)reloadSectionsAtRange:(NSRange)range;

/**
 *  @brief 重载cellViewModels
 *
 *  @param range         range
 *  @param sectionIndex  sectionIndex
 *  @param animation     animation
 */
- (void)reloadSectionsAtRange:(NSRange)range withRowAnimation:(UITableViewRowAnimation)animation;

/**
 *  @brief 移除指定的section
 *
 *  @param index     index
 */
- (void)removeSectionAtIndex:(NSUInteger)index;

/**
 *  @brief 移除所有的的section
 */
- (void)removeAllSections;

/**
 *  @brief 移除指定的section
 *
 *  @param index     index
 *  @param animation animation
 */
- (void)removeSectionAtIndex:(NSUInteger)index withRowAnimation:(UITableViewRowAnimation)animation;

/**
 *  @brief 移除所有的的section
 *
 *  @param animation animation
 */
- (void)removeAllSectionsWithRowAnimation:(UITableViewRowAnimation)animation;

/**
 *  @brief 重置最后的section，替换该section下所有的cellViewModel
 *
 *  @param cellViewModels 同一个cellViewModel不可添加多次
 */
- (void)replaceSectionWithCellViewModels:(NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)cellViewModels;

/**
 *  @brief 重置最后的section，替换该section下所有的cellViewModel
 *
 *  @param cellViewModels 同一个cellViewModel不可添加多次
 *  @param animation      animation
 */
- (void)replaceSectionWithCellViewModels:(NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)cellViewModels
                        withRowAnimation:(UITableViewRowAnimation)animation;

/**
 *  @brief 重置指定的section，替换该section下所有的cellViewModel
 *
 *  @param cellViewModels 同一个cellViewModel不可添加多次
 *  @param sectionIndex   sectionIndex
 */
- (void)replaceSectionWithCellViewModels:(NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)cellViewModels
                               atSection:(NSUInteger)sectionIndex;

/**
 *  @brief 重置指定的section，替换该section下所有的cellViewModel
 *
 *  @param cellViewModels 同一个cellViewModel不可添加多次
 *  @param sectionIndex   sectionIndex
 *  @param animation      animation
 */
- (void)replaceSectionWithCellViewModels:(NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)cellViewModels
                               atSection:(NSUInteger)sectionIndex
                        withRowAnimation:(UITableViewRowAnimation)animation;
```

操作相关的接口都封装成RACSignal了，不需要每次写那么多delegate了，只需要订阅signal就好了，目前支持以下的这些
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

#####demo中的一些例子，加载tableview的数据

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

#####添加一个cell

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

#####批量添加cell
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

#####删除一个cell
```Objective-c
        [self.tableViewModel removeCellViewModelAtIndex:0 withRowAnimation:UITableViewRowAnimationRight];
```

#####cell的didSelectRowAtIndexPathSignal
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

具体请下载[lpd-mvvm-kit](https://github.com/foxsofter/lpd-mvvm-kit)，看看其中的tableview相关的demo，当然目前只能在lpd-mvvm-kit这个框架下去用。 
