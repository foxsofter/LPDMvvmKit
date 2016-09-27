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

UITableViewCellSeparatorStyle, UITableViewCellSelectionStyle, UITableViewCellFocusStyle, UITableViewCellEditingStyle, UITableViewCellAccessoryType 这些枚举都存在一些共同点，为了设计而设计，也许设计者的初衷就是限死这些扩展性，但是很明显没有任何效果，该扩展的还是得扩展，不可能我的cell就这么几个样式。

