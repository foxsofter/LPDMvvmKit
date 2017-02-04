//
//  LPDScrollViewModel.m
//  LPDMvvmKit
//
//  Created by foxsofter on 15/12/13.
//  Copyright © 2015年 eleme. All rights reserved.
//

#import "LPDScrollViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>


NS_ASSUME_NONNULL_BEGIN

@interface LPDScrollViewModel ()

@end

@implementation LPDScrollViewModel

@synthesize loading = _loading;
@synthesize loadingSignal = _loadingSignal;
@synthesize loadingMoreState = _loadingMoreState;
@synthesize loadingMoreSignal = _loadingMoreSignal;

#pragma mark - properties

- (void)setLoading:(BOOL)loading {
  @synchronized(self) {
    if (_loading == loading) {
      return;
    }
    _loading = loading;
    if (loading && _loadingSignal) {
      [[_loadingSignal deliverOnMainThread] subscribeNext:^(id x){
      }];
    }
  }
}

- (void)setLoadingSignal:(nullable RACSignal *)loadingSignal {
  if (_loadingSignal == loadingSignal) {
    return;
  }
  @weakify(self);
  if (loadingSignal) {
    _loadingSignal = [[loadingSignal doCompleted:^{
      @strongify(self);
      self.loading = NO;
    }] doError:^(NSError *error) {
      @strongify(self);
      self.loading = NO;
      if (error.code == -1001 || error.code == -1004) { // 超时重试
        self.viewDisplayingState = LPDViewDisplayingStateRetry;
      } else {
        [self.errorSubject sendNext:error.localizedDescription];
      }
    }];
  } else {
    _loadingSignal = nil;
  }
}

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
