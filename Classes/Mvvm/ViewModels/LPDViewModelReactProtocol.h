//
//  LPDViewModelReactProtocol.h
//  LPDMvvmKit
//
//  Created by foxsofter on 16/3/17.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ReactiveCocoa.h"

typedef NS_ENUM(NSUInteger, LPDViewReactState) {
  LPDViewReactStateNoData,
  LPDViewReactStateNormal,
  LPDViewReactStateNetworkLatency,
};

typedef NS_ENUM(NSUInteger, LPDViewNetworkState) {
  LPDViewNetworkStateNormal,
  LPDViewNetworkStateDisable,
};

NS_ASSUME_NONNULL_BEGIN

@protocol LPDViewModelReactProtocol <NSObject>

@optional

@property (nonatomic, strong, readonly) RACSignal *viewDidLoadSignal;

@property (nonatomic, strong, readonly) RACSignal *viewDidLayoutSubviewsSignal;

@property (nonatomic, strong, readonly) RACSignal *didBecomeActiveSignal;

@property (nonatomic, strong, readonly) RACSignal *didBecomeInactiveSignal;

/**
 *  @brief 设置网络状态
 */
@property (nonatomic, assign) LPDViewNetworkState networkState;

/**
 *  @brief 视图交互状态
 */
@property (nonatomic, assign) LPDViewReactState reactState;

/**
 *  @brief 设置视图交互状态
 */
- (void)setReactState:(LPDViewReactState)reactState withMessage:(NSString *)message;

/**
 *  @brief  正在提交表单
 */
@property (nonatomic, assign, getter=isSubmitting) BOOL submitting;

/**
 *  @brief 设置正在提交表单
 */
- (void)setSubmittingWithMessage:(NSString *)message;

/**
 *  @brief  成功，完成
 */
@property (nonatomic, strong, readonly) RACSubject *successSubject;

/**
 *  @brief  错误
 */
@property (nonatomic, strong, readonly) RACSubject *errorSubject;

@end

NS_ASSUME_NONNULL_END
