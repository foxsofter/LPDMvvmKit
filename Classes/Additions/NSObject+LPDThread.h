//
//  NSObject+LPDThread.h
//  LPDAdditions
//
//  Created by foxsofter on 15/1/21.
//  Copyright (c) 2015年 foxsofter. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  @author foxsofter, 15-09-24 10:09:48
 *
 *  @brief  对performSelector进行扩展，并添加performBlock
 */
@interface NSObject (LPDThread)

#pragma mark - NSObject performSelector with multi parameter

- (id)performSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3;

- (id)performSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3 withObject:(id)p4;

- (id)performSelector:(SEL)selector
           withObject:(id)p1
           withObject:(id)p2
           withObject:(id)p3
           withObject:(id)p4
           withObject:(id)p5;

- (id)performSelector:(SEL)selector
           withObject:(id)p1
           withObject:(id)p2
           withObject:(id)p3
           withObject:(id)p4
           withObject:(id)p5
           withObject:(id)p6;

- (id)performSelector:(SEL)selector
           withObject:(id)p1
           withObject:(id)p2
           withObject:(id)p3
           withObject:(id)p4
           withObject:(id)p5
           withObject:(id)p6
           withObject:(id)p7;

#pragma mark - NSObject performSelector with multi parameter and delay

- (void)performSelector:(SEL)selector afterDelay:(NSTimeInterval)delay;

- (void)performSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 afterDelay:(NSTimeInterval)delay;

- (void)performSelector:(SEL)selector
             withObject:(id)p1
             withObject:(id)p2
             withObject:(id)p3
             afterDelay:(NSTimeInterval)delay;

- (void)performSelector:(SEL)selector
             withObject:(id)p1
             withObject:(id)p2
             withObject:(id)p3
             withObject:(id)p4
             afterDelay:(NSTimeInterval)delay;

- (void)performSelector:(SEL)selector
             withObject:(id)p1
             withObject:(id)p2
             withObject:(id)p3
             withObject:(id)p4
             withObject:(id)p5
             afterDelay:(NSTimeInterval)delay;

- (void)performSelector:(SEL)selector
             withObject:(id)p1
             withObject:(id)p2
             withObject:(id)p3
             withObject:(id)p4
             withObject:(id)p5
             withObject:(id)p6
             afterDelay:(NSTimeInterval)delay;

- (void)performSelector:(SEL)selector
             withObject:(id)p1
             withObject:(id)p2
             withObject:(id)p3
             withObject:(id)p4
             withObject:(id)p5
             withObject:(id)p6
             withObject:(id)p7
             afterDelay:(NSTimeInterval)delay;

#pragma mark - NSObject performBlock

- (void)performBlock:(void (^)(void))block;

- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay;

@end
