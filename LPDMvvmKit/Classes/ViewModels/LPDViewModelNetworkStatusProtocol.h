//
//  LPDViewModelNetworkStatusProtocol.h
//  LPDMvvmKit
//
//  Created by foxsofter on 17/2/3.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LPDNetworkState) {
  LPDNetworkStateNormal,
  LPDNetworkStateDisable,
};

@protocol LPDViewModelNetworkStatusProtocol <NSObject>

/**
 *  @brief 设置网络状态
 */
@property (nonatomic, assign) LPDNetworkState networkState;

@end
