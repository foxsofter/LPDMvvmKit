//
//  LPDNavigationController.h
//  LPDMvvm
//
//  Created by foxsofter on 15/10/11.
//  Copyright © 2015年 foxsofter. All rights reserved.
//

#import "LPDNavigationControllerProtocol.h"
#import "LPDViewControllerRouter.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LPDNavigationController : UINavigationController <LPDNavigationControllerProtocol>

/**
 *  @brief 禁用无关函数
 */
+ (instancetype) new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithNavigationBarClass:(nullable Class)navigationBarClass
                              toolbarClass:(nullable Class)toolbarClass NS_UNAVAILABLE;
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil
                         bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController NS_UNAVAILABLE;

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated NS_UNAVAILABLE;
- (nullable UIViewController *)popViewControllerAnimated:(BOOL)animated NS_UNAVAILABLE;
- (nullable NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController
                                                              animated:(BOOL)animated NS_UNAVAILABLE;
- (nullable NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated NS_UNAVAILABLE;
- (void)presentViewController:(UIViewController *)viewControllerToPresent
                     animated:(BOOL)flag
                   completion:(void (^__nullable)(void))completion NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END