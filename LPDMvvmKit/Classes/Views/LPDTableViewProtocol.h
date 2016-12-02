//
//  LPDTableViewProtocol.h
//  LPDMvvmKit
//
//  Created by foxsofter on 16/1/5.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "LPDTableViewModelProtocol.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LPDTableViewProtocol <NSObject>
@required

@property (nullable, nonatomic, weak, readonly) __kindof id<LPDTableViewModelProtocol> viewModel;

- (void)bindingTo:(__kindof id<LPDTableViewModelProtocol>)viewModel;

@end

NS_ASSUME_NONNULL_END
