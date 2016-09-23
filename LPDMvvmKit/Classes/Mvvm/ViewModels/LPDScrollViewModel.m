//
//  LPDScrollViewModel.m
//  LPDMvvmKit
//
//  Created by foxsofter on 15/12/13.
//  Copyright © 2015年 eleme. All rights reserved.
//

#import "LPDScrollViewModel.h"
#import "ReactiveCocoa.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPDScrollViewModel ()

@end

@implementation LPDScrollViewModel

@synthesize loading = _loading;
@synthesize loadingSignal = _loadingSignal;
@synthesize loadingMore = _loadingMore;
@synthesize loadingMoreSignal = _loadingMoreSignal;
@synthesize reactState = _reactState;

#pragma mark - methods

- (void)setReactState:(LPDViewReactState)reactState withMessage:(nonnull NSString *)message {
  _reactState = reactState;
}

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
      if (error.code == -1001 || error.code == -1004) {
        self.reactState = LPDViewReactStateNetworkLatency;
      } else {
        [self.errorSubject sendNext:error.localizedDescription];
      }
    }];
  } else {
    _loadingSignal = nil;
  }
}

- (void)setLoadingMore:(BOOL)loadingMore {
  if (_loadingMore == loadingMore) {
    return;
  }
  _loadingMore = loadingMore;
  if (loadingMore && _loadingMoreSignal) {
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
      self.loadingMore = NO;
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
