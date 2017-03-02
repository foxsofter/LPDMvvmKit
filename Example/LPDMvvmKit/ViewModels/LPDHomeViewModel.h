//
//  LPDHomeViewModel.h
//  LPDMvvmKit
//
//  Created by foxsofter on 15/12/16.
//  Copyright © 2015年 eleme. All rights reserved.
//

#import "LPDViewModel.h"

@interface LPDHomeViewModel : LPDViewModel

@property (nonatomic, copy) NSString *tabBarItemTitle;
@property (nonatomic, copy) NSString *tabBarItemImage;
@property (nonatomic, copy) NSString *tabBarItemSelectedImage;

- (void)pushViewModel;
- (void)popViewModel;
- (void)popToRootViewModel;
- (void)presentViewModel;
- (void)dismissViewModel;

@end
