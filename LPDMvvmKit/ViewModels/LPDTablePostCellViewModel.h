//
//  LPDTablePostCellViewModel.h
//  LPDMvvmKit
//
//  Created by foxsofter on 16/9/21.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "LPDTableCellViewModel.h"
#import "LPDPostModel.h"

@interface LPDTablePostCellViewModel : LPDTableCellViewModel

@property (nonatomic, strong) LPDPostModel *model;

@end
