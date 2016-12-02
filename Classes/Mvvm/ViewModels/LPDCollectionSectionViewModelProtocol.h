//
//  LPDCollectionSectionViewModelProtocol.h
//  LPDMvvmKit
//
//  Created by foxsofter on 16/2/22.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LPDCollectionCellViewModelProtocol.h"
#import "LPDCollectionHeaderFooterViewModelProtocol.h"

@protocol LPDCollectionSectionViewModelProtocol <NSObject>
@required

@property (nonatomic, copy) NSArray<__kindof id<LPDCollectionCellViewModelProtocol>> *items;

@optional

@property (nonatomic, copy) NSString *headerTitle;
@property (nonatomic, copy) NSString *footerTitle;

@property (nonatomic, strong) id<LPDCollectionHeaderFooterViewModelProtocol> headerViewModel;
@property (nonatomic, strong) id<LPDCollectionHeaderFooterViewModelProtocol> footerViewModel;

@end
