//
//  RACSignal+LPDAddition.h
//  LPDMvvmKit
//
//  Created by foxsofter on 16/3/24.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>

@interface RACSignal (LPDAddition)
/**
 *  @brief Do the given block after `next`. This should be used to
 *  inject side effects into the signal.
 */
- (RACSignal *)doAfterNext:(void (^)(id x))block;

@end
