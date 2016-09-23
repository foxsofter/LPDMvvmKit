//
//  UIView+LPDAccessor.h
//  LPDAdditions
//
//  Created by foxsofter on 15/9/23.
//  Copyright © 2015年 foxsofter. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @author foxsofter, 15-09-24 09:09:51
 *
 *  @brief  View layout: 包含相对于父视图的布局和相对于自身的布局
 *          frame layout: 相对于父视图的布局，为视图占据父视图的部分
 *          bounds layout: 相对于自身的布局，为视图的可布局子视图的部分
 *           ______________________
 *          | ____________________ |
 *          | |                  | |
 *          | |      bounds      | |
 *          | |                  | |
 *          | |__________________| |
 *          |______________________|
 *
 *                   frame
 *
 */
@interface UIView (LPDAccessor)

/**
 *  @brief  get view.frame.origin
 */
@property (nonatomic) CGPoint origin;

/**
 *  @brief  get view.frame.origin.x
 */
@property (nonatomic) CGFloat x;

/**
 *  @brief  get view.frame.origin.y
 */
@property (nonatomic) CGFloat y;

/**
 *  @brief  get view.frame.size
 */
@property (nonatomic) CGSize size;

/**
 *  @brief  get view.frame.size.width
 */
@property (nonatomic) CGFloat width;

/**
 *  @brief  get view.frame.size.height
 */
@property (nonatomic) CGFloat height;

/**
 *  @brief  get view.bounds.origin
 */
@property (nonatomic) CGPoint boundsOrigin;

/**
 *  @brief  get view.bounds.origin.x
 */
@property (nonatomic) CGFloat boundsX;

/**
 *  @brief  get view.bounds.origin.y
 */
@property (nonatomic) CGFloat boundsY;

/**
 *  @brief  get view.bounds.size
 */
@property (nonatomic) CGSize boundsSize;

/**
 *  @brief  get view.bounds.size.width
 */
@property (nonatomic) CGFloat boundsWidth;

/**
 *  @brief  get view.bounds.size.height
 */
@property (nonatomic) CGFloat boundsHeight;

/**
 *  @brief  get view.bounds.origin.y - view.frame.origin.y
 */
@property (nonatomic) CGFloat top;

/**
 *  @brief  get view.bounds.origin.x - view.frame.origin.x
 */
@property (nonatomic) CGFloat left;

/**
 *  @brief  get (view.frame.size.height + view.frame.origin.y)
 *              -
 *              (view.bounds.size.height + view.bounds.origin.y)
 */
@property (nonatomic) CGFloat bottom;

/**
 *  @brief  get (view.frame.size.width + view.frame.origin.x)
 *              -
 *              (view.bounds.size.width + view.bounds.origin.x)
 */
@property (nonatomic) CGFloat right;

/**
 *  @brief  get view.center.x
 */
@property (nonatomic) CGFloat centerX;

/**
 *  @brief  get view.center.y
 */
@property (nonatomic) CGFloat centerY;

@end
