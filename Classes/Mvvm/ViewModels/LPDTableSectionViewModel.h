//
//  LPDTableSectionViewModel.h
//  LPDMvvmKit
//
//  Created by foxsofter on 16/1/8.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "LPDTableSectionViewModelProtocol.h"
#import <Foundation/Foundation.h>

@interface LPDTableSectionViewModel : NSObject <LPDTableSectionViewModelProtocol>

+ (instancetype)section;

@end

@interface LPDTableSectionWithHeadTitleViewModel : LPDTableSectionViewModel

@end

@interface LPDTableSectionWithFootTitleViewModel : LPDTableSectionViewModel

@end

@interface LPDTableSectionWithHeadFootTitleViewModel : LPDTableSectionViewModel

@end

@interface LPDTableSectionWithHeadViewViewModel : LPDTableSectionViewModel

@end

@interface LPDTableSectionWithFootViewViewModel : LPDTableSectionViewModel

@end

@interface LPDTableSectionWithHeadFootViewViewModel : LPDTableSectionViewModel

@end