//
//  LPDCollectionViewImageCell.m
//  LPDMvvmKit
//
//  Created by foxsofter on 16/3/14.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "LPDCollectionImageCellViewModel.h"
#import "LPDCollectionViewImageCell.h"
#import "Masonry.h"
#import "ReactiveCocoa.h"

@implementation LPDCollectionViewImageCell

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self initialize];
  }
  return self;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  
  [self initialize];
}

- (void)initialize {
  self.backgroundColor = [UIColor clearColor];
  _imageView = [[UIImageView alloc] init];
  [self.contentView addSubview:_imageView];
  [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.mas_equalTo(UIEdgeInsetsZero);
  }];
}

- (void)bindingTo:(__kindof id<LPDCollectionCellViewModelProtocol>)viewModel {
  [super bindingTo:viewModel];

  LPDCollectionImageCellViewModel *cellViewModel = viewModel;
  RAC(self.imageView, image) = RACObserve(cellViewModel, image);
}

@end
