//
//  LPDViewModelToastProtocol.h
//  LPDMvvmKit
//
//  Created by foxsofter on 17/2/3.
//
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@protocol LPDViewModelToastProtocol <NSObject>

/**
 *  @brief  成功，完成
 */
@property (nonatomic, strong, readonly) RACSubject *successSubject;

/**
 *  @brief  错误
 */
@property (nonatomic, strong, readonly) RACSubject *errorSubject;

@end
