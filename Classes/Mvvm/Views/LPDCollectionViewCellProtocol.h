//
//  LPDCollectionViewCellProtocol.h
//  LPDMvvmKit
//
//  Created by foxsofter on 16/2/22.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "LPDCollectionCellViewModelProtocol.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LPDCollectionViewCellProtocol <NSObject>

@required

@property (nullable, nonatomic, weak, readonly) __kindof id<LPDCollectionCellViewModelProtocol> viewModel;

- (void)bindingTo:(__kindof id<LPDCollectionCellViewModelProtocol>)viewModel;

@end

NS_ASSUME_NONNULL_END
