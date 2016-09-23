//
//  LPDCollectionCellViewModelProtocol.h
//  LPDMvvmKit
//
//  Created by foxsofter on 16/2/22.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LPDViewModelReactProtocol.h"
#import "LPDModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LPDCollectionViewModelProtocol;

@protocol LPDCollectionCellViewModelProtocol <LPDViewModelReactProtocol>
@required

- (instancetype)initWithViewModel:(__kindof id<LPDCollectionViewModelProtocol>)viewModel;

@property (nullable, nonatomic, weak, readonly) __kindof id<LPDCollectionViewModelProtocol> viewModel;

@property (nonatomic, copy, readonly) NSString *reuseIdentifier;

@property (nonatomic, assign, readonly) Class cellClass;

@optional

@property (nonatomic, strong) id<LPDModelProtocol> model;

@end

NS_ASSUME_NONNULL_END
