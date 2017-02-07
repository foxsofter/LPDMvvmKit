//
//  LPDWeakArray.m
//  LPDMvvmKit
//
//  Created by foxsofter on 17/2/3.
//
//

#import "LPDWeakArray.h"

@interface LPDWeakArray ()

@property (nonatomic, strong) NSPointerArray *insideArray;

@end

@implementation LPDWeakArray

+ (instancetype)array {
  return [[self alloc] init];
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _insideArray = [[NSPointerArray alloc] initWithOptions:NSPointerFunctionsWeakMemory | NSPointerFunctionsObjectPersonality];
  }
  return self;
}

- (NSUInteger)count {
  return self.insideArray.count;
}

- (id)objectAtIndex:(NSUInteger)index {
  return [self.insideArray pointerAtIndex:index];
}

- (id)firstObject {
  if (self.insideArray.count > 0) {
    return [self.insideArray pointerAtIndex:0];
  }
  return nil;
}

- (id)lastObject {
  if (self.insideArray.count > 0) {
    return [self.insideArray pointerAtIndex:self.insideArray.count - 1];
  }
  return nil;
}

- (BOOL)containsObject:(id)anObject {
  for (id object in self.insideArray) {
    if (anObject == object) {
      return YES;
    }
  }
  return NO;
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx {
  return [self.insideArray pointerAtIndex:index];
}

- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx {
  if (idx < self.insideArray.count && idx >= 0) {
    [self.insideArray replacePointerAtIndex:idx withPointer:(__bridge void * _Nullable)(obj)];
  }
}

- (void)addObject:(id)anObject {
  [self.insideArray addPointer:(__bridge void * _Nullable)(anObject)];
}
- (void)insertObject:(id)anObject atIndex:(NSUInteger)index {
  [self.insideArray insertPointer:(__bridge void * _Nullable)(anObject) atIndex:index];
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
  if (index < self.insideArray.count && index >= 0) {
    [self.insideArray replacePointerAtIndex:index withPointer:(__bridge void * _Nullable)(anObject)];
  }
}

- (void)removeObjectAtIndex:(NSUInteger)index {
  [self.insideArray removePointerAtIndex:index];
}

- (void)removeObject:(id)anObject {
  for (NSUInteger i = self.insideArray.count - 1; i >= 0; i--) {
    id object = [self.insideArray pointerAtIndex:i];
    if (object == anObject) {
      [self.insideArray removePointerAtIndex:i];
      break;
    }
  }
}

- (void)removeFirstObject {
  if (self.insideArray.count > 0) {
    [self.insideArray removePointerAtIndex:0];
  }
}

- (void)removeLastObject {
  if (self.insideArray.count > 0) {
    [self.insideArray removePointerAtIndex:self.insideArray.count - 1];
  }
}

- (void)removeObjectsInRange:(NSRange)range {
  if (self.insideArray.count > 0) {
    for (NSUInteger i = self.insideArray.count - 1; i >= 0; i--) {
      if (NSLocationInRange(i, range)) {
        [self.insideArray removePointerAtIndex:i];
      }
    }
  }
}

- (NSArray *)toArray {
  return [self.insideArray allObjects];
}

#pragma mark - NSFastEnumeration

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
                                  objects:(id _Nullable __unsafe_unretained [])buffer
                                    count:(NSUInteger)len {
  return [self.insideArray countByEnumeratingWithState:state objects:buffer count:len];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
  LPDWeakArray *copy = [[self.class allocWithZone:zone] init];
  copy->_insideArray = [self.insideArray copyWithZone:zone];
  return copy;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {
  [aCoder encodeObject:self.insideArray forKey:@"insideArray"];
}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super init];
  if (self) {
    self.insideArray = [aDecoder decodeObjectForKey:@"insideArray"];
  }
  return self;
}


@end
