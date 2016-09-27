//
//  NSMutableArray+LPDStack.m
//  LPDMvvmKit
//
//  Created by foxsofter on 16/2/1.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "NSMutableArray+LPDStack.h"

@implementation NSMutableArray (LPDStack)

- (void)pushObject:(id)anObject {
  [self addObject:anObject];
}

- (id)popObject {
  id anObject = [self lastObject];
  if (self.count > 0) {
    [self removeLastObject];
  }
  return anObject;
}

- (id)peekObject {
  return [self lastObject];
}

@end
