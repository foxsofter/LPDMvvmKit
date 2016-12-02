//
//  LPDMyTestTableViewModel.h
//  LPDMvvmKit
//
//  Created by 彭柯柱 on 16/1/26.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import <LPDMvvmKit/LPDMvvmKit.h>

@interface LPDMyTestTableViewModel : LPDScrollViewModel

@property (nonatomic, copy) NSString *tabBarItemTitle;
@property (nonatomic, copy) NSString *tabBarItemImage;
@property (nonatomic, copy) NSString *tabBarItemSelectedImage;

@property (nonatomic, strong) LPDTableViewModel *tableViewModel;

@end
