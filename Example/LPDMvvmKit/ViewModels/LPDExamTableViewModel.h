//
//  LPDExamTableViewModel.h
//  LPDMvvmKit
//
//  Created by foxsofter on 15/12/16.
//  Copyright © 2015年 eleme. All rights reserved.
//

#import "LPDScrollViewModel.h"
#import "LPDTableViewModel.h"

@interface LPDExamTableViewModel : LPDScrollViewModel

@property (nonatomic, copy) NSString *tabBarItemTitle;
@property (nonatomic, copy) NSString *tabBarItemImage;
@property (nonatomic, copy) NSString *tabBarItemSelectedImage;

@property (nonatomic, strong) LPDTableViewModel *tableViewModel;

@property (nonatomic, strong, readonly) RACCommand *insertCellCommand;
@property (nonatomic, strong, readonly) RACCommand *insertCellsCommand;
@property (nonatomic, strong, readonly) RACCommand *removeCellCommand;
@property (nonatomic, strong, readonly) RACCommand *removeCellsCommand;

@end
