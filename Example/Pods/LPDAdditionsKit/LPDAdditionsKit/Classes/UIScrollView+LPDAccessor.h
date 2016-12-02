//
//  UIScrollView+LPDAccessor.h
//  LPDAdditions
//
//  Created by foxsofter on 15/9/23.
//  Copyright © 2015年 foxsofter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (LPDAccessor)

/**
 *  @brief  get contentOffset.x
 */
@property (nonatomic) CGFloat contentOffsetX;

/**
 *  @brief  get contentOffset.y
 */
@property (nonatomic) CGFloat contentOffsetY;

/**
 *  @brief  get contentSize.width
 */
@property (nonatomic) CGFloat contentSizeWidth;

/**
 *  @brief  get contentSize.height
 */
@property (nonatomic) CGFloat contentSizeHeight;

/**
 *  @brief  get contentInset.top
 */
@property (nonatomic) CGFloat contentInsetTop;

/**
 *  @brief  get contentInset.left
 */
@property (nonatomic) CGFloat contentInsetLeft;

/**
 *  @brief  get contentInset.bottom
 */
@property (nonatomic) CGFloat contentInsetBottom;

/**
 *  @brief  get contentInset.right
 */
@property (nonatomic) CGFloat contentInsetRight;

@end
