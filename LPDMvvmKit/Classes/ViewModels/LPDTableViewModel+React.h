//
//  LPDTableViewModel+React.h
//  LPDMvvmKit
//
//  Created by foxsofter on 16/1/3.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import <LPDTableViewKit/LPDTableViewKit.h>
#import "LPDViewModelLoadingMoreProtocol.h"
#import "LPDViewModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPDTableViewModel (React)<LPDViewModelBecomeActiveProtocol,
                                     LPDViewModelDidLoadViewProtocol,
                                     LPDViewModelDidLayoutSubviewsProtocol,
                                     LPDViewModelSubmittingProtocol,
                                     LPDViewModelLoadingProtocol,
                                     LPDViewModelLoadingMoreProtocol,
                                     LPDViewModelToastProtocol,
                                     LPDViewModelEmptyProtocol,
                                     LPDViewModelNetworkStatusProtocol>

@property (nullable, nonatomic, weak) __kindof id<LPDViewModelProtocol> viewModel;

@end

NS_ASSUME_NONNULL_END
