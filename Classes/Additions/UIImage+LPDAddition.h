//
//  UIImage+LPDAddition.h
//  LPDAdditions
//
//  Created by foxsofter on 15/9/23.
//  Copyright © 2015年 foxsofter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LPDAddition)

/**
 *  @brief  以传入的视图为源，根据主窗口压缩比例截图
 *
 *  @param sourceView 源视图
 *
 *  @return 如果源视图为nil，则返回nil
 */
+ (UIImage *)createImageFromView:(UIView *)sourceView;

/**
 *  @brief  根据颜色生成图片，默认size为{1.f, 1.f}
 *
 *  @param color 传入颜色
 *
 *  @return 返回图片
 */
+ (UIImage *)createImageWithColor:(UIColor *)color;

/**
 *  @brief  根据颜色和传入的size生成图片
 *
 *  @param color 传入的颜色
 *  @param size  生成图片的size
 *
 *  @return 返回图片
 */
+ (UIImage *)createImageWithColor:(UIColor *)color size:(CGSize)size;

/**
 *  @brief 设置图片的透明度
 *
 *  @param alpha 透明度
 *
 *  @return 返回处理后的图片
 */
- (UIImage *)imageWithAlpha:(CGFloat)alpha;

/**
 *  @brief 设置图片的size
 *
 *  @param size
 *
 *  @return 返回改变size之后的图片
 */
- (UIImage *)resizeTo:(CGSize)size;

@end
