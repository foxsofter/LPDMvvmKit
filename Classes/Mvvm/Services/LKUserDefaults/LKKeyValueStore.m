//
//  LKKeyValueStore.m
//  LKUserDefaults
//
//  Created by Hiroshi Hashiguchi on 2014/01/10.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "LKKeyValueStore.h"

@implementation LKKeyValueStore

#pragma mark - API
+ (instancetype)sharedInstance {
  static NSMutableDictionary *_proxies;

  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _proxies = @{}.mutableCopy;
  });

  id proxy = nil;

  @synchronized(self) {
    NSString *proxyKey = NSStringFromClass(self.class);

    proxy = _proxies[proxyKey];
    if (proxy == nil) {
      proxy = self.proxyInstance;
      _proxies[proxyKey] = proxy;
    }
  }
  return proxy;
}

//- (id)initWithTarget
//{
//    return proxy
//}

#pragma mark - Callback (must be overwritten in subclass)
+ (id)proxyInstance {
  // do nothing
  return nil;
}

#pragma mark - API (Should be overwritten in subclass)
+ (void)removeUserDefaults {
  // do nothing
}

@end
