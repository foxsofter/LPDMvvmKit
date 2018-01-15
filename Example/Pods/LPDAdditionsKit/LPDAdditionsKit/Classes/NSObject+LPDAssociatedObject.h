//
//  NSObject+LPDAssociatedObject.h
//  LPDAdditions
//
//  Created by foxsofter on 15/2/23.
//  Copyright (c) 2015年 foxsofter. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 *  @author foxsofter, 15-02-23 21:02:44
 *
 *  @brief  动态添加属性到对象，避免繁琐的添加static NSString作为key
 */
@interface NSObject (LPDAssociatedObject)

- (id)object:(SEL)key;

- (void)setRetainNonatomicObject:(id)object withKey:(SEL)key;

- (void)setCopyNonatomicObject:(id)object withKey:(SEL)key;

- (void)setRetainObject:(id)object withKey:(SEL)key;

- (void)setCopyObject:(id)object withKey:(SEL)key;

@end

NS_ASSUME_NONNULL_END
