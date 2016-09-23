//
//  LPDCustomCellModel.m
//  LPDMvvmKit
//
//  Created by 彭柯柱 on 16/2/1.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "LPDCustomCellModel.h"

@implementation LPDCustomCellModel

- (Class)cellClass
{
  return NSClassFromString(@"LPDCustomCell");
}

@end
