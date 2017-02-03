//
//  LPDTableViewModel+React.h
//  LPDMvvmKit
//
//  Created by foxsofter on 16/1/3.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import <LPDTableViewKit/LPDTableViewKit.h>
#import "LPDScrollViewModelProtocol.h"
#import "LPDViewModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPDTableViewModel(React)<LPDScrollViewModelProtocol>

@property (nullable, nonatomic, weak) __kindof id<LPDViewModelProtocol> viewModel;

@end

NS_ASSUME_NONNULL_END
