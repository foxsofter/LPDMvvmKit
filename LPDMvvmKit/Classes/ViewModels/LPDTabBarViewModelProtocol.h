//
//  LPDTabBarViewModelProtocol.h
//  LPDMvvm
//
//  Created by foxsofter on 15/10/13.
//  Copyright © 2015年 foxsofter. All rights reserved.
//

#import "LPDNavigationViewModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LPDTabBarViewModelProtocol <NSObject>

@required

- (instancetype)initWithViewModels:(NSArray<__kindof id<LPDNavigationViewModelProtocol>> *)viewModels;

@property (nonatomic, readonly, strong) __kindof id<LPDNavigationViewModelProtocol> selectedViewModel;

@property (nonatomic) NSUInteger selectedIndex;

@property (nonatomic, readonly, strong) NSMutableArray<__kindof id<LPDNavigationViewModelProtocol>> *viewModels;

@end

NS_ASSUME_NONNULL_END
