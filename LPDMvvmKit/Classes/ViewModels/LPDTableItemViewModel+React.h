//
//  LPDTableItemViewModel+React.h
//  LPDMvvmKit
//
//  Created by foxsofter on 16/1/4.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import <LPDTableViewKit/LPDTableViewKit.h>
#import "LPDViewModelBecomeActiveProtocol.h"
#import "LPDViewModelDidLoadViewProtocol.h"
#import "LPDViewModelDidLayoutSubviewsProtocol.h"
#import "LPDViewModelLoadingProtocol.h"
#import "LPDViewModelLoadingMoreProtocol.h"
#import "LPDViewModelSubmittingProtocol.h"
#import "LPDViewModelToastProtocol.h"
#import "LPDViewModelEmptyProtocol.h"
#import "LPDViewModelNetworkStatusProtocol.h"

@interface LPDTableItemViewModel (React)<LPDViewModelBecomeActiveProtocol,
                                         LPDViewModelDidLoadViewProtocol,
                                         LPDViewModelDidLayoutSubviewsProtocol,
                                         LPDViewModelLoadingProtocol,
                                         LPDViewModelLoadingMoreProtocol,
                                         LPDViewModelSubmittingProtocol,
                                         LPDViewModelToastProtocol,
                                         LPDViewModelEmptyProtocol,
                                         LPDViewModelNetworkStatusProtocol>

@end
