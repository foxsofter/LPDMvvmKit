//
//  LPDCollectionViewCell.m
//  LPDMvvmKit
//
//  Created by foxsofter on 16/2/22.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "LPDCollectionViewCell.h"
#import "LPDCollectionCellViewModel.h"

@interface LPDCollectionViewCell ()

@property (nullable, nonatomic, weak, readwrite) __kindof id<LPDCollectionItemViewModelProtocol> viewModel;

@end

@implementation LPDCollectionViewCell

- (void)bindingTo:(__kindof id<LPDCollectionItemViewModelProtocol>)viewModel {
  NSParameterAssert(viewModel);

  self.viewModel = viewModel;
}

@end
