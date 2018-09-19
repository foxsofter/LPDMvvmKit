//
//  LPDNavigationControllerProtocol.h
//  LPDMvvm
//
//  Created by foxsofter on 15/10/13.
//  Copyright © 2015年 foxsofter. All rights reserved.
//

#import "LPDViewControllerProtocol.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LPDNavigationViewModelProtocol;

@protocol LPDNavigationControllerProtocol <NSObject>

@required

- (instancetype)initWithViewModel:(__kindof id<LPDNavigationViewModelProtocol>)viewModel;

@property (nullable, nonatomic, strong, readonly) __kindof id<LPDNavigationViewModelProtocol> viewModel;

- (void)presentNavigationController:(UINavigationController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^__nullable)(void))completion;

- (void)dismissNavigationControllerAnimated:(BOOL)flag completion:(void (^__nullable)(void))completion;

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;

- (nullable UIViewController *)popViewControllerAnimated:(BOOL)animated;

- (nullable NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated;

- (nullable NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated;

- (void)setViewControllers:(NSMutableArray <UIViewController *> *)viewControllers animated:(BOOL)animated;

@property (nullable, nonatomic, readonly, strong) UIViewController *topViewController;

@property (nullable, nonatomic, readonly, strong) UIViewController *visibleViewController;

@property (nonatomic, copy) NSArray<__kindof UIViewController *> *viewControllers;

@end

NS_ASSUME_NONNULL_END
