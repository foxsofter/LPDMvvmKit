//
//  LPDNavigationViewModel.h
//  LPDMvvm
//
//  Created by foxsofter on 15/10/13.
//  Copyright © 2015年 foxsofter. All rights reserved.
//

#import "LPDNavigationViewModelProtocol.h"
#import "LPDViewModelProtocol.h"
#import <UIKit/UIKit.h>

@interface LPDNavigationViewModel : NSObject <LPDNavigationViewModelProtocol>

/**
 *  @brief 禁用无关构造函数
 */
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end
