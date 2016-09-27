//
//  UIImageView+LPDAddition.h
//  LPDAdditions
//
//  Created by foxsofter on 15/10/21.
//  Copyright © 2015年 foxsofter. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (LPDAddition)

/**
 *  @brief  获取缓存的图像
 *
 *  @param url remote url
 *
 *  @return
 */
+ (nullable UIImage *)cacheImageFromUrl:(NSString *)url;

/**
 *  @brief  设置图像
 *
 *  @param url
 */
- (void)setImageUrl:(NSString *)url;

/**
 *  @author foxsofter, 15-10-22 16:10:14
 *
 *  @brief  设置图像
 *
 *  @param url remote url
 */
- (void)setImageUrl:(NSString *)url withDuration:(NSTimeInterval)duration;
/**
 *  @brief  设置图像，并将其设为圆形，default
 *          borderWidth：1，borderColor：whiteColor
 *
 *  @param url              image url
 *  @param placeholderImage placeholder Image
 */
- (void)setCircleImageWithURL:(NSURL *)url placeholderImage:(nullable UIImage *)placeholderImage;

/**
 *  @brief  设置图像，并将其设为圆形
 *
 *  @param url              image url
 *  @param placeholderImage placeholder image
 *  @param borderWidth      border width
 *  @param borderColor      border color
 */
- (void)setCircleImageWithURL:(NSURL *)url
             placeholderImage:(nullable UIImage *)placeholderImage
                  borderWidth:(CGFloat)borderWidth
                  borderColor:(UIColor *)borderColor;

/**
 *  @brief  设置图像，并将其设为圆形
 *
 *  @param url              image url
 *  @param placeholderImage placeholder Image
 *  @param showProgress     showProgress
 */
- (void)setCircleImageWithURL:(NSURL *)url
             placeholderImage:(nullable UIImage *)placeholderImage
                 showProgress:(BOOL)showProgress;

/**
 *  @brief  设置图像，并将其设为圆形
 *
 *  @param url              image url
 *  @param placeholderImage placeholder Image
 *  @param borderWidth      border Width
 *  @param borderColor      border Color
 *  @param showProgress     show Progress
 */
- (void)setCircleImageWithURL:(NSURL *)url
             placeholderImage:(nullable UIImage *)placeholderImage
                  borderWidth:(CGFloat)borderWidth
                  borderColor:(UIColor *)borderColor
                 showProgress:(BOOL)showProgress;

@end

NS_ASSUME_NONNULL_END
