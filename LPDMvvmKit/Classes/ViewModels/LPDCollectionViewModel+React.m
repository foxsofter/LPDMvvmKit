//
//  LPDCollectionViewModel+React.m
//  LPDMvvmKit
//
//  Created by foxsofter on 16/2/22.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import <objc/runtime.h>
#import "LPDCollectionViewModel+React.h"

@implementation LPDCollectionViewModel (React)

- (__kindof id<LPDViewModelProtocol>)viewModel {
  return objc_getAssociatedObject(self, @selector(setViewModel:));
}

- (void)setViewModel:(__kindof id<LPDViewModelProtocol> _Nullable)viewModel {
  objc_setAssociatedObject(self, @selector(setViewModel:), viewModel, OBJC_ASSOCIATION_ASSIGN);
}

- (RACSignal *)didLoadViewSignal {
  return [self.viewModel didLoadViewSignal];
}

- (RACSignal *)didLayoutSubviewsSignal {
  return [self.viewModel didLayoutSubviewsSignal];
}

- (RACSignal *)didBecomeActiveSignal {
  return [self.viewModel didBecomeActiveSignal];
}

- (RACSignal *)didBecomeInactiveSignal {
  return [self.viewModel didBecomeInactiveSignal];
}

- (LPDViewDisplayingState)viewDisplayingState {
  return [self.viewModel viewDisplayingState];
}

- (void)setViewDisplayingState:(LPDViewDisplayingState)viewDisplayingState {
  [self.viewModel setViewDisplayingState:viewDisplayingState];
}

- (BOOL)isSubmitting {
  return self.viewModel.isSubmitting;
}

- (void)setSubmitting:(BOOL)submitting {
  self.viewModel.submitting = submitting;
}

- (void)setSubmittingWithMessage:(NSString *)message {
  [self.viewModel setSubmittingWithMessage:message];
}

- (RACSubject *)successSubject {
  return self.viewModel.successSubject;
}

- (RACSubject *)errorSubject {
  return self.viewModel.errorSubject;
}

@end
