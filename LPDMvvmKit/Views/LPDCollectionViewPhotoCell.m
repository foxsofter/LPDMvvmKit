//
//  LPDCollectionViewPhotoCell.m
//  LPDMvvmKit
//
//  Created by foxsofter on 16/9/22.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "LPDCollectionViewPhotoCell.h"
#import "LPDAdditions.h"
#import "LPDPhotoModel.h"

@implementation LPDCollectionViewPhotoCell

#pragma mark - life cycle

-(instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.imageView];
  }
  return self;
}

-(void)layoutSubviews {
  [super layoutSubviews];
  
  self.backgroundColor = [UIColor blackColor];
  self.imageView.frame = CGRectMake(4, 4, self.width - 8, self.height - 8);
}

-(void)bindingTo:(__kindof id<LPDCollectionCellViewModelProtocol>)viewModel {
  [super bindingTo:viewModel];
  
  [self.imageView setImageUrl:((LPDPhotoModel*)viewModel.model).thumbnailUrl];
}

@end
