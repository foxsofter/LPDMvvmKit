//
//  LPDTableItemViewModel.m
//  LPDTableViewKit
//
//  Created by foxsofter on 16/1/8.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "LPDTableItemViewModel.h"
#import "LPDTableViewModelProtocol.h"

@implementation LPDTableItemViewModel {
  __weak __kindof id<LPDTableViewModelProtocol> _viewModel;
  NSString *_reuseIdentifier;
  NSString *_reuseViewClass;
}

#pragma mark - LPDTableItemViewModelProtocol

- (instancetype)initWithViewModel:(__kindof id<LPDTableViewModelProtocol>)viewModel {
  self = [super init];
  if (self) {
    _viewModel = viewModel;
  }
  return self;
}

- (NSString *)reuseIdentifier {
  return _reuseIdentifier ?: (_reuseIdentifier =
                              [NSString stringWithFormat:@"reusable-%@-%@",
                               [self reuseViewClass],
                               NSStringFromClass(self.class)]);
}

- (NSString *)reuseViewClass {
  return _reuseViewClass ?: (_reuseViewClass =
                             [[NSStringFromClass(self.class)
                             stringByReplacingOccurrencesOfString:@"LPDTable" withString:@"LPDTableView"]
                             stringByReplacingOccurrencesOfString:@"ViewModel" withString:@""]);
}

@end
