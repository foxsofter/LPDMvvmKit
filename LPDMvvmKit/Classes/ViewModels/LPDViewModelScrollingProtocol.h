//
//  LPDViewModelScrollingProtocol.h
//  Pods
//
//  Created by foxsofter on 17/2/3.
//
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

typedef NS_ENUM(NSUInteger, LPDScrollingState) {
  LPDScrollingStateNoData,
  LPDScrollingStateNormal,
  LPDScrollingStateRetry,
};

@protocol LPDViewModelScrollingProtocol<NSObject>

/**
 *  @brief 滚动试图交互状态
 */
@property (nonatomic, assign) LPDScrollingState scrollingState;

/**
 *  @brief 设置滚动试图交互状态
 */
- (void)setScrollingtState:(LPDScrollingState)scrollingState withMessage:(NSString *)message;

@end
