//
//  LPDTableViewCellProtocol.h
//  LPDMvvmKit
//
//  Created by foxsofter on 16/1/3.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LPDTableCellViewModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LPDTableViewCellProtocol <NSObject>
@required

@property (nullable, nonatomic, weak, readonly) __kindof id<LPDTableCellViewModelProtocol> viewModel;

- (void)bindingTo:(__kindof id<LPDTableCellViewModelProtocol>)viewModel;

@end

NS_ASSUME_NONNULL_END