//
//  LKUserDefaultsProxy.m
//  LKUserDefaults
//
//  Created by Hiroshi Hashiguchi on 2014/01/08.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//
#import "LKUserDefaults.h"
#import "LKUserDefaultsProxy.h"

@interface LKUserDefaultsProxy ()
@property (weak, nonatomic) LKUserDefaults *userDefaults;
@end

@implementation LKUserDefaultsProxy

#pragma mark - API
- (id)initWithUserDefaults:(LKUserDefaults *)userDefaults {
  self = [super initWithTarget:userDefaults];
  if (self) {
    self.userDefaults = userDefaults;
  }
  return self;
}

#pragma mark - Overwritten in subclass
- (void)setPropertyValue:(id)value forKey:(NSString *)key {
  if ([value isKindOfClass:NSURL.class]) {
    [NSUserDefaults.standardUserDefaults setURL:value forKey:key];
  } else {
    [NSUserDefaults.standardUserDefaults setObject:value forKey:key];
  }
  [NSUserDefaults.standardUserDefaults synchronize];
}

- (id)getPropertyValueForKey:(NSString *)key {
  NSString *className = [self classNameForKey:key];
  id ret = nil;

  if ([className isEqualToString:@"NSURL"]) {
    ret = [NSUserDefaults.standardUserDefaults URLForKey:key];
  } else {
    ret = [NSUserDefaults.standardUserDefaults objectForKey:key];
  }
  if (ret == nil) {
    ret = [self.userDefaults valueForKey:key];
  }

  return ret;
}

@end
