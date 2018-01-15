//
//  NSObject+LPDThread.h
//  LPDAdditions
//
//  Created by foxsofter on 15/1/21.
//  Copyright (c) 2015年 foxsofter. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  @author foxsofter, 15-09-24 10:09:48
 *
 *  @brief  对performSelector进行扩展，并添加performBlock
 */
@interface NSObject (LPDThread)

#pragma mark - NSObject performSelector with multi parameter

- (nullable id)performSelector:(SEL)selector withObject:(nullable id)p1 withObject:(nullable id)p2 withObject:(nullable id)p3;

- (nullable id)performSelector:(SEL)selector withObject:(nullable id)p1 withObject:(nullable id)p2 withObject:(nullable id)p3 withObject:(nullable id)p4;

- (nullable id)performSelector:(SEL)selector
           withObject:(nullable id)p1
           withObject:(nullable id)p2
           withObject:(nullable id)p3
           withObject:(nullable id)p4
           withObject:(nullable id)p5;

- (nullable id)performSelector:(SEL)selector
           withObject:(nullable id)p1
           withObject:(nullable id)p2
           withObject:(nullable id)p3
           withObject:(nullable id)p4
           withObject:(nullable id)p5
           withObject:(nullable id)p6;

- (nullable id)performSelector:(SEL)selector
           withObject:(nullable id)p1
           withObject:(nullable id)p2
           withObject:(nullable id)p3
           withObject:(nullable id)p4
           withObject:(nullable id)p5
           withObject:(nullable id)p6
           withObject:(nullable id)p7;

#pragma mark - NSObject performSelector with multi parameter and delay

- (void)performSelector:(SEL)selector afterDelay:(NSTimeInterval)delay;

- (void)performSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 afterDelay:(NSTimeInterval)delay;

- (void)performSelector:(SEL)selector
             withObject:(nullable id)p1
             withObject:(nullable id)p2
             withObject:(nullable id)p3
             afterDelay:(NSTimeInterval)delay;

- (void)performSelector:(SEL)selector
             withObject:(nullable id)p1
             withObject:(nullable id)p2
             withObject:(nullable id)p3
             withObject:(nullable id)p4
             afterDelay:(NSTimeInterval)delay;

- (void)performSelector:(SEL)selector
             withObject:(nullable id)p1
             withObject:(nullable id)p2
             withObject:(nullable id)p3
             withObject:(nullable id)p4
             withObject:(nullable id)p5
             afterDelay:(NSTimeInterval)delay;

- (void)performSelector:(SEL)selector
             withObject:(nullable id)p1
             withObject:(nullable id)p2
             withObject:(nullable id)p3
             withObject:(nullable id)p4
             withObject:(nullable id)p5
             withObject:(nullable id)p6
             afterDelay:(NSTimeInterval)delay;

- (void)performSelector:(SEL)selector
             withObject:(nullable id)p1
             withObject:(nullable id)p2
             withObject:(nullable id)p3
             withObject:(nullable id)p4
             withObject:(nullable id)p5
             withObject:(nullable id)p6
             withObject:(nullable id)p7
             afterDelay:(NSTimeInterval)delay;

#pragma mark - NSObject performBlock

- (void)performBlock:(void (^)(void))block;

- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay;

@end

NS_ASSUME_NONNULL_END
