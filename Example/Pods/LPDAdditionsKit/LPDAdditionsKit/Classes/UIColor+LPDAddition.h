//
//  UIColor+LPDAddition.h
//  LPDAdditions
//
//  Created by foxsofter on 15/1/19.
//  Copyright (c) 2015年 foxsofter. All rights reserved.
//

#import <UIKit/UIColor.h>

NS_ASSUME_NONNULL_BEGIN

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

/**
 *  create color with r g b
 *
 *  @param red   0~255
 *  @param green 0~255
 *  @param blue  0~255
 *
 *  @return
 */
+ (UIColor *)colorWithRGB:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;

+ (UIColor *)colorWithRGBA:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

/**
 Return a randomColor (just for test UI)
 
 @return randomColor
 */
+ (UIColor *)randomColor;

@end

NS_ASSUME_NONNULL_END
