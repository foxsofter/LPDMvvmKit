//
//  LPDNavigationViewModel.m
//  LPDMvvm
//
//  Created by foxsofter on 15/10/13.
//  Copyright © 2015年 foxsofter. All rights reserved.
//

#import "LPDNavigationViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPDNavigationViewModel ()

@property (nonatomic, strong, readwrite) NSMutableArray<__kindof id<LPDViewModelProtocol>> *viewModels;

//@property (nonatomic, strong, readwrite) __kindof id<LPDNavigationViewModelProtocol> presentedViewModel;
//@property (nonatomic, strong, readwrite) __kindof id<LPDNavigationViewModelProtocol> presentingViewModel;

@end

@implementation LPDNavigationViewModel

@synthesize presentedViewModel = _presentedViewModel;
@synthesize presentingViewModel = _presentingViewModel;

#pragma mark - life cycle

- (instancetype)initWithRootViewModel:(__kindof id<LPDViewModelProtocol>)viewModel {
  self = [super init];
  if (self) {
    _viewModels = [NSMutableArray array];
    [_viewModels addObject:viewModel];
    viewModel.navigation = self;
  }
  return self;
}

#pragma mark - navigation methods

- (void)pushViewModel:(__kindof id<LPDViewModelProtocol>)viewModel animated:(BOOL)animated {
}

- (void)popViewModelAnimated:(BOOL)animated {
}

- (void)popToRootViewModelAnimated:(BOOL)animated {
}

- (void)presentViewModel:(__kindof id<LPDNavigationViewModelProtocol>)viewModel
                animated:(BOOL)animated
              completion:(nullable void (^)())completion {
}

- (void)dismissViewModelAnimated:(BOOL)animated completion:(nullable void (^)())completion {
}

#pragma mark - properties

- (_Nullable __kindof id<LPDViewModelProtocol>)topViewModel {
  return [_viewModels lastObject];
}

- (_Nullable __kindof id<LPDViewModelProtocol>)visibleViewModel {
  if (_presentedViewModel) {
    return _presentedViewModel;
  }
  return [_viewModels lastObject];
}

- (NSArray<__kindof id<LPDViewModelProtocol>> *)viewModels {
  return [_viewModels copy];
}

- (void)setPresentedViewModel:(__kindof id<LPDNavigationViewModelProtocol> _Nullable)presentedViewModel {
  _presentedViewModel = presentedViewModel;
}

#pragma mark - reactive navigation methods

- (void)_pushViewModel:(__kindof id<LPDViewModelProtocol>)viewModel {
  [_viewModels addObject:viewModel];
  viewModel.navigation = self;
}

- (void)_popViewModel {
  if (_viewModels.count > 1) {
    [_viewModels removeLastObject];
  }
}

- (void)_popToRootViewModel {
  if (_viewModels.count > 1) {
    _viewModels = [NSMutableArray arrayWithObject:_viewModels.firstObject];
  }
}

- (void)_presentViewModel:(__kindof id<LPDNavigationViewModelProtocol>)viewModel {
  _presentedViewModel = viewModel;
  _presentedViewModel.presentingViewModel = self;
}

- (void)_dismissViewModel {
  if (_presentedViewModel) {
    [_presentedViewModel
      dismissViewModelAnimated:NO
                    completion:^{
                      [((NSObject *)self.presentingViewModel) setNilValueForKey:@"presentedViewModel"];
                    }];
  } else {
    _presentingViewModel.presentedViewModel = nil;
  }
}
@end

NS_ASSUME_NONNULL_END
