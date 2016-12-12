//
//  LPDCollectionViewItemProtocol.h
//  LPDMvvmKit
//
//  Created by foxsofter on 16/2/22.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPDCollectionItemViewModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LPDCollectionViewItemProtocol <NSObject>

@required

@property (nullable, nonatomic, weak, readonly) __kindof id<LPDCollectionItemViewModelProtocol> viewModel;

- (void)bindingTo:(__kindof id<LPDCollectionItemViewModelProtocol>)viewModel;

@end

NS_ASSUME_NONNULL_END
