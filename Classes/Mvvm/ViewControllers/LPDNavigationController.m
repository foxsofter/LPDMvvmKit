//
//  LPDNavigationController.m
//  LPDMvvm
//
//  Created by foxsofter on 15/10/11.
//  Copyright © 2015年 foxsofter. All rights reserved.
//

#import "LPDNavigationController.h"
#import "LPDNavigationViewModel.h"
#import "LPDNavigationViewModelProtocol.h"
#import "LPDViewController.h"
#import "LPDViewModelProtocol.h"
#import "NSObject+LPDThread.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "UIScreen+LPDAccessor.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPDNavigationController ()

@property (nonatomic, strong, readwrite) id<LPDNavigationViewModelProtocol> viewModel;

@property (nullable, nonatomic, weak, readwrite) __kindof id<LPDNavigationControllerProtocol>
  lpd_presentedViewController;

@end

@implementation LPDNavigationController

#pragma mark - life cycle

+ (void)load {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    [LPDViewControllerRouter setViewController:NSStringFromClass(LPDNavigationController.class)
                                  forViewModel:NSStringFromClass(LPDNavigationViewModel.class)];
  });
}

- (instancetype)initWithViewModel:(__kindof id<LPDNavigationViewModelProtocol>)viewModel {
  self = [super init];
  if (self) {
    self.viewModel = viewModel;

    LPDViewController *rootViewController = [LPDViewControllerRouter viewControllerForViewModel:viewModel.topViewModel];
    [self setViewControllers:@[rootViewController] animated:NO];
    @weakify(self);
    [[self rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(id x) {
      @strongify(self);
      [self synchronizeNavigationSignals];
    }];
  }
  return self;
}

#pragma mark - screen style

- (BOOL)shouldAutorotate {
  return super.topViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
  return super.topViewController.supportedInterfaceOrientations;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  return super.topViewController.preferredStatusBarStyle;
}

#pragma mark - navigation methods

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

- (void)lpd_pushViewController:(__kindof id<LPDViewControllerProtocol>)viewControllerToPush animated:(BOOL)animated {
  if (self.childViewControllers.count > 0) {
    ((UIViewController *)viewControllerToPush).hidesBottomBarWhenPushed = YES;
  }
  [(UINavigationController *)self pushViewController:viewControllerToPush animated:animated];
}

- (nullable __kindof id<LPDViewControllerProtocol>)lpd_popViewControllerAnimated:(BOOL)animated {
  return (id<LPDViewControllerProtocol>)[(UINavigationController *)self popViewControllerAnimated:animated];
}

- (nullable NSArray<__kindof id<LPDViewControllerProtocol>> *)lpd_popToRootViewControllerAnimated:(BOOL)animated {
  return [(UINavigationController *)self popToRootViewControllerAnimated:animated];
}

- (void)lpd_presentViewController:(__kindof id<LPDNavigationControllerProtocol>)viewControllerToPresent
                         animated:(BOOL)flag
                       completion:(void (^__nullable)(void))completion {
  self.lpd_presentedViewController = viewControllerToPresent;
  [(NSObject *)self.viewModel performSelector:@selector(_presentViewModel:)
                                   withObject:self.lpd_presentedViewController.viewModel];
  [super presentViewController:viewControllerToPresent animated:flag completion:completion];
}

- (void)lpd_dismissViewControllerAnimated:(BOOL)flag completion:(void (^__nullable)(void))completion {
  [(NSObject *)self.viewModel performSelector:@selector(_dismissViewModel)];
  self.lpd_presentedViewController = nil;
  [super dismissViewControllerAnimated:flag completion:completion];
}

#pragma clang diagnostic pop

#pragma mark - private methods

/**
 *  @brief  设置同步ViewModel的导航到ViewController的导航的信号
 */
- (void)synchronizeNavigationSignals {
  @weakify(self);
  [[[self rac_signalForSelector:@selector(pushViewController:animated:)]
    deliverOnMainThread] subscribeNext:^(RACTuple *tuple) {
    @strongify(self);
    __kindof id<LPDViewControllerProtocol> viewControllerToPush = tuple.first;
    if ([viewControllerToPush respondsToSelector:@selector(viewModel)] &&
        [self.viewModel respondsToSelector:@selector(_pushViewModel:)]) {
      [(NSObject *)self.viewModel performSelector:@selector(_pushViewModel:) withObject:viewControllerToPush.viewModel];
    }
  }];
  [[[(NSObject *)self.viewModel rac_signalForSelector:@selector(pushViewModel:animated:)] deliverOnMainThread]
    subscribeNext:^(RACTuple *tuple) {
      @strongify(self);
      id<LPDViewControllerProtocol> viewController =
        (id<LPDViewControllerProtocol>)[LPDViewControllerRouter viewControllerForViewModel:tuple.first];
      [self lpd_pushViewController:viewController animated:[tuple.second boolValue]];
    }];

  [[[self rac_signalForSelector:@selector(popViewControllerAnimated:)] deliverOnMainThread] subscribeNext:^(id x) {
    @strongify(self);
    if ([self.viewModel respondsToSelector:@selector(_popViewModel)]) {
      [(NSObject *)self.viewModel performSelector:@selector(_popViewModel)];
    }
  }];
  [[[(NSObject *)self.viewModel rac_signalForSelector:@selector(popViewModelAnimated:)] deliverOnMainThread]
    subscribeNext:^(RACTuple *tuple) {
      @strongify(self);
      [self lpd_popViewControllerAnimated:[tuple.first boolValue]];
    }];

  [[[self rac_signalForSelector:@selector(popToRootViewControllerAnimated:)] deliverOnMainThread]
    subscribeNext:^(id x) {
      @strongify(self);
      if ([self.viewModel respondsToSelector:@selector(_popToRootViewModel)]) {
        [(NSObject *)self.viewModel performSelector:@selector(_popToRootViewModel)];
      }
    }];
  [[[(NSObject *)self.viewModel rac_signalForSelector:@selector(popToRootViewModelAnimated:)] deliverOnMainThread]
    subscribeNext:^(RACTuple *tuple) {
      @strongify(self);
      [self lpd_popToRootViewControllerAnimated:[tuple.first boolValue]];
    }];

  [[[(NSObject *)self.viewModel rac_signalForSelector:@selector(presentViewModel:animated:completion:)]
    deliverOnMainThread] subscribeNext:^(RACTuple *tuple) {
    @strongify(self);
    NSParameterAssert(tuple.first);
    id<LPDNavigationControllerProtocol> viewController =
      [LPDViewControllerRouter viewControllerForViewModel:tuple.first];

    [self lpd_presentViewController:viewController animated:[tuple.second boolValue] completion:tuple.third];
  }];

  [[[(NSObject *)self.viewModel rac_signalForSelector:@selector(dismissViewModelAnimated:completion:)]
    deliverOnMainThread] subscribeNext:^(RACTuple *tuple) {
    @strongify(self);
    [self lpd_dismissViewControllerAnimated:[tuple.first boolValue] completion:tuple.second];
  }];
}

#pragma mark - properties

- (nullable __kindof id<LPDViewControllerProtocol>)lpd_topViewController {
  return (id<LPDViewControllerProtocol>)super.topViewController;
}

- (nullable __kindof id<LPDViewControllerProtocol>)lpd_visibleViewController {
  return self.lpd_presentedViewController ?: self.lpd_topViewController;
}

@end

NS_ASSUME_NONNULL_END
