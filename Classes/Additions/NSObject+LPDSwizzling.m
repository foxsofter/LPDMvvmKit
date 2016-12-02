//
//  NSObject+LPDSwizzling.m
//  LPDAdditions
//
//  Created by foxsofter on 15/2/1.
//  Copyright (c) 2015年 foxsofter. All rights reserved.
//

#import "NSObject+LPDSwizzling.h"
#import <objc/runtime.h>

/**
 *  @author foxsofter, 15-09-24 10:09:14
 *
 *  @brief  调配类方法和实例方法
 */
@implementation NSObject (LPDSwizzling)

/**
 *  @brief  交换实例方法的实现
 *
 *  @param cls         类
 *  @param oldSelector
 *  @param newSelector
 */
+ (void)instanceSwizzle:(Class)cls oldSelector:(SEL)oldSelector newSelector:(SEL)newSelector {
  Method oldMethod = class_getInstanceMethod(cls, oldSelector);
  Method newMethod = class_getInstanceMethod(cls, newSelector);

  if (class_addMethod(cls, oldSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
    class_replaceMethod(cls, newSelector, method_getImplementation(oldMethod), method_getTypeEncoding(oldMethod));
  } else {
    method_exchangeImplementations(oldMethod, newMethod);
  }
}

/**
 *  @brief  交换类方法的实现
 *
 *  @param cls         类
 *  @param oldSelector
 *  @param newSelector
 */
+ (void)classSwizzle:(Class)cls oldSelector:(SEL)oldSelector newSelector:(SEL)newSelector {
  cls = object_getClass(cls);
  [NSObject instanceSwizzle:cls oldSelector:oldSelector newSelector:newSelector];
}

- (void)instanceSwizzle:(SEL)oldSelector newSelector:(SEL)newSElector {
  [NSObject instanceSwizzle:[self class] oldSelector:oldSelector newSelector:newSElector];
}

- (void)classSwizzle:(SEL)oldSelector newSelector:(SEL)newSelector {
  [NSObject classSwizzle:[self class] oldSelector:oldSelector newSelector:newSelector];
}

@end
