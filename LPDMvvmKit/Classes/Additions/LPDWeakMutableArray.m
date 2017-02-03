//
//  LPDWeakMutableArray.m
//  LPDMvvmKit
//
//  Created by foxsofter on 17/2/3.
//
//

#import "LPDWeakMutableArray.h"

@implementation NSArray (LPDWeak)

- (instancetype)weakCopy {
  LPDWeakMutableArray *mutableArray = [LPDWeakMutableArray array];
  for (id item in self) {
    [mutableArray addObject:item];
  }
  [mutableArray copy];
}

@end

@implementation LPDWeakMutableArray

- (id)objectAtIndex:(NSUInteger)index {
  return [[super objectAtIndex:index] nonretainedObjectValue];
}

- (BOOL)containsObject:(id)anObject {
  return [super containsObject:[NSValue valueWithNonretainedObject:anObject]];
}

- (id)firstObject {
  return [[super firstObject] nonretainedObjectValue];
}

- (id)lastObject {
  return [[super lastObject] nonretainedObjectValue];
}

- (NSArray<id> *)objectsAtIndexes:(NSIndexSet *)indexes {
  NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:indexes.count];
  [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
    [mutableArray addObject:[[self objectAtIndex:idx] nonretainedObjectValue]];
  }];
  return [mutableArray copy];
}

- (id)copy {
  NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:self.count];
  for (id item in self) {
    [mutableArray addObject:[item nonretainedObjectValue]];
  }
  return [mutableArray copy];
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx {
  return [[super objectAtIndexedSubscript:idx] nonretainedObjectValue];
}

- (void)addObject:(id)anObject {
  [super addObject:[NSValue valueWithNonretainedObject:anObject]];
}
- (void)insertObject:(id)anObject atIndex:(NSUInteger)index {
  [super insertObject:[NSValue valueWithNonretainedObject:anObject] atIndex:index];
}

- (void)addObjectsFromArray:(NSArray<id> *)otherArray {
  [super addObjectsFromArray:[otherArray weakCopy]];
}

- (void)replaceObjectsInRange:(NSRange)range withObjectsFromArray:(NSArray<id> *)otherArray range:(NSRange)otherRange {
  [super replaceObjectsInRange:range withObjectsFromArray:[otherArray weakCopy] range:otherRange];
}

- (void)replaceObjectsInRange:(NSRange)range withObjectsFromArray:(NSArray<id> *)otherArray {
  [super replaceObjectsInRange:range withObjectsFromArray:[otherArray weakCopy]];
}

- (void)setArray:(NSArray<id> *)otherArray {
  [super setArray:[otherArray weakCopy]];
}

- (void)insertObjects:(NSArray<id> *)objects atIndexes:(NSIndexSet *)indexes {
  [super insertObjects:[objects weakCopy] atIndexes:indexes];
}

- (void)replaceObjectsAtIndexes:(NSIndexSet *)indexes withObjects:(NSArray<id> *)objects {
  [super replaceObjectsAtIndexes:indexes withObjects:[objects weakCopy]];
}

- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx NS_AVAILABLE(10_8, 6_0) {
  [super setObject:[NSValue valueWithNonretainedObject:obj] atIndexedSubscript:idx];
}

@end
