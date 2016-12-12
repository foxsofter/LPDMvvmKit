//
//  LPDCollectionSectionViewModelProtocol.h
//  LPDMvvmKit
//
//  Created by foxsofter on 16/2/22.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LPDCollectionItemViewModelProtocol.h"

@protocol LPDCollectionSectionViewModelProtocol <NSObject>
@required

@property (nonatomic, copy) NSArray<__kindof id<LPDCollectionItemViewModelProtocol>> *items;

@optional

@property (nonatomic, copy) NSString *headerTitle;
@property (nonatomic, copy) NSString *footerTitle;

@property (nonatomic, strong) id<LPDCollectionItemViewModelProtocol> headerViewModel;
@property (nonatomic, strong) id<LPDCollectionItemViewModelProtocol> footerViewModel;

@end
