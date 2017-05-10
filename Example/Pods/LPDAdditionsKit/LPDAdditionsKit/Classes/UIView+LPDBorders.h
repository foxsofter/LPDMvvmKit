//
//  UIView+LPDBorders.h
//  LPDAdditions
//
//  Created by foxsofter on 15/10/21.
//  Copyright © 2015年 foxsofter. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LPDUIViewBorderType) {
  LPDUIViewBorderTypeSolid,
  LPDUIViewBorderTypeDashed,
  LPDUIViewBorderTypeDoted
};

typedef NS_OPTIONS(NSUInteger, LPDUIViewBorderPosition) {
  LPDUIViewBorderPositionNone = 0,
  LPDUIViewBorderPositionTop = 1 << 0,
  LPDUIViewBorderPositionRight = 1 << 1,
  LPDUIViewBorderPositionBottom = 1 << 2,
  LPDUIViewBorderPositionLeft = 1 << 3,
};

/**
 *  @brief  灵活设置UIView的border
 */
@interface UIView (LPDBorders)

- (CAShapeLayer *)borderLayer;

/**
 *  @brief  设置UIView的border,绘制所有border
 *
 *  @param borderWidth borderWidth
 *  @param borderColor borderColor
 */
- (void)setBorder:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

/**
 *  @brief  设置UIView的border，根据borderPosition设置对应的border
 *
 *  @param borderWidth    borderWidth
 *  @param borderColor    borderColor
 *  @param borderPosition borderPosition
 */
- (void)setBorder:(CGFloat)borderWidth
      borderColor:(UIColor *)borderColor
   borderPosition:(LPDUIViewBorderPosition)borderPosition;

/**
 *  @brief  设置UIView的border,根据borderType绘制所有border
 *
 *  @param borderWidth borderWidth
 *  @param borderColor borderColor
 *  @param borderType  borderType
 */
- (void)setBorder:(CGFloat)borderWidth borderColor:(UIColor *)borderColor borderType:(LPDUIViewBorderType)borderType;

/**
 *  @brief  设置UIView的border,根据borderType和borderPosition绘制border
 *
 *  @param borderWidth    borderWidth
 *  @param borderColor    borderColor
 *  @param borderPosition borderPosition
 *  @param borderType     borderType
 */
- (void)setBorder:(CGFloat)borderWidth
      borderColor:(UIColor *)borderColor
   borderPosition:(LPDUIViewBorderPosition)borderPosition
       borderType:(LPDUIViewBorderType)borderType;

- (void)setLineDashPattern:(NSArray<NSNumber *> *)lineDashPattern;

@end
