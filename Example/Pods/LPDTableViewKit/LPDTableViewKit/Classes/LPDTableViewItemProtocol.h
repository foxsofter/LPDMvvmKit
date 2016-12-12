//
//  LPDTableViewItemProtocol.h
//  LPDTableViewKit
//
//  Created by foxsofter on 16/1/3.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LPDTableItemViewModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LPDTableViewItemProtocol <NSObject>
@required

@property (nullable, nonatomic, weak, readonly) __kindof id<LPDTableItemViewModelProtocol> viewModel;

- (void)bindingTo:(__kindof id<LPDTableItemViewModelProtocol>)viewModel;

@end

NS_ASSUME_NONNULL_END
