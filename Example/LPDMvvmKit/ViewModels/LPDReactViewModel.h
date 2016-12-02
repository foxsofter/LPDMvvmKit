//
//  LPDReactViewModel.h
//  LPDMvvmKit
//
//  Created by foxsofter on 16/1/22.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import <LPDMvvmKit/LPDMvvmKit.h>

@interface LPDReactViewModel : LPDViewModel

@property (nonatomic, copy) NSString *tabBarItemTitle;
@property (nonatomic, copy) NSString *tabBarItemImage;
@property (nonatomic, copy) NSString *tabBarItemSelectedImage;

@property (nonatomic, strong, readonly) RACCommand *insertCellCommand;
@property (nonatomic, strong, readonly) RACCommand *removeCellCommand;

@end
