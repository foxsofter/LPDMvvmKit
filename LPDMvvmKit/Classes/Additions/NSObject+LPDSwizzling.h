//
//  NSObject+LPDSwizzling.h
//  LPDAdditions
//
//  Created by foxsofter on 15/2/1.
//  Copyright (c) 2015年 foxsofter. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef IMP *IMPPointer;

@interface NSObject (LPDSwizzling)

/**
 *  @brief  交换一个类方法的实现
 *
 *  @param oldSelector  原类方法的实现
 *  @param newSelector  新类方法的实现
 */
+ (void)classSwizzle:(Class)cls oldSelector:(SEL)oldSelector newSelector:(SEL)newSelector;

/**
 *  @brief 交换一个实例方法的实现
 *
 *  @param oldSelector  原实例方法的实现
 *  @param newSelector  新实例方法的实现
 */
+ (void)instanceSwizzle:(Class)cls oldSelector:(SEL)oldSelector newSelector:(SEL)newSelector;

/**
 *  @brief  交换当前类方法的实现
 *
 *  @param oldSelector  原类方法的实现
 *  @param newSelector  新类方法的实现
 */
- (void)classSwizzle:(SEL)oldSelector newSelector:(SEL)newSelector;

/**
 *  @brief  交换当前类的实例方法的实现
 *
 *  @param oldSelector  原实例方法的实现
 *  @param newSelector  新实例方法的实现
 */
- (void)instanceSwizzle:(SEL)oldSelector newSelector:(SEL)newSElector;

@end
