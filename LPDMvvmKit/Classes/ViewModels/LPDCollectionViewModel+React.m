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

- (RACSignal *)didBecomeActiveSignal {
  return [self.viewModel didBecomeActiveSignal];
}

- (RACSignal *)didBecomeInactiveSignal {
  return [self.viewModel didBecomeInactiveSignal];
}

- (RACSignal *)didLoadViewSignal {
  return [self.viewModel didLoadViewSignal];
}

- (RACSignal *)didUnloadViewSignal {
  return [self.viewModel didUnloadViewSignal];
}

- (RACSignal *)didLayoutSubviewsSignal {
  return [self.viewModel didLayoutSubviewsSignal];
}

- (BOOL)isSubmitting {
  return [self.viewModel isSubmitting];
}

- (void)setSubmitting:(BOOL)submitting {
  [self.viewModel setSubmitting:submitting];
}

- (void)setSubmittingWithMessage:(NSString *)message {
  [self.viewModel setSubmittingWithMessage:message];
}

- (BOOL)isLoading {
  return [self.viewModel isLoading];
}

- (void)setLoading:(BOOL)loading {
  [self.viewModel setLoading:loading];
}

- (void)setLoadingSignal:(RACSignal *)loadingSignal {
  [self.viewModel setLoadingSignal:loadingSignal];
}

- (BOOL)needRetryLoading {
  return [self.viewModel needRetryLoading];
}

- (void)setNeedRetryLoading:(BOOL)needRetryLoading {
  [self.viewModel setNeedRetryLoading:needRetryLoading];
}

- (LPDLoadingMoreState)loadingMoreState {
  return [self.viewModel loadingMoreState];
}

- (void)setLoadingMoreState:(LPDLoadingMoreState)loadingMoreState {
  [self.viewModel setLoadingMoreState:loadingMoreState];
}

- (void)setLoadingMoreSignal:(RACSignal *)loadingMoreSignal {
  [self.viewModel setLoadingMoreSignal:loadingMoreSignal];
}

- (RACSubject *)successSubject {
  return [self.viewModel successSubject];
}

- (RACSubject *)errorSubject {
  return [self.viewModel errorSubject];
}

- (BOOL)isEmpty {
  return [self.viewModel isEmpty];
}

- (void)setEmpty:(BOOL)empty {
  [self.viewModel setEmpty:empty];
}

- (void)setEmptyWithDescription:(NSString *)description {
  [self.viewModel setEmptyWithDescription:description];
}

- (LPDNetworkState)networkState {
  return [self.viewModel networkState];
}

- (void)setNetworkState:(LPDNetworkState)networkState {
  [self.viewModel setNetworkState:networkState];
}

@end
