//
//  LPDTablePostCellViewModel.m
//  LPDMvvmKit
//
//  Created by foxsofter on 16/9/21.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "LPDTablePostCellViewModel.h"

@implementation LPDTablePostCellViewModel

@synthesize height = _height;
@synthesize model = _model;

- (void)setModel:(LPDPostModel *)model {
  if (_model == model) {
    return;
  }
  _model = model;
}

@end
