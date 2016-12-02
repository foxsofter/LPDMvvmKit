//
//  LPDCollectionSectionViewModel+Private.h
//  LPDMvvmKit
//
//  Created by foxsofter on 16/2/22.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "LPDCollectionSectionViewModel.h"

@protocol LPDCollectionCellViewModelProtocol;

@interface LPDCollectionSectionViewModel ()

@property (nonatomic, strong) NSMutableArray<__kindof id<LPDCollectionCellViewModelProtocol>> *mutableItems;

@end
