//
//  LPDCollectionViewHeaderFooterProtocol.h
//  LPDMvvmKit
//
//  Created by foxsofter on 16/2/22.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "LPDCollectionHeaderFooterViewModelProtocol.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LPDCollectionViewHeaderFooterProtocol <NSObject>
@required

@property (nullable, nonatomic, weak, readonly) __kindof id<LPDCollectionHeaderFooterViewModelProtocol> viewModel;

- (void)bindingTo:(__kindof id<LPDCollectionHeaderFooterViewModelProtocol>)viewModel;

@end

NS_ASSUME_NONNULL_END