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
#import "UIScreen+LPDAccessor.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <LPDAdditionsKit/LPDAdditionsKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController ()

@property (nullable, nonatomic, strong, readwrite) id<LPDNavigationViewModelProtocol> viewModel;

@end

@implementation UINavigationController (LPDNavigationController)

- (nullable __kindof id<LPDNavigationViewModelProtocol>)viewModel {
  return [self object:@selector(setViewModel:)];
}

- (void)setViewModel:(nullable __kindof id<LPDNavigationViewModelProtocol>)viewModel {
  [self setRetainNonatomicObject:viewModel withKey:@selector(setViewModel:)];
}

- (void)presentNavigationController:(UINavigationController *)viewControllerToPresent animated: (BOOL)flag completion:(void (^ __nullable)(void))completion {
  [self presentViewController:viewControllerToPresent animated:flag completion:completion];
}

- (void)dismissNavigationControllerAnimated: (BOOL)flag completion: (void (^ __nullable)(void))completion {
  [self dismissViewControllerAnimated:flag completion:completion];
}

@end

@implementation LPDNavigationController

#pragma mark - life cycle

+ (void)load {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    [LPDViewControllerFactory setViewController:NSStringFromClass(LPDNavigationController.class)
                                  forViewModel:NSStringFromClass(LPDNavigationViewModel.class)];
  });
}

- (void)loadView {
  NSString *xibPath = [[NSBundle mainBundle] pathForResource:NSStringFromClass(self.class) ofType:@"nib"];
  if (xibPath && xibPath.length > 0) {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil];
    if (views && views.count > 0) {
      self.view = views.lastObject;
      self.view.frame = UIScreen.bounds;
    } else {
      xibPath = nil;
    }
  }
  if (!xibPath) {
    [super loadView];
  }
}

- (instancetype)initWithViewModel:(__kindof id<LPDNavigationViewModelProtocol>)viewModel {
  self = [super init];
  if (self) {
    self.viewModel = viewModel;

    LPDViewController *rootViewController = [LPDViewControllerFactory viewControllerForViewModel:viewModel.topViewModel];
    [self setViewControllers:@[ rootViewController ] animated:NO];
    @weakify(self);
    [[self rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(id x) {
      @strongify(self);
      [self subscribePushSignals];
      [self subscribePopSignals];
      [self subscribePopToViewSignals];
      [self subscribePopToRootSignals];
      [self subscribePresentSignals];
      [self subscribeDismissSignals];
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

#pragma mark - private methods

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

/**
 *  @brief  设置同步ViewModel的导航到ViewController的导航的信号
 */
- (void)subscribePushSignals {
  @weakify(self);
  [[self rac_signalForSelector:@selector(pushViewController:animated:)]
    subscribeNext:^(RACTuple *tuple) {
    @strongify(self);
    __kindof id<LPDViewControllerProtocol> viewControllerToPush = tuple.first;
    if ([viewControllerToPush isKindOfClass:LPDViewController.class] &&
        [viewControllerToPush respondsToSelector:@selector(viewModel)] &&
        [self.viewModel respondsToSelector:@selector(_pushViewModel:)]) {
      [self.viewModel performSelector:@selector(_pushViewModel:) withObject:viewControllerToPush.viewModel];
    }
  }];
  [[[self.viewModel rac_signalForSelector:@selector(pushViewModel:animated:)] deliverOnMainThread]
    subscribeNext:^(RACTuple *tuple) {
      @strongify(self);
      id<LPDViewControllerProtocol> viewController =
        (id<LPDViewControllerProtocol>)[LPDViewControllerFactory viewControllerForViewModel:tuple.first];
      [self pushViewController:viewController animated:[tuple.second boolValue]];
    }];
}

- (void)subscribePopSignals {
  @weakify(self);
  [[self rac_signalForSelector:@selector(popViewControllerAnimated:)] subscribeNext:^(id x) {
    @strongify(self);
    if (self.viewControllers.count == [self.viewModel viewModels].count - 1 &&
        [self.viewModel respondsToSelector:@selector(_popViewModel)]) {
      [self.viewModel performSelector:@selector(_popViewModel)];
    }
  }];
  [[[self.viewModel rac_signalForSelector:@selector(popViewModelAnimated:)] deliverOnMainThread]
    subscribeNext:^(RACTuple *tuple) {
      @strongify(self);
      [self popViewControllerAnimated:[tuple.first boolValue]];
    }];
}

- (void)subscribePopToViewSignals {
  @weakify(self);
  [[self rac_signalForSelector:@selector(popToViewController:animated:)] subscribeNext:^(RACTuple *tuple) {
    @strongify(self);
    if ([self.viewModel respondsToSelector:@selector(_popToViewModel:)]) {
      id<LPDViewControllerProtocol> viewController = tuple.first;
      if ([viewController isKindOfClass:LPDViewController.class] &&
          [viewController respondsToSelector:@selector(viewModel)]) {
        [self.viewModel performSelector:@selector(_popToViewModel:) withObject:viewController.viewModel];
      }
    }
  }];
  [[[self.viewModel rac_signalForSelector:@selector(popToViewModel:animated:)] deliverOnMainThread]
   subscribeNext:^(RACTuple *tuple) {
     @strongify(self);
     id<LPDViewModelProtocol> viewModel = tuple.first;
     id<LPDViewControllerProtocol> viewController = nil;
     for (id<LPDViewControllerProtocol> vc in self.viewControllers) {
       if (vc.viewModel == viewModel) {
         viewController = vc;
         break;
       }
     }
     if (viewController) {
       [self popToViewController:viewController animated:[tuple.second boolValue]];
     }
   }];
}

- (void)subscribePopToRootSignals {
  @weakify(self);
  [[self rac_signalForSelector:@selector(popToRootViewControllerAnimated:)]
    subscribeNext:^(id x) {
      @strongify(self);
      if ([self.viewModel respondsToSelector:@selector(_popToRootViewModel)]) {
        [self.viewModel performSelector:@selector(_popToRootViewModel)];
      }
    }];
  [[[self.viewModel rac_signalForSelector:@selector(popToRootViewModelAnimated:)] deliverOnMainThread]
    subscribeNext:^(RACTuple *tuple) {
      @strongify(self);
      [self popToRootViewControllerAnimated:[tuple.first boolValue]];
      NSLog(@"%@",self.navigationController.viewControllers);
    }];
}

- (void)subscribePresentSignals {
  @weakify(self);
  [[self rac_signalForSelector:@selector(presentNavigationController:animated:completion:)]
   subscribeNext:^(id x) {
     @strongify(self);
     if ([self.viewModel respondsToSelector:@selector(_presentNavigationViewModel:)]) {
       [self.viewModel performSelector:@selector(_presentNavigationViewModel:) withObject:self.presentedViewController.viewModel];
     }
   }];
  [[[self.viewModel rac_signalForSelector:@selector(presentNavigationViewModel:animated:completion:)]
    deliverOnMainThread] subscribeNext:^(RACTuple *tuple) {
    @strongify(self);
    NSParameterAssert(tuple.first);
    id<LPDNavigationControllerProtocol> viewController =
      [LPDViewControllerFactory viewControllerForViewModel:tuple.first];

    [self presentNavigationController:viewController animated:[tuple.second boolValue] completion:tuple.third];
  }];
}

- (void)subscribeDismissSignals {
  @weakify(self);
  [[self rac_signalForSelector:@selector(dismissNavigationControllerAnimated:completion:)]
   subscribeNext:^(id x) {
     @strongify(self);
     if ([self.viewModel respondsToSelector:@selector(_dismissNavigationViewModel)]) {
       [self.viewModel performSelector:@selector(_dismissNavigationViewModel)];
     }
   }];
  [[[self.viewModel rac_signalForSelector:@selector(dismissNavigationViewModelAnimated:completion:)]
    deliverOnMainThread] subscribeNext:^(RACTuple *tuple) {
    @strongify(self);
    [self dismissNavigationControllerAnimated:[tuple.first boolValue] completion:tuple.second];
  }];
}

#pragma clang diagnostic pop


@end

NS_ASSUME_NONNULL_END
