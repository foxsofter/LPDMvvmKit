//
//  LPDViewNetworkStatusProtocol.h
//  Pods
//
//  Created by foxsofter on 17/2/4.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LPDViewNetworkStatusProtocol <NSObject>

@optional

/**
 *  @brief 网络恢复正常
 */
- (void)showNetworkNormal;

/**
 *  @brief 网络被断开
 */
- (void)showNetworkDisable;

@end

NS_ASSUME_NONNULL_END
