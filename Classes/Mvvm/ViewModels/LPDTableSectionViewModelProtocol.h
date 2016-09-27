//
//  LPDTableSectionViewModelProtocol.h
//  LPDMvvmKit
//
//  Created by foxsofter on 16/1/8.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LPDTableCellViewModelProtocol.h"
#import "LPDTableHeaderFooterViewModelProtocol.h"

@protocol LPDTableSectionViewModelProtocol <NSObject>
@required

@property (nonatomic, copy) NSArray<__kindof id<LPDTableCellViewModelProtocol>> *rows;

@optional

@property (nonatomic, copy) NSString *headerTitle;
@property (nonatomic, copy) NSString *footerTitle;

@property (nonatomic, strong) id<LPDTableHeaderFooterViewModelProtocol> headerViewModel;
@property (nonatomic, strong) id<LPDTableHeaderFooterViewModelProtocol> footerViewModel;

@end
