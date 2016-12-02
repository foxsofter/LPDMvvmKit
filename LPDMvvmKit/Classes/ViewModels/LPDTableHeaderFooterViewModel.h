//
//  LPDTableHeaderFooterViewModel.h
//  LPDMvvmKit
//
//  Created by foxsofter on 16/1/8.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "LPDTableHeaderFooterViewModelProtocol.h"
#import <Foundation/Foundation.h>

@interface LPDTableHeaderFooterViewModel : NSObject <LPDTableHeaderFooterViewModelProtocol>

+ (instancetype) new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end

@interface LPDTableHeaderViewModel : LPDTableHeaderFooterViewModel

@end

@interface LPDTableFooterViewModel : LPDTableHeaderFooterViewModel

@end
