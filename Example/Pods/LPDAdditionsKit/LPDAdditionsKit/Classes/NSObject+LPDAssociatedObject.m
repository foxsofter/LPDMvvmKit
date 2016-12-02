//
//  NSObject+LPDAssociatedObject.m
//  LPDAdditions
//
//  Created by foxsofter on 15/2/23.
//  Copyright (c) 2015年 foxsofter. All rights reserved.
//

#import "NSObject+LPDAssociatedObject.h"
#import <objc/runtime.h>

@implementation NSObject (AssociatedObject)

- (id)object:(SEL)key {
  return objc_getAssociatedObject(self, key);
}

- (void)setRetainNonatomicObject:(id)object withKey:(SEL)key {
  objc_setAssociatedObject(self, key, object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setCopyNonatomicObject:(id)object withKey:(SEL)key {
  objc_setAssociatedObject(self, key, object, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setRetainObject:(id)object withKey:(SEL)key {
  objc_setAssociatedObject(self, key, object, OBJC_ASSOCIATION_RETAIN);
}

- (void)setCopyObject:(id)object withKey:(SEL)key {
  objc_setAssociatedObject(self, key, object, OBJC_ASSOCIATION_COPY);
}

@end
