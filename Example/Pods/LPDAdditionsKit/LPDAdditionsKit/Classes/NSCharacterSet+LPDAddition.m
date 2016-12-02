//
//  NSCharacterSet+LPDAddition.m
//  LPDAdditions
//
//  Created by foxsofter on 15/11/25.
//  Copyright © 2015年 foxsofter. All rights reserved.
//

#import "NSCharacterSet+LPDAddition.h"

#define UNICHAR_MAX (1ull << (CHAR_BIT * sizeof(unichar))) - 1

@implementation NSCharacterSet (LPDAddition)

- (NSSet *)toSet {
  NSData *data = [self bitmapRepresentation];
  uint8_t *ptr = (uint8_t *)[data bytes];
  NSMutableSet *set = [NSMutableSet set];
  // following from Apple's sample code
  for (unichar i = 0; i < UNICHAR_MAX; i++) {
    if (ptr[i >> 3] & (1u << (i & 7))) {
      [set addObject:[NSString stringWithCharacters:&i length:1]];
    }
  }
  return set;
}

@end
