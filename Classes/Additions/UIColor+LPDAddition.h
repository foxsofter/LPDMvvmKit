//
//  UIColor+LPDAddition.h
//  LPDAdditions
//
//  Created by foxsofter on 15/1/19.
//  Copyright (c) 2015年 foxsofter. All rights reserved.
//

#import <UIKit/UIColor.h>

#define colorFromStringImpl(colorName, colorString)                                                                    \
  +(UIColor *)colorName##Color {                                                                                       \
    static UIColor *color = nil;                                                                                       \
    if (!color) {                                                                                                      \
      color = [UIColor colorWithHexString:@ #colorString];                                                             \
    }                                                                                                                  \
    return color;                                                                                                      \
  }

#define colorFromValueImpl(colorName, colorValue)                                                                      \
  +(UIColor *)colorName##Color {                                                                                       \
    static UIColor *color = nil;                                                                                       \
    if (!color) {                                                                                                      \
      color = colorValue;                                                                                              \
    }                                                                                                                  \
    return color;                                                                                                      \
  }

@interface UIColor (LPDAddition)

/**
 *  @brief get color from hex string
 *
 *  @param hexString #RGB #ARGB #RRGGBB #AARRGGBB
 *
 *  @return color
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString;

/**
 *  @brief  获取当前颜色的反色，即补色，颜色和其反色混合的效果是白色
 *          如果获取当前颜色有异常，将返回白色
 *
 *  @return 当前颜色的反色
 */
- (UIColor *)antiColor;

@end
