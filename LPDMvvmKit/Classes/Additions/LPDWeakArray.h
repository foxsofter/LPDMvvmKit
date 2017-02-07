//
//  LPDWeakArray.h
//  Pods
//
//  Created by foxsofter on 17/2/3.
//
//

#import <Foundation/Foundation.h>

@interface LPDWeakArray<__covariant ObjectType> : NSObject<NSCopying, NSCoding, NSFastEnumeration>

+ (instancetype)array;

- (NSUInteger)count;

- (ObjectType)objectAtIndex:(NSUInteger)index;

- (ObjectType)firstObject;

- (ObjectType)lastObject;

- (BOOL)containsObject:(ObjectType)anObject;

- (ObjectType)objectAtIndexedSubscript:(NSUInteger)idx;

- (void)setObject:(ObjectType)obj atIndexedSubscript:(NSUInteger)idx;

- (void)addObject:(ObjectType)anObject;

- (void)insertObject:(ObjectType)anObject atIndex:(NSUInteger)index;

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(ObjectType)anObject;

- (void)removeObjectAtIndex:(NSUInteger)index;

- (void)removeObject:(ObjectType)anObject;

- (void)removeFirstObject;

- (void)removeLastObject;

- (void)removeObjectsInRange:(NSRange)range;

- (NSArray<ObjectType> *)toArray;

@end
