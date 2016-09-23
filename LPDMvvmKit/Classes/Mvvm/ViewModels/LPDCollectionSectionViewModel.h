//
//  LPDCollectionSectionViewModel.h
//  LPDMvvmKit
//
//  Created by foxsofter on 16/2/22.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "LPDCollectionSectionViewModelProtocol.h"
#import <Foundation/Foundation.h>

@interface LPDCollectionSectionViewModel : NSObject <LPDCollectionSectionViewModelProtocol>

+ (instancetype)section;

@end

@interface LPDCollectionSectionWithHeadTitleViewModel : LPDCollectionSectionViewModel

@end

@interface LPDCollectionSectionWithFootTitleViewModel : LPDCollectionSectionViewModel

@end

@interface LPDCollectionSectionWithHeadFootTitleViewModel : LPDCollectionSectionViewModel

@end

@interface LPDCollectionSectionWithHeadViewViewModel : LPDCollectionSectionViewModel

@end

@interface LPDCollectionSectionWithFootViewViewModel : LPDCollectionSectionViewModel

@end

@interface LPDCollectionSectionWithHeadFootViewViewModel : LPDCollectionSectionViewModel

@end