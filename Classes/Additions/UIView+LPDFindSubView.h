//
//  UIView+LPDFindSubView.h
//  LPDMvvmKit
//
//  Created by foxsofter on 16/3/19.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LPDFindSubView)

/**
 *  @brief find all subviews
 *
 *  @param cls class of subview
 */
- (NSArray *)subviewsWithClass:(Class)cls;

@end
