//
//  LPDTabBarViewModelProtocol.h
//  LPDMvvm
//
//  Created by foxsofter on 15/10/13.
//  Copyright © 2015年 foxsofter. All rights reserved.
//

#import "LPDViewModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LPDTabBarViewModelProtocol <NSObject>

@required

- (instancetype)initWithViewModels:(NSArray<__kindof id<LPDViewModelProtocol>> *)viewModels;

@property (nonatomic, readonly, strong) __kindof id<LPDViewModelProtocol> selectedViewModel;

@property (nonatomic) NSUInteger selectedIndex;

@property (nonatomic, readonly, strong) NSMutableArray<__kindof id<LPDViewModelProtocol>> *viewModels;

@end

NS_ASSUME_NONNULL_END
