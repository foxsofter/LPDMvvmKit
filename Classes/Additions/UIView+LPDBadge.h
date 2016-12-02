//
//  UIView+LPDBadge.h
//  LPDMvvmKit
//
//  Created by foxsofter on 16/4/15.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LPDBadge)

/**
 *  @brief 是否显示badge
 */
@property (nonatomic, assign) BOOL shouldShowBadge;

/**
 *  @brief 配置badge，参数UIView didMoveToSuperview
 */
@property (nonatomic, copy) void (^badgeConfigBlock)(UIView *);

@end
