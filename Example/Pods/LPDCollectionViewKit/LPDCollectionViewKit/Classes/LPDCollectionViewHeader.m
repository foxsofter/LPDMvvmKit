//
//  LPDCollectionHeader.m
//  LPDMvvmKit
//
//  Created by foxsofter on 16/2/22.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "LPDCollectionHeaderViewModel.h"
#import "LPDCollectionViewHeader.h"

@interface LPDCollectionViewHeader ()

@property (nullable, nonatomic, weak, readwrite) __kindof id<LPDCollectionItemViewModelProtocol> viewModel;

@end

@implementation LPDCollectionViewHeader

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1.0];
    _textLabel = [[UILabel alloc] init];
    _textLabel.numberOfLines = 0;
    _textLabel.frame = CGRectMake(15, 2, 200, 18);
    _textLabel.font = [UIFont systemFontOfSize:14];
    _textLabel.textAlignment = NSTextAlignmentLeft;
    _textLabel.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0];
    _textLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:_textLabel];
  }
  return self;
}

- (void)bindingTo:(__kindof id<LPDCollectionItemViewModelProtocol>)viewModel {
  NSParameterAssert(viewModel);

  self.viewModel = viewModel;
  LPDCollectionHeaderViewModel *headerViewModel = viewModel;
  RAC(self.textLabel, text) = [RACObserve(headerViewModel, text) takeUntil:[self rac_prepareForReuseSignal]];
}

@end
