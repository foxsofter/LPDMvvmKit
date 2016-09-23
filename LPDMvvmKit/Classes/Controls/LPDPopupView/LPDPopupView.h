//
//  LPDPopupView.h
//  FoxKit
//
//  Created by foxsofter on 15/10/8.
//  Copyright © 2015年 foxsofter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (LPDPopupView)

+ (UIColor *)labelFontColor;
+ (UIColor *)popupViewBackgroundColor;
+ (UIColor *)primaryFontColor;
+ (UIColor *)primaryBackgroundColor;
+ (UIColor *)primaryTintColor;

@end

/**
 *  @author foxsofter, 15-10-08 17:10:50
 *
 *  @brief  实现从当前ViewController底部上滑的View
 */
@interface LPDPopupView : UIView

/**
 *  @brief  上滑显示View
 *
 *  @param contentView
 */
+ (void)show:(UIView *)contentView;

/**
 *  @brief  下滑隐藏View
 */
+ (void)hide;

/**
 *  @brief  需要上滑的View
 */
@property (nonatomic, strong, readonly) UIView *contentView;

/**
 *  @brief  content view showing.
 */
@property (nonatomic, assign, getter=isShowing) BOOL showing;

@end
