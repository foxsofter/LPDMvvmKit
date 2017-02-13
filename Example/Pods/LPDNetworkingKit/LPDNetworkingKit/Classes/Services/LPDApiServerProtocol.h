//
//  LPDApiServerProtocol.h
//  LPDMvvmKit
//
//  Created by foxsofter on 16/1/18.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, LPDNetworkStatus) {
  LPDNetworkStatusUnknown = -1,
  LPDNetworkStatusNotReachable = 0,
  LPDNetworkStatusReachableViaWWAN = 1,
  LPDNetworkStatusReachableViaWiFi = 2,
};

typedef NS_ENUM(NSUInteger, LPDApiServerType) {
  LPDApiServerTypeNone,
  LPDApiServerTypeAlpha,
  LPDApiServerTypeBeta,
  LPDApiServerTypeProduce,
};

@protocol LPDApiServerProtocol <NSObject>

/**
 *  @brief  当前API域名
 */
@property (nullable, nonatomic, copy, readonly) NSString *serverUrl;

/**
 *  @brief 当前服务器指向类型
 */
@property (nonatomic, assign) LPDApiServerType serverType;

/**
 *  @brief 设置每个api server type对应的api server url
 */
- (void)setServerUrl:(NSString *)serverUrl forServerType:(LPDApiServerType)serverType;

/**
 *  @brief  网络状态
 */
@property (nonatomic, assign, readonly) LPDNetworkStatus networkStatus;

/**
 *  @brief  是否接入网络
 */
@property (nonatomic, assign, readonly, getter=isReachable) BOOL reachable;

/**
 *  @brief  是否接入数据网络
 */
@property (nonatomic, assign, readonly, getter=isReachableViaWWAN) BOOL reachableViaWWAN;

/**
 *  @brief  是否接入无线网络
 */
@property (nonatomic, assign, readonly, getter=isReachableViaWiFi) BOOL reachableViaWiFi;

/**
 *  @brief 网络状态的信号，订阅此信号
 */
@property (nonatomic, strong, readonly) RACSignal *networkStatusSignal;

/**
 *  @brief  开始侦听服务器网络链接状态
 */
- (void)startMonitoring;

/**
 *  @brief  停止侦听服务器网络链接状态
 */
- (void)stopMonitoring;

@end

NS_ASSUME_NONNULL_END
