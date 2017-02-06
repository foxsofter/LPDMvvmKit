//
//  LPDScrollViewModel.m
//  LPDMvvmKit
//
//  Created by foxsofter on 15/12/13.
//  Copyright © 2015年 eleme. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "LPDScrollViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPDScrollViewModel ()

@end

@implementation LPDScrollViewModel

@synthesize loadingMoreState = _loadingMoreState;
@synthesize loadingMoreSignal = _loadingMoreSignal;

#pragma mark - properties

- (void)setLoadingMoreState:(LPDLoadingMoreState)loadingMoreState {
  if (_loadingMoreState == loadingMoreState) {
    return;
  }
  _loadingMoreState = loadingMoreState;
  if (_loadingMoreState && _loadingMoreSignal) {
    [[_loadingMoreSignal deliverOnMainThread] subscribeNext:^(id x){
    }];
  }
}

- (void)setLoadingMoreSignal:(nullable RACSignal *)loadingMoreSignal {
  if (_loadingMoreSignal == loadingMoreSignal) {
    return;
  }
  @weakify(self);
  if (loadingMoreSignal) {
    _loadingMoreSignal = [[loadingMoreSignal doCompleted:^{
      @strongify(self);
      self.loadingMoreState = LPDLoadingMoreStateEnd;
    }] doError:^(NSError *error) {
      @strongify(self);
      [self.errorSubject sendNext:error.localizedDescription];
    }];
  } else {
    _loadingMoreSignal = nil;
  }
}

@end

NS_ASSUME_NONNULL_END
