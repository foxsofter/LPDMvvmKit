//
//  LPDCollectionPhotoCellViewModel.m
//  LPDMvvmKit
//
//  Created by foxsofter on 16/9/22.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "LPDCollectionPhotoCellViewModel.h"

@implementation LPDCollectionPhotoCellViewModel

@synthesize model = _model;

- (void)setModel:(LPDPhotoModel *)model {
  if (_model == model) {
    return;
  }
  _model = model;
}

@end
