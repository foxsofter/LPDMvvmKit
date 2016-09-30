//
//  LPDViewModel.h
//  LPDMvvm
//
//  Created by foxsofter on 15/10/10.
//  Copyright © 2015年 foxsofter. All rights reserved.
//

#import "LPDViewModelProtocol.h"
#import <ReactiveViewModel/ReactiveViewModel.h>

@interface LPDViewModel : RVMViewModel <LPDViewModelProtocol>

/**
 *  @brief 禁用无关构造函数
 */
+ (instancetype) new NS_UNAVAILABLE;

@end
