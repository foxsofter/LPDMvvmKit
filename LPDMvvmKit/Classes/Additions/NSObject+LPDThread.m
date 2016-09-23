//
//  NSObject+LPDThread.m
//  LPDAdditions
//
//  Created by foxsofter on 15/1/21.
//  Copyright (c) 2015年 foxsofter. All rights reserved.
//

#import "NSObject+LPDThread.h"

@implementation NSObject (LPDThread)

#pragma mark - NSObject performSelector with multi parameter

- (id)performSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3 {
  NSMethodSignature *sig = [self methodSignatureForSelector:selector];
  if (sig) {
    NSInvocation *invo = [NSInvocation invocationWithMethodSignature:sig];
    [invo setTarget:self];
    [invo setSelector:selector];
    [invo setArgument:&p1 atIndex:2];
    [invo setArgument:&p2 atIndex:3];
    [invo setArgument:&p3 atIndex:4];
    [invo invoke];
    if (sig.methodReturnLength) {
      id anObject;
      [invo getReturnValue:&anObject];
      return anObject;

    } else {
      return nil;
    }

  } else {
    return nil;
  }
}

- (id)performSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3 withObject:(id)p4 {
  NSMethodSignature *sig = [self methodSignatureForSelector:selector];
  if (sig) {
    NSInvocation *invo = [NSInvocation invocationWithMethodSignature:sig];
    [invo setTarget:self];
    [invo setSelector:selector];
    [invo setArgument:&p1 atIndex:2];
    [invo setArgument:&p2 atIndex:3];
    [invo setArgument:&p3 atIndex:4];
    [invo setArgument:&p4 atIndex:5];
    [invo invoke];
    if (sig.methodReturnLength) {
      id anObject;
      [invo getReturnValue:&anObject];
      return anObject;

    } else {
      return nil;
    }

  } else {
    return nil;
  }
}

- (id)performSelector:(SEL)selector
           withObject:(id)p1
           withObject:(id)p2
           withObject:(id)p3
           withObject:(id)p4
           withObject:(id)p5 {
  NSMethodSignature *sig = [self methodSignatureForSelector:selector];
  if (sig) {
    NSInvocation *invo = [NSInvocation invocationWithMethodSignature:sig];
    [invo setTarget:self];
    [invo setSelector:selector];
    [invo setArgument:&p1 atIndex:2];
    [invo setArgument:&p2 atIndex:3];
    [invo setArgument:&p3 atIndex:4];
    [invo setArgument:&p4 atIndex:5];
    [invo setArgument:&p5 atIndex:6];
    [invo invoke];
    if (sig.methodReturnLength) {
      id anObject;
      [invo getReturnValue:&anObject];
      return anObject;

    } else {
      return nil;
    }

  } else {
    return nil;
  }
}

- (id)performSelector:(SEL)selector
           withObject:(id)p1
           withObject:(id)p2
           withObject:(id)p3
           withObject:(id)p4
           withObject:(id)p5
           withObject:(id)p6 {
  NSMethodSignature *sig = [self methodSignatureForSelector:selector];
  if (sig) {
    NSInvocation *invo = [NSInvocation invocationWithMethodSignature:sig];
    [invo setTarget:self];
    [invo setSelector:selector];
    [invo setArgument:&p1 atIndex:2];
    [invo setArgument:&p2 atIndex:3];
    [invo setArgument:&p3 atIndex:4];
    [invo setArgument:&p4 atIndex:5];
    [invo setArgument:&p5 atIndex:6];
    [invo setArgument:&p6 atIndex:7];
    [invo invoke];
    if (sig.methodReturnLength) {
      id anObject;
      [invo getReturnValue:&anObject];
      return anObject;

    } else {
      return nil;
    }

  } else {
    return nil;
  }
}

- (id)performSelector:(SEL)selector
           withObject:(id)p1
           withObject:(id)p2
           withObject:(id)p3
           withObject:(id)p4
           withObject:(id)p5
           withObject:(id)p6
           withObject:(id)p7 {
  NSMethodSignature *sig = [self methodSignatureForSelector:selector];
  if (sig) {
    NSInvocation *invo = [NSInvocation invocationWithMethodSignature:sig];
    [invo setTarget:self];
    [invo setSelector:selector];
    [invo setArgument:&p1 atIndex:2];
    [invo setArgument:&p2 atIndex:3];
    [invo setArgument:&p3 atIndex:4];
    [invo setArgument:&p4 atIndex:5];
    [invo setArgument:&p5 atIndex:6];
    [invo setArgument:&p6 atIndex:7];
    [invo setArgument:&p7 atIndex:8];
    [invo invoke];
    if (sig.methodReturnLength) {
      id anObject;
      [invo getReturnValue:&anObject];
      return anObject;

    } else {
      return nil;
    }

  } else {
    return nil;
  }
}

#pragma mark - NSObject performSelector with multi parameter and delay

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

- (void)performSelector:(SEL)selector afterDelay:(NSTimeInterval)delay {
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [self performSelector:selector];
  });
}

- (void)performSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 afterDelay:(NSTimeInterval)delay {
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [self performSelector:selector withObject:p1 withObject:p2];
  });
}

#pragma clang diagnostic pop

- (void)performSelector:(SEL)selector
             withObject:(id)p1
             withObject:(id)p2
             withObject:(id)p3
             afterDelay:(NSTimeInterval)delay {
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [self performSelector:selector withObject:p1 withObject:p2 withObject:p3];
  });
}

- (void)performSelector:(SEL)selector
             withObject:(id)p1
             withObject:(id)p2
             withObject:(id)p3
             withObject:(id)p4
             afterDelay:(NSTimeInterval)delay {
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [self performSelector:selector withObject:p1 withObject:p2 withObject:p3 withObject:p4];
  });
}

- (void)performSelector:(SEL)selector
             withObject:(id)p1
             withObject:(id)p2
             withObject:(id)p3
             withObject:(id)p4
             withObject:(id)p5
             afterDelay:(NSTimeInterval)delay {
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [self performSelector:selector withObject:p1 withObject:p2 withObject:p3 withObject:p4 withObject:p5];
  });
}

- (void)performSelector:(SEL)selector
             withObject:(id)p1
             withObject:(id)p2
             withObject:(id)p3
             withObject:(id)p4
             withObject:(id)p5
             withObject:(id)p6
             afterDelay:(NSTimeInterval)delay {
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [self performSelector:selector withObject:p1 withObject:p2 withObject:p3 withObject:p4 withObject:p5 withObject:p6];
  });
}

- (void)performSelector:(SEL)selector
             withObject:(id)p1
             withObject:(id)p2
             withObject:(id)p3
             withObject:(id)p4
             withObject:(id)p5
             withObject:(id)p6
             withObject:(id)p7
             afterDelay:(NSTimeInterval)delay {
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [self performSelector:selector
               withObject:p1
               withObject:p2
               withObject:p3
               withObject:p4
               withObject:p5
               withObject:p6
               withObject:p7];
  });
}

#pragma mark - NSObject performBlock with multi parameter

- (void)performBlock:(void (^)(void))block {
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}

- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay {
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}

@end
