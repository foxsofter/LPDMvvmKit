//
//  LPDTableViewModel.h
//  LPDMvvmKit
//
//  Created by foxsofter on 16/1/3.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "LPDTableViewModelProtocol.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LPDTableViewModelProtocol;

@interface LPDTableViewModel : NSObject <LPDTableViewModelProtocol>

+ (instancetype) new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@property (nonatomic, strong) NSMutableArray<__kindof id<LPDTableSectionViewModelProtocol>> *sections;

@end

NS_ASSUME_NONNULL_END
