//
//  LPDCollectionViewProtocol.h
//  LPDMvvmKit
//
//  Created by foxsofter on 16/2/22.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "LPDCollectionViewModelProtocol.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LPDCollectionViewProtocol <NSObject>
@required

@property (nullable, nonatomic, weak, readonly) __kindof id<LPDCollectionViewModelProtocol> viewModel;

- (void)bindingTo:(__kindof id<LPDCollectionViewModelProtocol>)viewModel;

@end

NS_ASSUME_NONNULL_END
