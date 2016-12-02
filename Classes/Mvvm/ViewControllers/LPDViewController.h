//
//  LPDViewController.h
//  LPDMvvm
//
//  Created by foxsofter on 15/10/11.
//  Copyright © 2015年 foxsofter. All rights reserved.
//

#import "LPDViewControllerProtocol.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LPDViewController : UIViewController <LPDViewControllerProtocol>

/**
 *  @brief 设置有网络时的block
 */
+ (void)networkStateNormalBlock:(void (^)())block;

/**
 *  @brief 设置无网络时的block
 */
+ (void)networkStateDisableBlock:(void (^)())block;

/**
 *  @brief 设置进度条显示的block
 */
+ (void)showSubmittingBlock:(void (^)(NSString *_Nullable status))block;

/**
 *  @brief 设置进度条消失的block
 */
+ (void)hideSubmittingBlock:(void (^)())block;

/**
 *  @brief 设置成功提示显示的block
 */
+ (void)showSuccessBlock:(void (^)(NSString *_Nullable status))block;

/**
 *  @brief 设置错误提示显示的block
 */
+ (void)showErrorBlock:(void (^)(NSString *_Nullable status))block;

/**
 *  @brief 设置submitting的contentView，会被全屏居中显示，需设定为以下信号触发时启动动画
 ＊  [RACSignal merge:@[
 ＊    [submittingView rac_signalForSelector:@selector(didMoveToWindow)],
 ＊    [submittingView rac_signalForSelector:@selector(didMoveToSuperview)]
 ＊  ]]
 */
+ (void)initSubmittingBlock:(UIView * (^)())block;

/**
 *  @brief 禁用无关函数
 */
+ (instancetype) new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil
                         bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
- (void)presentViewController:(UIViewController *)viewControllerToPresent
                     animated:(BOOL)flag
                   completion:(void (^__nullable)(void))completion NS_UNAVAILABLE;
- (void)addChildViewController:(UIViewController *)childController NS_UNAVAILABLE;
- (void)removeFromParentViewController NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
