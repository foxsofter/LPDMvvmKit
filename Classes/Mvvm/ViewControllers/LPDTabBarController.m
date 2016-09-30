//
//  LPDTabBarController.m
//  LPDMvvm
//
//  Created by foxsofter on 15/10/11.
//  Copyright © 2015年 foxsofter. All rights reserved.
//

#import "LPDTabBarController.h"
#import "LPDTabBarViewModel.h"
#import "LPDViewControllerRouter.h"
#import "ReactiveCocoa.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPDTabBarController ()

@property (nonatomic, strong, readwrite) id<LPDTabBarViewModelProtocol> viewModel;

@end

@implementation LPDTabBarController

#pragma mark - life cycle

+ (void)load {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    [LPDViewControllerRouter setViewController:NSStringFromClass(LPDTabBarController.class)
                                  forViewModel:NSStringFromClass(LPDTabBarViewModel.class)];
  });
}

- (instancetype)initWithViewModel:(__kindof id<LPDTabBarViewModelProtocol>)viewModel {
  self = [super init];
  if (self) {
    self.viewModel = viewModel;

    NSMutableArray *viewControllers = [NSMutableArray array];
    for (id<LPDViewModelProtocol> childViewModel in self.viewModel.viewModels) {
      UIViewController *viewController = nil;
      if (childViewModel.navigation) {
        viewController = [LPDViewControllerRouter viewControllerForViewModel:childViewModel.navigation];
      } else {
        viewController = [LPDViewControllerRouter viewControllerForViewModel:childViewModel];
      }
      [viewControllers addObject:viewController];
    }
    self.viewControllers = viewControllers;

    RAC(self, selectedIndex) = RACObserve(self.viewModel, selectedIndex);
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.extendedLayoutIncludesOpaqueBars = YES;
}

#pragma mark - screen style

- (BOOL)shouldAutorotate {
  return self.selectedViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
  return self.selectedViewController.supportedInterfaceOrientations;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  return self.selectedViewController.preferredStatusBarStyle;
}

@end

NS_ASSUME_NONNULL_END
