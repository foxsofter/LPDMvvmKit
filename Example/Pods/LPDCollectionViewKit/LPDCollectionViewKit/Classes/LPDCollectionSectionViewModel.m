//
//  LPDCollectionSectionViewModel.m
//  LPDMvvmKit
//
//  Created by foxsofter on 16/2/22.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "LPDCollectionSectionViewModel+Private.h"
#import "LPDCollectionSectionViewModel.h"

@implementation LPDCollectionSectionViewModel

+ (instancetype)section {
  return [[self alloc] init];
}

- (NSMutableArray<__kindof id<LPDCollectionItemViewModelProtocol>> *)mutableItems {

  return _mutableItems ?: (_mutableItems = [NSMutableArray array]);
}

- (NSArray<__kindof id<LPDCollectionItemViewModelProtocol>> *)items {
  return [_mutableItems copy];
}

- (void)setItems:(NSArray<__kindof id<LPDCollectionItemViewModelProtocol>> *)items {
  if (items) {
    if ([items isKindOfClass:[NSMutableArray class]]) {
      _mutableItems = (NSMutableArray *)items;
    } else {
      _mutableItems = [items mutableCopy];
    }
  } else {
    _mutableItems = [NSMutableArray array];
  }
}

@end

@implementation LPDCollectionSectionWithHeadTitleViewModel

@synthesize headerTitle = _headerTitle;

@end

@implementation LPDCollectionSectionWithFootTitleViewModel

@synthesize footerTitle = _footerTitle;

@end

@implementation LPDCollectionSectionWithHeadFootTitleViewModel

@synthesize headerTitle = _headerTitle;
@synthesize footerTitle = _footerTitle;

@end

@implementation LPDCollectionSectionWithHeadViewViewModel

@synthesize headerViewModel = _headerViewModel;

@end

@implementation LPDCollectionSectionWithFootViewViewModel

@synthesize footerViewModel = _footerViewModel;

@end

@implementation LPDCollectionSectionWithHeadFootViewViewModel

@synthesize headerViewModel = _headerViewModel;
@synthesize footerViewModel = _footerViewModel;

@end
