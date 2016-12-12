//
//  LPDCollectionItemViewModelProtocol.h
//  LPDMvvmKit
//
//  Created by foxsofter on 16/2/22.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LPDCollectionViewModelProtocol;

@protocol LPDCollectionItemViewModelProtocol
@required

- (instancetype)initWithViewModel:(__kindof id<LPDCollectionViewModelProtocol>)viewModel;

@property (nullable, nonatomic, weak, readonly) __kindof id<LPDCollectionViewModelProtocol> viewModel;

@property (nonatomic, copy, readonly) NSString *reuseIdentifier;

@property (nonatomic, copy, readonly) NSString *reuseViewClass;

@end

NS_ASSUME_NONNULL_END
