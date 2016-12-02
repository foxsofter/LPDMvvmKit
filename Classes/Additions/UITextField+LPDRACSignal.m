//
//  UITextField+LPDRACSignal.m
//  LPDMvvmKit
//
//  Created by foxsofter on 16/4/22.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "RACDelegateProxy.h"
#import "UITextField+LPDRACSignal.h"
#import <objc/runtime.h>

@implementation UITextField (LPDRACSignal)

- (RACDelegateProxy *)rac_delegateProxy {
  RACDelegateProxy *proxy = objc_getAssociatedObject(self, _cmd);
  if (proxy == nil) {
    proxy = [[RACDelegateProxy alloc] initWithProtocol:@protocol(UITextFieldDelegate)];
    objc_setAssociatedObject(self, _cmd, proxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  }
  if (self.delegate != self.rac_delegateProxy) {
    self.rac_delegateProxy.rac_proxiedDelegate = self.delegate;
    self.delegate = (id)self.rac_delegateProxy;
  }
  return proxy;
}

@end
