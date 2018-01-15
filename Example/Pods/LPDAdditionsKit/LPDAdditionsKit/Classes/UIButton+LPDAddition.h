//
//  UIButton+LPDAddition.h
//  LPDMvvmKit
//
//  Created by foxsofter on 16/4/6.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (LPDAddition)

- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state;

+ (UIButton *)buttonWithBackgoundImageName:(NSString *)backgroundImageName;

+ (UIButton *)buttonWithImageName:(NSString *)imageName;

@end

NS_ASSUME_NONNULL_END
