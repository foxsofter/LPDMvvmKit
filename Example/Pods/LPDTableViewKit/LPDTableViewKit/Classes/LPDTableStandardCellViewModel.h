//
//  LPDTableStandardCellViewModel.h
//  LPDTeam
//
//  Created by 李博 on 16/4/6.
//  Copyright © 2016年 me.ele. All rights reserved.
//
#import "LPDTableCellViewModel.h"

@interface LPDTableStandardCellViewModel : LPDTableCellViewModel

@property (nonatomic, strong) UIImage *icon;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;

@property (nonatomic, assign) BOOL contentShow;

@end
