//
//  LPDTableViewHeaderFooterProtocol.h
//  LPDMvvmKit
//
//  Created by foxsofter on 16/1/3.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LPDTableHeaderFooterViewModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LPDTableViewHeaderFooterProtocol <NSObject>
@required

@property (nullable, nonatomic, weak, readonly) __kindof id<LPDTableHeaderFooterViewModelProtocol> viewModel;

- (void)bindingTo:(__kindof id<LPDTableHeaderFooterViewModelProtocol>)viewModel;

@end

NS_ASSUME_NONNULL_END