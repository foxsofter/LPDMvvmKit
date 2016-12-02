//
//  LPDViewModelProtocol.h
//  LPDMvvm
//
//  Created by foxsofter on 15/10/10.
//  Copyright © 2015年 foxsofter. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LPDViewModelReactProtocol.h"
#import "RACSignal.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LPDNavigationViewModelProtocol;
@protocol LPDTabBarViewModelProtocol;

@protocol LPDViewModelProtocol <LPDViewModelReactProtocol>

@required

/**
 *  @brief navigation bar title
 */
@property (nullable, nonatomic, copy) NSString *title;

/**
 *  @brief 是否激活
 */
@property (nonatomic, assign, getter=isActive) BOOL active;

/**
 *  @brief 添加childViewModel，如果此viewModel对应的viewController还没有加载，
 *  则会先加载到childViewModels中，等对应的viewController加载后会将所有childViewModels
 *  中的viewModel对应的的viewController加载
 */
- (void)addChildViewModel:(id<LPDViewModelProtocol>)childViewModel;

/**
 *  @brief 从父viewModel中移除
 */
- (void)removeFromParentViewModel;

/**
 *  @brief childViewModels，从对应viewController中的lpd_addChildViewController方法可以添加
 *  或者通过viewModel的addChildViewModel方法添加
 */
@property (nonatomic, copy, readonly) NSArray<id<LPDViewModelProtocol>> *childViewModels;

@property (nonatomic, weak, readonly) id<LPDViewModelProtocol> parentViewModel;

/**
 *  @brief navigation view model
 */
@property (nullable, nonatomic, strong) __kindof id<LPDNavigationViewModelProtocol> navigation;

@optional

/**
 *  @brief tabBar view model
 */
@property (nullable, nonatomic, strong) __kindof id<LPDTabBarViewModelProtocol> tabBar;

@end

NS_ASSUME_NONNULL_END
