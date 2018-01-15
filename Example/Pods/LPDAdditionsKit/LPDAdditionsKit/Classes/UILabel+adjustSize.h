//
//  UILabel+adjustSize.h
//  LPDCrowdsource
//
//  Created by 沈强 on 16/3/30.
//  Copyright © 2016年 elm. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,LPDAdjustAlignment) {
  LPDAdjustAlignmentLeft,
  LPDAdjustAlignmentRight,
  LPDAdjustAlignmentBottom,
  LPDAdjustAlignmentTop,
  LPDAdjustAlignmentCenter,
};

@interface UILabel (adjustSize)

/**
 *  adjust label size and orgin point
 *  LPDAdjustAlignmentLeft LPDAdjustAlignmentRight H adjust
 *  LPDAdjustAlignmentBottom LPDAdjustAlignmentTop V adjust
 *
 */

- (void)adjustSizeAlignment:(LPDAdjustAlignment)adjustAlignment;

- (void)adjustSizeAlignment:(LPDAdjustAlignment)adjustAlignment
                    margins:(CGFloat)margins;

@end

NS_ASSUME_NONNULL_END
