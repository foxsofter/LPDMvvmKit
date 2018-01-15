//
//  UIView+LPDBadge.h
//  LPDMvvmKit
//
//  Created by foxsofter on 16/4/15.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (LPDBadge)

/**
 *  @brief 是否显示badge
 */
@property (nonatomic, assign) BOOL shouldShowBadge;

/**
 *  @brief badge内容，为空则显示小红点
 */
@property (nonatomic, copy) NSString *badgeString;

@property (nonatomic, strong) UILabel *badgeLabel;


/**
 *  @brief 配置badge，参数UIView didMoveToSuperview
 */
@property (nonatomic, copy, nullable) void (^badgeConfigBlock)(UIView *);

@end

NS_ASSUME_NONNULL_END
