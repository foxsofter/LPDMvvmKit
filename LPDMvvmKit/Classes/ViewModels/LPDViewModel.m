//
//  LPDViewModel.m
//  LPDMvvm
//
//  Created by foxsofter on 15/10/10.
//  Copyright © 2015年 foxsofter. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "LPDViewModel.h"
#import "LPDWeakArray.h"

@interface LPDViewModel ()

@property (nonatomic, weak, readwrite) id<LPDViewModelProtocol> parentViewModel;

@property (nonatomic, strong) LPDWeakArray<id<LPDViewModelProtocol>> *mutableChildViewModels;

@end

@implementation LPDViewModel

@synthesize title = _title;
@synthesize empty = _empty;
@synthesize loading = _loading;
@synthesize loadingSignal = _loadingSignal;
@synthesize needRetryLoading = _needRetryLoading;
@synthesize didLoadView = _didLoadView;
@synthesize didLoadViewSignal = _didLoadViewSignal;
@synthesize didUnloadViewSignal = _didUnloadViewSignal;
@synthesize didLayoutSubviews = _didLayoutSubviews;
@synthesize didLayoutSubviewsSignal = _didLayoutSubviewsSignal;
@synthesize submitting = _submitting;
@synthesize successSubject = _successSubject;
@synthesize errorSubject = _errorSubject;
@synthesize networkState = _networkState;
@synthesize navigation = _navigation;

#pragma mark - LPDViewModelDidLoadViewProtocol

- (RACSignal *)didLoadViewSignal {
  if (_didLoadViewSignal == nil) {
    @weakify(self);
    _didLoadViewSignal = [[[RACObserve(self, didLoadView) filter:^(NSNumber *didLoadView) {
      return didLoadView.boolValue;
    }] map:^(id _) {
      @strongify(self);
      return self;
    }] setNameWithFormat:@"%@ -didLoadViewSignal", self];
  }
  return _didLoadViewSignal;
}

- (RACSignal *)didUnloadViewSignal {
  if (_didUnloadViewSignal == nil) {
    @weakify(self);
    _didUnloadViewSignal = [[[RACObserve(self, didLoadView) filter:^(NSNumber *didLoadView) {
      return (BOOL)(didLoadView.boolValue == NO);
    }] map:^(id _) {
      @strongify(self);
      return self;
    }] setNameWithFormat:@"%@ -didUnloadViewSignal", self];
  }
  return _didUnloadViewSignal;
}

#pragma mark - LPDViewModelDidLayoutSubviewsProtocol

- (RACSignal *)didLayoutSubviewsSignal {
  if (nil == _didLayoutSubviewsSignal) {
    @weakify(self);
    _didLayoutSubviewsSignal = [[[RACObserve(self, didLayoutSubviews) filter:^(NSNumber *didLayoutSubviews) {
      return didLayoutSubviews.boolValue;
    }] map:^(id _) {
      @strongify(self);
      return self;
    }] setNameWithFormat:@"%@ -didLayoutSubviewsSignal", self];
  }
  return _didLayoutSubviewsSignal;
}

#pragma mark - LPDViewModelSubmittingProtocol

- (void)setSubmittingWithMessage:(NSString *)message {
  _submitting = YES;
}

#pragma mark - LPDViewModelLoadingProtocol

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
        self.needRetryLoading = YES;
      } else {
        [self.errorSubject sendNext:error.localizedDescription];
      }
    }];
  } else {
    _loadingSignal = nil;
  }
}

#pragma mark - LPDViewModelToastProtocol

- (RACSubject *)successSubject {
  return _successSubject ?: (_successSubject = [RACSubject subject]);
}

- (RACSubject *)errorSubject {
  return _errorSubject ?: (_errorSubject = [RACSubject subject]);
}

#pragma mark - LPDViewModelEmptyProtocol

- (void)setEmptyWithDescription:(NSString *)description {
  _empty = YES;
}

#pragma mark - LPDViewModelProtocol

- (void)addChildViewModel:(id<LPDViewModelProtocol>)childViewModel {
  [self _addChildViewModel:childViewModel];
}

- (void)removeFromParentViewModel {
}

- (NSArray<id<LPDViewModelProtocol>> *)childViewModels {
  return [_mutableChildViewModels copy];
}

#pragma mark - private methods

- (void)_addChildViewModel:(id<LPDViewModelProtocol>)childViewModel {
  if (!self.mutableChildViewModels) {
    self.mutableChildViewModels = [LPDWeakArray array];
  }
  if (!childViewModel.parentViewModel && ![self.mutableChildViewModels containsObject:childViewModel]) {
    ((LPDViewModel *)childViewModel).parentViewModel = self;
    [self.mutableChildViewModels addObject:childViewModel];
  }
}

- (void)_removeFromParentViewModel {
  [((LPDViewModel *)self.parentViewModel).mutableChildViewModels removeObject:self];
  self.parentViewModel = nil;
}

- (void)dealloc {
  [_errorSubject sendCompleted];
  [_successSubject sendCompleted];
}

@end
