//
//  NSMutableArray+LPDWeak.h
//  Pods
//
//  Created by foxsofter on 17/2/13.
//
//

#import <Foundation/Foundation.h>

/**
 It's quite ingenius, using a Category to allow the creation of a mutable array
 that does no retain/release by backing it with a CFArray with proper callbacks.
 http://stackoverflow.com/questions/4692161/non-retaining-array-for-delegates
 */
@interface NSMutableArray (LPDWeak)

+ (instancetype)mutableArrayUsingWeakReferences;

+ (instancetype)mutableArrayUsingWeakReferencesWithCapacity:(NSUInteger)capacity;

@end
