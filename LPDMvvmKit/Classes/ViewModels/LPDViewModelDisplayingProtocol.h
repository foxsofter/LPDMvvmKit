//
//  LPDViewModelDisplayingProtocol.h
//  LPDMvvmKit
//
//  Created by foxsofter on 17/2/3.
//
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

typedef NS_ENUM(NSUInteger, LPDViewDisplayingState) {
  LPDViewDisplayingStateNoData,
  LPDViewDisplayingStateNormal,
  LPDViewDisplayingStateRetry,
};

@protocol LPDViewModelDisplayingProtocol<NSObject>

/**
 *  @brief 滚动试图交互状态
 */
@property (nonatomic, assign) LPDViewDisplayingState viewDisplayingState;

/**
 *  @brief 设置滚动试图交互状态
 */
- (void)setViewDisplayingState:(LPDViewDisplayingState)viewDisplayingState withMessage:(NSString *)message;

@end
