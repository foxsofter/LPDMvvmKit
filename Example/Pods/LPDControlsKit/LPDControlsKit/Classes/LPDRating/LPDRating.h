//
//  LPDRating.h
//  LPDMvvmKit
//
//  Reference
//  https://github.com/TinyQ/TQStarRatingView
//  Created by foxsofter on 15/9/28.
//  Copyright © 2015年 foxsofter. All rights reserved.
//

@import UIKit;

typedef NS_ENUM(NSUInteger, LPDRatingStarStyle) {
  LPDRatingStarStyleDefault,   // 只能出现整个星型被选中
  LPDRatingStarStyleHalf,      // 只能出现半个星型
  LPDRatingStarStylePrecision, // 可以出现精确值
};

@interface LPDRating : UIControl

@property (nonatomic) NSUInteger maxValue;
@property (nonatomic) CGFloat minValue;
@property (nonatomic) CGFloat value;
@property (nonatomic) CGFloat spacing;
@property (nonatomic) LPDRatingStarStyle starStyle;

@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, strong) UIColor *unselectedColor;
@property (nonatomic, strong) UIColor *borderColor;

@end
