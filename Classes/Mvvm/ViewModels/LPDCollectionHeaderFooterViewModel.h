//
//  LPDCollectionHeaderFooterViewModel.h
//  LPDMvvmKit
//
//  Created by foxsofter on 16/2/22.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "LPDCollectionHeaderFooterViewModelProtocol.h"
#import <Foundation/Foundation.h>

@interface LPDCollectionHeaderFooterViewModel : NSObject <LPDCollectionHeaderFooterViewModelProtocol>

+ (instancetype) new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@property (nonatomic, copy) NSString *text;

@end

@interface LPDCollectionHeaderViewModel : LPDCollectionHeaderFooterViewModel

@end

@interface LPDCollectionFooterViewModel : LPDCollectionHeaderFooterViewModel

@end