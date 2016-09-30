//
//  LPDScrollViewController.h
//  LPDMvvmKit
//
//  Created by foxsofter on 15/12/13.
//  Copyright © 2015年 eleme. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>
#import "LPDScrollViewControllerProtocol.h"
#import "LPDViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPDScrollViewController : LPDViewController <LPDScrollViewControllerProtocol>

/**
 *  @brief 设置列表正常时的block
 */
+ (void)reactStateNormalBlock:(void (^)(UIScrollView *scrollView))block;

/**
 *  @brief 设置列表无数据时的block
 */
+ (void)reactStateNoDataBlock:(void (^)(UIScrollView *scrollView, NSString *_Nullable))block;

/**
 *  @brief 设置列表网络延迟时的block
 */
+ (void)reactStateNetworkLatencyBlock:(void (^)(UIScrollView *scrollView, NSString *_Nullable))block;

/**
 *  @brief 设置非下拉加载开始的block，设置此block后，如果不是手动下拉触发则调用此block的加载动画
 */
+ (void)beginLodingBlock:(void (^)(UIView *view))block;

/**
 *  @brief 设置非下拉加载结束的block
 */
+ (void)endLodingBlock:(void (^)(UIView *view))block;

/**
 *  @brief 设置下拉刷新Header的block
 */
+ (void)initHeaderBlock:(MJRefreshHeader * (^)(MJRefreshComponentRefreshingBlock refreshingBlock))block;

/**
 *  @brief 设置下拉刷新Footer的block
 */
+ (void)initFooterBlock:(MJRefreshFooter * (^)(MJRefreshComponentRefreshingBlock refreshingBlock))block;

@end

NS_ASSUME_NONNULL_END
