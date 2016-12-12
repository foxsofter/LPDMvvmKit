//
//  LPDTableViewFooter.m
//  LPDTableViewKit
//
//  Created by foxsofter on 16/1/8.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "LPDTableViewFooter.h"

@interface LPDTableViewFooter ()

@property (nullable, nonatomic, weak, readwrite) __kindof id<LPDTableItemViewModelProtocol> viewModel;

@end

@implementation LPDTableViewFooter

- (void)bindingTo:(__kindof id<LPDTableItemViewModelProtocol>)viewModel {
  NSParameterAssert(viewModel);
  self.viewModel = viewModel;
}

@end
