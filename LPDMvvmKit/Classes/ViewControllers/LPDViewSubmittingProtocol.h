//
//  LPDViewSubmittingProtocol.h
//  Pods
//
//  Created by foxsofter on 17/2/3.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LPDViewSubmittingProtocol <NSObject>

@optional

/**
 *  @brief 设置submitting的contentView，会被全屏居中显示，需设定为以下信号触发时启动动画
 ＊  [RACSignal merge:@[
 ＊    [submittingView rac_signalForSelector:@selector(didMoveToWindow)],
 ＊    [submittingView rac_signalForSelector:@selector(didMoveToSuperview)]
 ＊  ]]
 */
+ (UIView *)initSubmittingView;

@end

NS_ASSUME_NONNULL_END
