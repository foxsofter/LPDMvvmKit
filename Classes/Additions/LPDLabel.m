//
//  LPDLabel.m
//  LPDMvvmKit
//
//  Created by foxsofter on 16/3/18.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "LPDLabel.h"

@implementation LPDLabel

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
  UIEdgeInsets insets = self.insets;
  CGRect rect = [super textRectForBounds:UIEdgeInsetsInsetRect(bounds, insets) limitedToNumberOfLines:numberOfLines];

  rect.origin.x -= insets.left;
  rect.origin.y -= insets.top;
  rect.size.width += (insets.left + insets.right);
  rect.size.height += (insets.top + insets.bottom);

  return rect;
}

- (void)drawTextInRect:(CGRect)rect {
  [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.insets)];
}

@end
