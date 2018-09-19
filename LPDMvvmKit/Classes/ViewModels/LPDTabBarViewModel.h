//
//  LPDTabBarViewModel.h
//  LPDMvvm
//
//  Created by foxsofter on 15/10/13.
//  Copyright © 2015年 foxsofter. All rights reserved.
//

#import "LPDTabBarViewModelProtocol.h"
#import <Foundation/Foundation.h>

@interface LPDTabBarViewModel : NSObject <LPDTabBarViewModelProtocol>

/**
 *  @brief 禁用无关构造函数
 */
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end
