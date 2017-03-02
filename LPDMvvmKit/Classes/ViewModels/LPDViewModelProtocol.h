//
//  LPDViewModelProtocol.h
//  LPDMvvm
//
//  Created by foxsofter on 15/10/10.
//  Copyright © 2015年 foxsofter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPDViewModelBecomeActiveProtocol.h"
#import "LPDViewModelDidLoadViewProtocol.h"
#import "LPDViewModelDidLayoutSubviewsProtocol.h"
#import "LPDViewModelLoadingProtocol.h"
#import "LPDViewModelSubmittingProtocol.h"
#import "LPDViewModelToastProtocol.h"
#import "LPDViewModelEmptyProtocol.h"
#import "LPDViewModelNetworkStatusProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LPDNavigationViewModelProtocol;
@protocol LPDTabBarViewModelProtocol;

@protocol LPDViewModelProtocol <LPDViewModelBecomeActiveProtocol,
                                LPDViewModelDidLoadViewProtocol,
                                LPDViewModelDidLayoutSubviewsProtocol,
                                LPDViewModelLoadingProtocol,
                                LPDViewModelSubmittingProtocol,
                                LPDViewModelToastProtocol,
                                LPDViewModelEmptyProtocol,
                                LPDViewModelNetworkStatusProtocol>

@required

/**
 *  @brief navigation bar title
 */
@property (nullable, nonatomic, copy) NSString *title;

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
 *  @brief childViewModels，从对应viewController中的addChildViewController方法可以添加
 *  或者通过viewModel的addChildViewModel方法添加
 */
@property (nonatomic, copy, readonly) NSArray<id<LPDViewModelProtocol>> *childViewModels;

@property (nonatomic, weak, readonly) id<LPDViewModelProtocol> parentViewModel;

/**
 *  @brief navigation view model
 */
@property (nullable, nonatomic, weak) __kindof id<LPDNavigationViewModelProtocol> navigation;

@end

NS_ASSUME_NONNULL_END
