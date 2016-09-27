//
//  UIButton+LPDSubmitting.h
//  LPDAdditions
//
//  Created by foxsofter on 15/4/2.
//  Copyright (c) 2015年 foxsofter. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @author foxsofter, 15-09-24 10:09:49
 *
 *  @brief  为UIButton添加提交状态，通过ActivityIndicator表示
 */
@interface UIButton (LPDSubmitting)

/**
 *  @brief  按钮点击后，禁用按钮并居中显示ActivityIndicator
 */
- (void)beginSubmitting;

/**
 *  @brief  按钮点击后，禁用按钮并在按钮上显示ActivityIndicator，以及title
 *
 *  @param title 按钮上显示的文字
 */
- (void)beginSubmitting:(NSString *)title;

/**
 *  @brief  按钮点击后，恢复按钮点击前的状态
 */
- (void)endSubmitting;

/**
 *  @brief  按钮是否正在提交中
 */
@property (nonatomic, readonly, getter=isSubmitting) BOOL submitting;

@end
