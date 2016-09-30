//
//  LPDViewControllerProtocol.h
//  LPDMvvm
//
//  Created by foxsofter on 15/10/11.
//  Copyright © 2015年 foxsofter. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LPDViewModelProtocol;
@protocol LPDNavigationControllerProtocol;

@protocol LPDViewControllerProtocol <NSObject>

@required

- (instancetype)initWithViewModel:(__kindof id<LPDViewModelProtocol>)viewModel;

@property (nonatomic, strong, readonly) __kindof id<LPDViewModelProtocol> viewModel;

@property (nullable, nonatomic, strong) __kindof id<LPDNavigationControllerProtocol> navigation;

- (void)lpd_addChildViewController:(id<LPDViewControllerProtocol>)childViewController;

- (void)lpd_removeFromParentViewController;

@end

NS_ASSUME_NONNULL_END
