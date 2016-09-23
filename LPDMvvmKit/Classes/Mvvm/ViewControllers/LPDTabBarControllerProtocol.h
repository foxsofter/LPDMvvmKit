//
//  LPDTabBarControllerProtocol.h
//  LPDMvvm
//
//  Created by foxsofter on 15/10/13.
//  Copyright © 2015年 foxsofter. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@protocol LPDTabBarViewModelProtocol;

@protocol LPDTabBarControllerProtocol <NSObject>

@required

- (instancetype)initWithViewModel:(__kindof id<LPDTabBarViewModelProtocol>)viewModel;

@property (nullable, nonatomic, strong, readonly) __kindof id<LPDTabBarViewModelProtocol> viewModel;

@end

NS_ASSUME_NONNULL_END