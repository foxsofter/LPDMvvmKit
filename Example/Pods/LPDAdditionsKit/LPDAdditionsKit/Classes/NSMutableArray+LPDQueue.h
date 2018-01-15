//
//  NSMutableArray+LPDQueue.h
//  LPDMvvmKit
//
//  Created by foxsofter on 16/2/1.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableArray (LPDQueue)

/**
 *  @brief 队列的容量，大于0为有效容量，小于等于0表示不限制容量
 */
@property (nonatomic, assign) NSInteger queueSize;

- (void)enqueueObject:(id)anObject;

- (nullable id)dequeueObject;

@end

NS_ASSUME_NONNULL_END
