//
//  LPDCollectionItemViewModel+React.h
//  LPDMvvmKit
//
//  Created by foxsofter on 16/2/22.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import <LPDCollectionViewKit/LPDCollectionViewKit.h>
#import "LPDViewModelBecomeActiveProtocol.h"
#import "LPDViewModelDidLoadViewProtocol.h"
#import "LPDViewModelDidLayoutSubviewsProtocol.h"
#import "LPDViewModelSubmittingProtocol.h"
#import "LPDViewModelLoadingProtocol.h"
#import "LPDViewModelLoadingMoreProtocol.h"
#import "LPDViewModelToastProtocol.h"
#import "LPDViewModelEmptyProtocol.h"
#import "LPDViewModelNetworkStatusProtocol.h"

@interface LPDCollectionItemViewModel (React)<LPDViewModelBecomeActiveProtocol,
                                              LPDViewModelDidLoadViewProtocol,
                                              LPDViewModelDidLayoutSubviewsProtocol,
                                              LPDViewModelSubmittingProtocol,
                                              LPDViewModelLoadingProtocol,
                                              LPDViewModelLoadingMoreProtocol,
                                              LPDViewModelToastProtocol,
                                              LPDViewModelEmptyProtocol,
                                              LPDViewModelNetworkStatusProtocol>

@end
