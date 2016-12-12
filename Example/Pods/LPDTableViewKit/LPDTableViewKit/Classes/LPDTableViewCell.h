//
//  LPDTableViewCell.h
//  LPDTableViewKit
//
//  UITableViewCell的构造函数有点不完美，最主要一点就是构造函数依赖于传入的
//  UITableViewCellStyle,根据style来产生不同的cell的效果，如果需要自定义
//  子类，而又不可能扩展UITableViewCellStyle，那么子类的构造函数所带
//  的UITableViewCellStyle参数就是没有任何意义的，而UITableView对Cell的
//  复用又需要调用此默认构造函数，这样的代码真让人有点不能忍，所以我们定义的
//  LPDTableViewCell以及所有的子类都将忽略UITableViewCellStyle这个参数,
//  并将系统的四种UITableViewCellStyle都子类化.
//
//  Created by foxsofter on 16/1/3.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "LPDTableViewItemProtocol.h"
#import <UIKit/UIKit.h>

/**
 *  @brief base class of all table view cell
 */
@interface LPDTableViewCell : UITableViewCell <LPDTableViewItemProtocol>
+ (instancetype) new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
@end

/**
 *  @brief cell with style of UITableViewCellStyleDefault
 */
@interface LPDTableViewDefaultCell : LPDTableViewCell

@end

/**
 *  @brief cell with style of UITableViewCellStyleValue1
 */
@interface LPDTableViewValue1Cell : LPDTableViewCell

@end

/**
 *  @brief cell with style of UITableViewCellStyleValue2
 */
@interface LPDTableViewValue2Cell : LPDTableViewCell

@end

/**
 *  @brief cell with style of UITableViewCellStyleSubtitle
 */
@interface LPDTableViewSubtitleCell : LPDTableViewCell

@end
