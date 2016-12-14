//
//  LPDCollectionViewModel+React.h
//  LPDMvvmKit
//
//  Created by foxsofter on 16/2/22.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import <LPDCollectionViewKit/LPDCollectionViewKit.h>
#import "LPDViewModelReactProtocol.h"
#import "LPDViewModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPDCollectionViewModel (React)<LPDViewModelReactProtocol>

@property (nullable, nonatomic, weak) __kindof id<LPDViewModelProtocol> viewModel;

@end

NS_ASSUME_NONNULL_END
