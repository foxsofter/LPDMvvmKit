//
//  UINavigationItem+LPDAddition.m
//  LPDAdditions
//
//  Created by foxsofter on 15/10/10.
//  Copyright © 2015年 foxsofter. All rights reserved.
//

#import "NSObject+LPDSwizzling.h"
#import "UINavigationItem+LPDAddition.h"

@implementation UINavigationItem (LPDAddition)

+ (void)load {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    SEL oldSelector = @selector(backBarButtonItem);
    SEL newSelector = @selector(ws_backBarButtonItem);

    [self instanceSwizzle:oldSelector newSelector:newSelector];
  });
}

- (UIBarButtonItem * _Nonnull)ws_backBarButtonItem {
  return [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:NULL];
}

@end
