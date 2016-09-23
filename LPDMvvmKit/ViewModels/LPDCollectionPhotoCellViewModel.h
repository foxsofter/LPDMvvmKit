//
//  LPDCollectionPhotoCellViewModel.h
//  LPDMvvmKit
//
//  Created by foxsofter on 16/9/22.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "LPDCollectionCellViewModel.h"
#import "LPDPhotoModel.h"

@interface LPDCollectionPhotoCellViewModel : LPDCollectionCellViewModel

@property (nonatomic, strong) LPDPhotoModel *model;

@end
