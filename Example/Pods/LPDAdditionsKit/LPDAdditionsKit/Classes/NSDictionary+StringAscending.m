//
//  NSDictionary+StringAscending.m
//  LPDCrowdsource
//
//  Created by 沈强 on 16/3/17.
//  Copyright © 2016年 elm. All rights reserved.
//

#import "NSDictionary+StringAscending.h"

@implementation NSDictionary (StringAscending)
- (NSArray<NSString *> *)arrayStringAscending {
  return [self.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
    if ([obj1 isKindOfClass:[NSString class]] && [obj2 isKindOfClass:[NSString class]]) {
      return [obj1 compare:obj2];
    }
    return NSOrderedSame;
  }];
}
@end
