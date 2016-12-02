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

/**
 *  @brief constructor
 */
- (instancetype)initWithViewModel:(__kindof id<LPDNavigationViewModelProtocol>)viewModel;

/**
 *  @brief self viewModel
 */
@property (nullable, nonatomic, strong, readonly) __kindof id<LPDNavigationViewModelProtocol> viewModel;

/**
 *  @brief The top view controller on the stack.
 */
@property (nullable, nonatomic, weak, readonly) __kindof id<LPDViewControllerProtocol> lpd_topViewController;

/**
 *  @brief Return modal view controller if it exists. Otherwise the top view
 *   controller.
 */
@property (nullable, nonatomic, strong, readonly) __kindof id<LPDViewControllerProtocol> lpd_visibleViewController;

/**
 *  @brief Return presented controller.
 */
@property (nullable, nonatomic, weak, readonly) __kindof id<LPDNavigationControllerProtocol>
  lpd_presentedViewController;

/**
 *  @brief replacements for pushViewController:animated
 */
- (void)lpd_pushViewController:(__kindof id<LPDViewControllerProtocol>)viewControllerToPush animated:(BOOL)animated;

/**
 *  @brief replacements for popViewControllerAnimated
 */
- (nullable __kindof id<LPDViewControllerProtocol>)lpd_popViewControllerAnimated:(BOOL)animated;

/**
 *  @brief replacements for popToRootViewControllerAnimated
 */
- (nullable NSArray<__kindof id<LPDViewControllerProtocol>> *)lpd_popToRootViewControllerAnimated:(BOOL)animated;

/**
 *  @brief replacements for presentModalViewController:animated
 */
- (void)lpd_presentViewController:(__kindof id<LPDNavigationControllerProtocol>)viewControllerToPresent
                         animated:(BOOL)flag
                       completion:(void (^__nullable)(void))completion;

/**
 *  @brief UIViewController dismissViewControllerAnimated:completion
 */
- (void)lpd_dismissViewControllerAnimated:(BOOL)flag completion:(void (^__nullable)(void))completion;

@end

NS_ASSUME_NONNULL_END
