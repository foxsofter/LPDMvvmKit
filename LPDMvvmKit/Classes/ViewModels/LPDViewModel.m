//
//  LPDViewModel.m
//  LPDMvvm
//
//  Created by foxsofter on 15/10/10.
//  Copyright © 2015年 foxsofter. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "LPDViewModel.h"
#import "LPDWeakMutableArray.h"

@interface LPDViewModel ()

@property (nonatomic, strong, readwrite) RACSubject *successSubject;

@property (nonatomic, strong, readwrite) RACSubject *errorSubject;

@property (nonatomic, weak, readwrite) id<LPDViewModelProtocol> parentViewModel;

@property (nonatomic, strong) LPDWeakMutableArray<id<LPDViewModelProtocol>> *mutableChildViewModels;

@end

@implementation LPDViewModel

@synthesize title = _title;
@synthesize submitting = _submitting;
@synthesize networkState = _networkState;
@synthesize viewDisplayingState = _viewDisplayingState;
@synthesize navigation = _navigation;
@synthesize didLoadViewSignal = _didLoadViewSignal;
@synthesize didLayoutSubviewsSignal = _didLayoutSubviewsSignal;

#pragma mark - public methods

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

- (void)addChildViewModel:(id<LPDViewModelProtocol>)childViewModel {
  [self _addChildViewModel:childViewModel];
}

- (void)removeFromParentViewModel {
}

/**
 *  @param message message会在LPDViewController的Signal中处理
 */
- (void)setSubmittingWithMessage:(NSString *)message {
  _submitting = YES;
}

- (void)setViewDisplayingState:(LPDViewDisplayingState)viewDisplayingState withMessage:(NSString *)message {
  _viewDisplayingState = viewDisplayingState;
}

#pragma mark - properties

- (RACSubject *)successSubject {
  return _successSubject ?: (_successSubject = [RACSubject subject]);
}

- (RACSubject *)errorSubject {
  return _errorSubject ?: (_errorSubject = [RACSubject subject]);
}

- (NSArray<id<LPDViewModelProtocol>> *)childViewModels {
  return [_mutableChildViewModels copy];
}

#pragma mark - private methods

- (void)_addChildViewModel:(id<LPDViewModelProtocol>)childViewModel {
  if (!self.mutableChildViewModels) {
    self.mutableChildViewModels = [LPDWeakMutableArray array];
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
