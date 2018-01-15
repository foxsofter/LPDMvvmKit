//
//  UIView+CornerRadii.h
//  LPDCrowdsource
//
//  Created by eMr.Wang on 16/1/29.
//  Copyright © 2016年 elm. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (CornerRadii)

// 指定倒角
- (void)setCornerRadii:(CGFloat)cornerRadii roundingCorners:(UIRectCorner)roundingCorners;

@end

NS_ASSUME_NONNULL_END
