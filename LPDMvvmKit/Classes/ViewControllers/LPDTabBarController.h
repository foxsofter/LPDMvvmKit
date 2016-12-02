//
//  LPDTabBarController.h
//  LPDMvvm
//
//  Created by foxsofter on 15/10/11.
//  Copyright © 2015年 foxsofter. All rights reserved.
//

#import "LPDTabBarControllerProtocol.h"
#import <UIKit/UIKit.h>

@interface LPDTabBarController : UITabBarController <LPDTabBarControllerProtocol>

/**
 *  @brief 禁用无关构造函数
 */
+ (instancetype) new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil NS_UNAVAILABLE;

@end
