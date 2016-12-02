//
//  LKPropertyHook.m
//  LKUserDefaults
//
//  Created by Hiroshi Hashiguchi on 2014/01/08.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "LKPropertyHook.h"
#import <objc/runtime.h>

@interface LKPropertyHook ()
@property (strong, nonatomic) NSObject *target;
@end

@implementation LKPropertyHook

#pragma mark - Basics
- (instancetype)initWithTarget:(NSObject *)target {
  self.target = target;
  return target ? self : nil;
}

#pragma mark - Privates
- (id)_getArgumentAtIndex:(NSInteger)index invocation:(NSInvocation *)invocation {
  const char *valueType = [invocation.methodSignature getArgumentTypeAtIndex:index];
  while (strchr("rnNoORV", valueType[0]) != NULL) {
    valueType += 1;
  }

  switch (valueType[0]) {
    case 'c': {
      char value;
      [invocation getArgument:&value atIndex:index];
      return [NSNumber numberWithChar:value];
    }
    case 'i': {
      int value;
      [invocation getArgument:&value atIndex:index];
      return [NSNumber numberWithInt:value];
    }
    case 's': {
      short value;
      [invocation getArgument:&value atIndex:index];
      return [NSNumber numberWithShort:value];
    }
    case 'l': {
      long value;
      [invocation getArgument:&value atIndex:index];
      return [NSNumber numberWithLong:value];
    }
    case 'q': {
      long long value;
      [invocation getArgument:&value atIndex:index];
      return [NSNumber numberWithLongLong:value];
    }
    case 'C': {
      unsigned char value;
      [invocation getArgument:&value atIndex:index];
      return [NSNumber numberWithUnsignedChar:value];
    }
    case 'I': {
      unsigned int value;
      [invocation getArgument:&value atIndex:index];
      return [NSNumber numberWithUnsignedInt:value];
    }
    case 'S': {
      unsigned short value;
      [invocation getArgument:&value atIndex:index];
      return [NSNumber numberWithUnsignedShort:value];
    }
    case 'L': {
      unsigned long value;
      [invocation getArgument:&value atIndex:index];
      return [NSNumber numberWithUnsignedLong:value];
    }
    case 'Q': {
      unsigned long long value;
      [invocation getArgument:&value atIndex:index];
      return [NSNumber numberWithUnsignedLongLong:value];
    }
    case 'f': {
      float value;
      [invocation getArgument:&value atIndex:index];
      return [NSNumber numberWithFloat:value];
    }
    case 'd': {
      double value;
      [invocation getArgument:&value atIndex:index];
      return [NSNumber numberWithDouble:value];
    }
    case 'B': {
      bool value;
      [invocation getArgument:&value atIndex:index];
      return [NSNumber numberWithBool:value];
    }
    case '#':
    case '@': {
      // NOTE: must set __unsage_unretained
      // @see
      // http://stackoverflow.com/questions/8672675/why-does-the-arc-migrator-say-that-nsinvocations-setargument-is-not-safe-unle
      __unsafe_unretained id value;
      [invocation getArgument:&value atIndex:index];
      return value;
    }
  }
  return nil;
}

- (void)_setReturnValue:(id)value invocation:(NSInvocation *)invocation {
  const char *valueType = [invocation.methodSignature methodReturnType];
  while (strchr("rnNoORV", valueType[0]) != NULL) {
    valueType += 1;
  }

  switch (valueType[0]) {
    case 'c': {
      char ret = [value isKindOfClass:NSNumber.class] ? ((NSNumber *)value).charValue : 0;
      [invocation setReturnValue:&ret];
      break;
    }
    case 'i': {
      int ret = [value isKindOfClass:NSNumber.class] ? ((NSNumber *)value).intValue : 0;
      [invocation setReturnValue:&ret];
      break;
    }
    case 's': {
      short ret = [value isKindOfClass:NSNumber.class] ? ((NSNumber *)value).shortValue : 0;
      [invocation setReturnValue:&ret];
      break;
    }
    case 'l': {
      long ret = [value isKindOfClass:NSNumber.class] ? ((NSNumber *)value).longValue : 0;
      [invocation setReturnValue:&ret];
      break;
    }
    case 'q': {
      long long ret = [value isKindOfClass:NSNumber.class] ? ((NSNumber *)value).longLongValue : 0;
      [invocation setReturnValue:&ret];
      break;
    }
    case 'C': {
      unsigned char ret = [value isKindOfClass:NSNumber.class] ? ((NSNumber *)value).unsignedCharValue : 0;
      [invocation setReturnValue:&ret];
      break;
    }
    case 'I': {
      unsigned int ret = [value isKindOfClass:NSNumber.class] ? ((NSNumber *)value).unsignedIntValue : 0;
      [invocation setReturnValue:&ret];
      break;
    }
    case 'S': {
      unsigned short ret = [value isKindOfClass:NSNumber.class] ? ((NSNumber *)value).unsignedShortValue : 0;
      [invocation setReturnValue:&ret];
      break;
    }
    case 'L': {
      unsigned long ret = [value isKindOfClass:NSNumber.class] ? ((NSNumber *)value).unsignedLongValue : 0;
      [invocation setReturnValue:&ret];
      break;
    }
    case 'Q': {
      unsigned long long ret = [value isKindOfClass:NSNumber.class] ? ((NSNumber *)value).unsignedLongLongValue : 0;
      [invocation setReturnValue:&ret];
      break;
    }
    case 'f': {
      float ret = [value isKindOfClass:NSNumber.class] ? ((NSNumber *)value).floatValue : 0;
      [invocation setReturnValue:&ret];
      break;
    }
    case 'd': {
      double ret = [value isKindOfClass:NSNumber.class] ? ((NSNumber *)value).doubleValue : 0;
      [invocation setReturnValue:&ret];
      break;
    }
    case 'B': {
      bool ret = [value isKindOfClass:NSNumber.class] ? ((NSNumber *)value).boolValue : 0;
      [invocation setReturnValue:&ret];
      break;
    }
    case '#':
    case '@': {
      [invocation setReturnValue:&value];
      break;
    }
  }
}

#pragma mark - NSProxy
- (void)forwardInvocation:(NSInvocation *)invocation {
  if (self.target) {
    invocation.target = self.target;

    NSString *selectorName = NSStringFromSelector(invocation.selector);
    NSString *key = nil;

    if (invocation.methodSignature.numberOfArguments > 2) {
      // setter
      // "set" + <Key> + ":"
      key = [selectorName substringWithRange:NSMakeRange(3, selectorName.length - (3 + 1))];
      key = [[key substringToIndex:1].lowercaseString stringByAppendingString:[key substringFromIndex:1]];
      id value = [self _getArgumentAtIndex:2 invocation:invocation];
      [self setPropertyValue:value forKey:key];

    } else {
      // getter
      key = selectorName;
      id ret = [self getPropertyValueForKey:key];
      [self _setReturnValue:ret invocation:invocation];
    }
  }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
  return self.target ? [self.target methodSignatureForSelector:sel] : [super methodSignatureForSelector:sel];
}

#pragma mark - Overwritten in subclass
- (NSString *)classNameForKey:(NSString *)key {
  // ex) T@"NSString",&,N,V_stringValue
  //   -> objc_property_attribute_t
  //     key=T, value=@"NSString"
  //     key=&, value=
  //     key=N, value=
  //     key=V, value=_stringValue

  NSString *className = nil;

  objc_property_t property = class_getProperty(self.target.class, key.UTF8String);
  const char *value = property_copyAttributeValue(property, "T");
  if (value && value[0] == '@') {
    NSString *valueString = [NSString stringWithUTF8String:&value[1]];
    className = [valueString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
  }
  free(value);

  return className;
}

#pragma mark - Overwritten in subclass
- (void)setPropertyValue:(id)value forKey:(NSString *)key {
  // not implemented
}
- (id)getPropertyValueForKey:(NSString *)key {
  // not implemented
  return nil;
}

@end
