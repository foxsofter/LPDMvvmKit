//
//  LPDViewModelSubmittingProtocol.h
//  LPDMvvmKit
//
//  Created by foxsofter on 17/2/3.
//
//

#import <Foundation/Foundation.h>

@protocol LPDViewModelSubmittingProtocol<NSObject>

/**
 *  @brief  正在提交表单
 */
@property (nonatomic, assign, getter=isSubmitting) BOOL submitting;

/**
 *  @brief 设置正在提交表单
 */
- (void)setSubmittingWithMessage:(NSString *)message;

@end
