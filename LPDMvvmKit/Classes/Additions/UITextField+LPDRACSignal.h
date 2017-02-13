//
//  UITextField+LPDRACSignal.h
//  LPDMvvmKit
//
//  Created by foxsofter on 16/4/22.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>
#import <UIKit/UIKit.h>

@interface UITextField (LPDRACSignal)

/**
 *  @brief A delegate proxy which will be set as the receiver's delegate
 *  when any of the methods in this category are used.
 */
@property (nonatomic, strong, readonly) RACDelegateProxy *rac_delegateProxy;

@end
