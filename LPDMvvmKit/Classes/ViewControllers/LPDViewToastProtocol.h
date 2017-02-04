//
//  LPDViewToastProtocol.h
//  Pods
//
//  Created by foxsofter on 17/2/4.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LPDViewToastProtocol <NSObject>

@optional

/**
 *  @brief 设置成功提示
 */
+ (void)showSuccess:(NSString *_Nullable)status;

/**
 *  @brief 设置错误提示
 */
+ (void)showError:(NSString *_Nullable)status;

@end

NS_ASSUME_NONNULL_END
