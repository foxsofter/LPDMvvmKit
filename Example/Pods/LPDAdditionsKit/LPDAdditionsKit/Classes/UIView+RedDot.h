//
//  UIView+RedDot.h
//  LPDCrowdsource
//
//  Created by 沈强 on 16/9/1.
//  Copyright © 2016年 elm. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (RedDot)

- (void)addRedDotWithRadius:(CGFloat)radius offsetX:(CGFloat)offsetX offsetY:(CGFloat)offsetY;

- (void)showRedDotWithRadius:(CGFloat)radius offsetX:(CGFloat)offsetX offsetY:(CGFloat)offsetY;

- (void)showRedDot;

- (void)hiddenRedDot;

@end

NS_ASSUME_NONNULL_END
