//
//  NSMutableArray+LPDWeak.m
//  Pods
//
//  Created by foxsofter on 17/2/13.
//
//

#import "NSMutableArray+LPDWeak.h"

@implementation NSMutableArray (LPDWeak)

+ (instancetype)mutableArrayUsingWeakReferences {
  return [self mutableArrayUsingWeakReferencesWithCapacity:0];
}

+ (instancetype)mutableArrayUsingWeakReferencesWithCapacity:(NSUInteger)capacity {
  CFArrayCallBacks callbacks = {0, NULL, NULL, CFCopyDescription, CFEqual};
  // We create a weak reference array
  return CFBridgingRelease(CFArrayCreateMutable(0, capacity, &callbacks));
}

@end
