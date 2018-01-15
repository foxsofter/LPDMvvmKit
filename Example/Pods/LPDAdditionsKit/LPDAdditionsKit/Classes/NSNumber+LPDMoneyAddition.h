//
//  NSNumber+LPDMoneyAddition.h
//  LPDAdditions
//
//  Created by foxsofter on 15/11/26.
//  Copyright © 2015年 foxsofter. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 */
@interface NSNumber (LPDMoneyAddition)

/**
 *  将当前金额数值转成中文繁体金额
 *  1234567890.31 <=> 壹拾貳億叁仟肆佰伍拾陸萬柒仟捌佰玖拾圓叁角壹分
 */
- (NSString *)traditionalMoneyString;

@end

NS_ASSUME_NONNULL_END
