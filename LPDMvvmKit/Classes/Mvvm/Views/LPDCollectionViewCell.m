//
//  LPDCollectionViewCell.m
//  LPDMvvmKit
//
//  Created by foxsofter on 16/2/22.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "LPDCollectionCellViewModel.h"
#import "LPDCollectionCellViewModelProtocol.h"
#import "LPDCollectionViewCell.h"
#import "ReactiveCocoa.h"

@interface LPDCollectionViewCell ()

@property (nullable, nonatomic, weak, readwrite) __kindof id<LPDCollectionCellViewModelProtocol> viewModel;

@end

@implementation LPDCollectionViewCell

- (void)bindingTo:(__kindof id<LPDCollectionCellViewModelProtocol>)viewModel {
  NSParameterAssert(viewModel);

  self.viewModel = viewModel;
//#if DEBUG
//  self.backgroundColor = [UIColor redColor];
//#endif
}

@end
