//
//  LPDCollectionViewImageCell.m
//  LPDMvvmKit
//
//  Created by foxsofter on 16/3/14.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "LPDCollectionImageCellViewModel.h"
#import "LPDCollectionViewImageCell.h"

@implementation LPDCollectionViewImageCell

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self loadSubviews];
  }
  return self;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  
  [self loadSubviews];
}

- (void)loadSubviews {
  self.backgroundColor = [UIColor clearColor];
  _imageView = [[UIImageView alloc] init];
  [self.contentView addSubview:_imageView];
  _imageView.frame = self.contentView.bounds;
}

- (void)bindingTo:(__kindof id<LPDCollectionItemViewModelProtocol>)viewModel {
  [super bindingTo:viewModel];

  LPDCollectionImageCellViewModel *cellViewModel = viewModel;
  RAC(self.imageView, image) = RACObserve(cellViewModel, image);
}

@end
