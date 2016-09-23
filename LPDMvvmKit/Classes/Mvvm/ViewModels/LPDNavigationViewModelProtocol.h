//
//  LPDNavigationViewModelProtocol.h
//  LPDMvvm
//
//  Created by foxsofter on 15/10/10.
//  Copyright © 2015年 foxsofter. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LPDViewModelProtocol;

@protocol LPDNavigationViewModelProtocol <NSObject>

@required

- (instancetype)initWithRootViewModel:(__kindof id<LPDViewModelProtocol>)viewModel;

@property (nullable, nonatomic, strong, readonly) __kindof id<LPDViewModelProtocol> topViewModel;

@property (nullable, nonatomic, strong, readonly) __kindof id<LPDViewModelProtocol> visibleViewModel;

@property (nullable, nonatomic, strong) __kindof id<LPDNavigationViewModelProtocol> presentedViewModel;

@property (nullable, nonatomic, strong) __kindof id<LPDNavigationViewModelProtocol> presentingViewModel;

@property (nonatomic, strong, readonly) NSArray<__kindof id<LPDViewModelProtocol>> *viewModels;

@optional

- (void)pushViewModel:(__kindof id<LPDViewModelProtocol>)viewModel animated:(BOOL)animated;

- (void)popViewModelAnimated:(BOOL)animated;

- (void)popToRootViewModelAnimated:(BOOL)animated;

- (void)presentViewModel:(__kindof id<LPDNavigationViewModelProtocol>)viewModel
                animated:(BOOL)animated
              completion:(nullable void (^)())completion;

- (void)dismissViewModelAnimated:(BOOL)animated completion:(nullable void (^)())completion;

@end

NS_ASSUME_NONNULL_END