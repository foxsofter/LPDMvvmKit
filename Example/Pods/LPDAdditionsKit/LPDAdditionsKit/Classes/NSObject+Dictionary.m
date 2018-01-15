//
//  NSObject+Dictionary.m
//  LPDCrowdsource
//
//  Created by sq on 15/11/5.
//  Copyright © 2015年 elm. All rights reserved.
//

#import "NSObject+Dictionary.h"
#import <objc/runtime.h>

@implementation NSObject (Dictionary)
- (NSDictionary *)propertyDictionary {
  NSMutableDictionary *dictionary = [@{} mutableCopy];
  unsigned int propertyCount;
  objc_property_t *properties = class_copyPropertyList(object_getClass(self), &propertyCount);
  for (int i = 0; i < propertyCount; i++) {
    objc_property_t property = properties[i];
    NSString *propertyName =
      [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
    id propertyValue = [self valueForKey:propertyName];
    if (propertyValue) {
      if ([propertyValue isKindOfClass:[NSObject class]]) {
        if ([propertyValue isKindOfClass:[NSArray class]]) {
          propertyValue = [propertyValue propertyArray];
        } else if ([propertyValue isKindOfClass:[NSNumber class]] || [propertyValue isKindOfClass:[NSString class]]) {
        } else {
          propertyValue = [propertyValue propertyDictionary];
        }
      }
      if (propertyValue) {
        [dictionary setValue:propertyValue forKey:propertyName];
      }
    }
  }
  free(properties);
  if (dictionary.allKeys.count == 0) {
    return nil;
  }
  return dictionary;
}

- (NSDictionary *)propertyToproperty {
  NSMutableDictionary *dictionary = [@{} mutableCopy];
  unsigned int propertyCount;
  objc_property_t *properties = class_copyPropertyList(object_getClass(self), &propertyCount);
  for (int i = 0; i < propertyCount; i++) {
    objc_property_t property = properties[i];
    NSString *propertyName =
      [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
    [dictionary setValue:propertyName forKey:propertyName];
  }
  free(properties);
  return dictionary;
}

- (NSArray *)propertyArray {
  NSMutableArray *propertyArray = [@[] mutableCopy];
  if ([self isKindOfClass:[NSArray class]]) {
    id propertyValue = nil;
    for (id obj in(NSArray *)self) {
      if ([obj isKindOfClass:[NSArray class]]) {
        propertyValue = [obj propertyArray];
      } else if ([obj isKindOfClass:[NSString class]]) {
        propertyValue = obj;
      } else {
        propertyValue = [obj propertyDictionary];
      }
      if (propertyValue) {
        [propertyArray addObject:propertyValue];
      }
    }
  }
  return propertyArray;
}

@end
