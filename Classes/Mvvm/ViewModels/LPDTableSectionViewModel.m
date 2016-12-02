//
//  LPDTableSectionViewModel.m
//  LPDMvvmKit
//
//  Created by foxsofter on 16/1/8.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "LPDTableSectionViewModel+Private.h"
#import "LPDTableSectionViewModel.h"

@implementation LPDTableSectionViewModel

+ (instancetype)section {
  return [[self alloc] init];
}

- (NSMutableArray<__kindof id<LPDTableCellViewModelProtocol>> *)mutableRows {
  return _mutableRows ?: (_mutableRows = [NSMutableArray array]);
}

- (NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)rows {
  return [_mutableRows copy];
}

- (void)setRows:(NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)rows {
  if (rows) {
    if ([rows isKindOfClass:[NSMutableArray class]]) {
      _mutableRows = (NSMutableArray *)rows;
    } else {
      _mutableRows = [rows mutableCopy];
    }
  } else {
    _mutableRows = [NSMutableArray array];
  }
}

@end

@implementation LPDTableSectionWithHeadTitleViewModel

@synthesize headerTitle = _headerTitle;

@end

@implementation LPDTableSectionWithFootTitleViewModel

@synthesize footerTitle = _footerTitle;

@end

@implementation LPDTableSectionWithHeadFootTitleViewModel

@synthesize headerTitle = _headerTitle;
@synthesize footerTitle = _footerTitle;

@end

@implementation LPDTableSectionWithHeadViewViewModel

@synthesize headerViewModel = _headerViewModel;

@end

@implementation LPDTableSectionWithFootViewViewModel

@synthesize footerViewModel = _footerViewModel;

@end

@implementation LPDTableSectionWithHeadFootViewViewModel

@synthesize headerViewModel = _headerViewModel;
@synthesize footerViewModel = _footerViewModel;

@end
