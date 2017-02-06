//
//  LPDViewLoadingProtocol.h
//  Pods
//
//  Created by foxsofter on 17/2/4.
//
//

#import <Foundation/Foundation.h>
#import <MJRefresh/MJRefresh.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LPDViewLoadingProtocol <NSObject>

@optional

/**
 *  @brief 设置loading的contentView，会被居中显示，需设定为以下信号触发时启动动画
 ＊  [RACSignal merge:@[
 ＊    [submittingView rac_signalForSelector:@selector(didMoveToWindow)],
 ＊    [submittingView rac_signalForSelector:@selector(didMoveToSuperview)]
 ＊  ]]
 */
+ (UIView *)initLoadingView;

+ (void)hideRetryView:(UIView *)view;

+ (void)showRetryView:(UIView *)view withRetryBlock:(void (^)())retryBlock;

/**
 *  @brief 初始化下拉刷新Header
 */
+ (MJRefreshHeader *)initLoadingHeader:(MJRefreshComponentRefreshingBlock)refreshingBlock;

@end

NS_ASSUME_NONNULL_END
