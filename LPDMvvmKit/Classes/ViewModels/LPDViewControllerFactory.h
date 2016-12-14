//
//  LPDViewControllerFactory.h
//  LPDMvvm
//
//  Created by foxsofter on 15/10/13.
//  Copyright © 2015年 foxsofter. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  @author foxsofter, 15-10-13 16:10:36
 *
 *  @brief  ViewController 与 ViewModel映射的类
 */
@interface LPDViewControllerFactory : NSObject

/**
 *  @brief  将ViewController和ViewModel匹配
 *
 *  @param viewControllerClass viewControllerClass
 *  @param viewModelClass      viewModelClass
 */
+ (void)setViewController:(NSString *)viewControllerClass forViewModel:(NSString *)viewModelClass;

/**
 *  @brief  获取ViewController，如果未通过setViewController::
 *          设置映射关系，默认映射关系为XXXModel => XXXController
 *
 *  @param viewModel viewModel
 *
 *  @return ViewController
 */
+ (id)viewControllerForViewModel:(id)viewModel;

@end
