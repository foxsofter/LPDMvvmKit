//
//  LPDNavigationViewModel.m
//  LPDMvvm
//
//  Created by foxsofter on 15/10/13.
//  Copyright © 2015年 foxsofter. All rights reserved.
//

#import "LPDNavigationViewModel.h"
#import "NSMutableArray+LPDWeak.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPDNavigationViewModel ()

@property (nullable, nonatomic, strong) NSMutableArray<id<LPDViewModelProtocol>> *weakViewModels;

@end

@implementation LPDNavigationViewModel

@synthesize presentedViewModel = _presentedViewModel;
@synthesize presentingViewModel = _presentingViewModel;
@synthesize tabBar = _tabBar;

#pragma mark - life cycle

- (instancetype)initWithRootViewModel:(__kindof id<LPDViewModelProtocol>)viewModel {
  self = [super init];
  if (self) {
    _weakViewModels = [NSMutableArray mutableArrayUsingWeakReferences];
    [_weakViewModels addObject:viewModel];
    viewModel.navigation = self;
    for (id<LPDViewModelProtocol> childViewModel in viewModel.childViewModels) {
      childViewModel.navigation = self;
    }
  }
  return self;
}

#pragma mark - navigation methods

- (void)pushViewModel:(__kindof id<LPDViewModelProtocol>)viewModel animated:(BOOL)animated {
}

- (void)popViewModelAnimated:(BOOL)animated {
}

- (void)popToViewModel:(__kindof id<LPDViewModelProtocol>)viewModel animated:(BOOL)animated {
}

- (void)popToRootViewModelAnimated:(BOOL)animated {
}

- (void)presentNavigationViewModel:(__kindof id<LPDNavigationViewModelProtocol>)viewModel
                          animated:(BOOL)animated
                        completion:(nullable void (^)())completion {
}

- (void)dismissNavigationViewModelAnimated:(BOOL)animated completion:(nullable void (^)())completion {
}

#pragma mark - properties

- (_Nullable __kindof id<LPDViewModelProtocol>)topViewModel {
  return [_weakViewModels lastObject];
}

- (_Nullable __kindof id<LPDViewModelProtocol>)visibleViewModel {
  if (_presentedViewModel) {
    return _presentedViewModel;
  }
  return [_weakViewModels lastObject];
}

- (void)setPresentedViewModel:(__kindof id<LPDNavigationViewModelProtocol> _Nullable)presentedViewModel {
  _presentedViewModel = presentedViewModel;
}

- (NSArray<__kindof id<LPDViewModelProtocol>> *)viewModels {
  return [_weakViewModels copy];
}

#pragma mark - reactive navigation methods

- (void)_pushViewModel:(__kindof id<LPDViewModelProtocol>)viewModel {
  [_weakViewModels addObject:viewModel];
  viewModel.navigation = self;
  for (id<LPDViewModelProtocol> childViewModel in viewModel.childViewModels) {
    childViewModel.navigation = self;
  }
}

- (void)_popViewModel {
  if (_weakViewModels.count > 1) {
    [_weakViewModels removeLastObject];
  }
}

- (void)popToViewModel:(__kindof id<LPDViewModelProtocol>)viewModel {
    if (_weakViewModels.count > 1) {
        // 耗时过久，需要异步执行
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSUInteger i = _weakViewModels.count - 1;
            for (; i > 0; i--) {
                id<LPDViewModelProtocol> vm = _weakViewModels[i];
                if (vm == viewModel) {
                    break;
                }
            }
            if (i > 0 && i < _weakViewModels.count - 1) {
                [_weakViewModels removeObjectsInRange:NSMakeRange(i + 1, _weakViewModels.count - i - 1)];
            }
        });
    }
}

- (void)_popToRootViewModel {
  if (_weakViewModels.count > 1) {
    // 耗时过久，需要异步执行
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      if (_weakViewModels.count > 1) {
          [_weakViewModels removeObjectsInRange:NSMakeRange(1, _weakViewModels.count - 1)];
      }
    });
  }
}

- (void)_presentNavigationViewModel:(__kindof id<LPDNavigationViewModelProtocol>)viewModel {
  _presentedViewModel = viewModel;
  _presentedViewModel.presentingViewModel = self;
}

- (void)_dismissNavigationViewModel {
  if (_presentedViewModel) {
    [_presentedViewModel
      dismissNavigationViewModelAnimated:NO
                    completion:^{
                      self.presentingViewModel = nil;
                    }];
  } else {
    _presentingViewModel.presentedViewModel = nil;
  }
}
@end

NS_ASSUME_NONNULL_END
