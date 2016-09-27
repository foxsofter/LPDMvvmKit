//
//  LPDViewModel.m
//  LPDMvvm
//
//  Created by foxsofter on 15/10/10.
//  Copyright © 2015年 foxsofter. All rights reserved.
//

#import "LPDViewModel.h"
#import "ReactiveCocoa.h"

@interface LPDViewModel ()

@property (nonatomic, strong, readwrite) RACSubject *successSubject;

@property (nonatomic, strong, readwrite) RACSubject *errorSubject;

@property (nonatomic, weak, readwrite) id<LPDViewModelProtocol> parentViewModel;

@property (nonatomic, strong) NSMutableArray<id<LPDViewModelProtocol>> *mutableChildViewModels;

@property (nonatomic, assign) BOOL viewDidLoad;

@property (nonatomic, assign) BOOL viewDidLayout;

@end

@implementation LPDViewModel

@synthesize title = _title;
@synthesize submitting = _submitting;
@synthesize networkState = _networkState;
@synthesize navigation = _navigation;
@synthesize tabBar = _tabBar;
@synthesize viewDidLoadSignal = _viewDidLoadSignal;
@synthesize viewDidLayoutSubviewsSignal = _viewDidLayoutSubviewsSignal;

#pragma mark - public methods

- (RACSignal *)viewDidLoadSignal {
  if (_viewDidLoadSignal == nil) {
    @weakify(self);
    _viewDidLoadSignal = [[[RACObserve(self, viewDidLoad) filter:^(NSNumber *viewDidLoad) {
      return viewDidLoad.boolValue;
    }] map:^(id _) {
      @strongify(self);
      return self;
    }] setNameWithFormat:@"%@ -viewDidLoadSignal", self];
  }
  return _viewDidLoadSignal;
}

- (RACSignal *)viewDidLayoutSubviewsSignal {
  if (nil == _viewDidLayoutSubviewsSignal) {
    @weakify(self);
    _viewDidLayoutSubviewsSignal = [[[RACObserve(self, viewDidLayout) filter:^(NSNumber *viewDidLayout) {
      return viewDidLayout.boolValue;
    }] map:^(id _) {
      @strongify(self);
      return self;
    }] setNameWithFormat:@"%@ -viewDidLayoutSubviewsSignal", self];
  }
  return _viewDidLayoutSubviewsSignal;
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
    self.mutableChildViewModels = [NSMutableArray array];
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

@end
