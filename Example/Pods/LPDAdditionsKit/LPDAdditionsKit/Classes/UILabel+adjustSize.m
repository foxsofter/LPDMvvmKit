//
//  UILabel+adjustSize.m
//  LPDCrowdsource
//
//  Created by 沈强 on 16/3/30.
//  Copyright © 2016年 elm. All rights reserved.
//

#import "UILabel+adjustSize.h"

@implementation UILabel (adjustSize)

- (void)adjustSizeAlignment:(LPDAdjustAlignment)adjustAlignment {
  
  [self  adjustSizeAlignment:adjustAlignment
                     margins:5.0];
  
}

- (void)adjustSizeAlignment:(LPDAdjustAlignment)adjustAlignment
                    margins:(CGFloat)margins {
  CGRect rect ;
  switch (adjustAlignment) {
    case LPDAdjustAlignmentLeft:
    case LPDAdjustAlignmentRight: {
      rect = [self.text boundingRectWithSize:CGSizeMake(MAXFLOAT, CGRectGetHeight(self.frame)) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:[self attributes] context:nil];
      break;
    }
    case LPDAdjustAlignmentBottom:
    case LPDAdjustAlignmentTop: {
      rect = [self.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.frame),MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:[self attributes] context:nil];
      break;
    }
    case LPDAdjustAlignmentCenter: {
      rect = [self.text boundingRectWithSize:CGSizeMake(MAXFLOAT,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:[self attributes] context:nil];
      break;
    }
  }
  
  switch (adjustAlignment) {
    case LPDAdjustAlignmentLeft: {
      self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), CGRectGetWidth(rect)+margins, CGRectGetHeight(self.frame)+margins);
      break;
    }
    case LPDAdjustAlignmentRight: {
      self.frame = CGRectMake(CGRectGetMaxX(self.frame)-CGRectGetWidth(rect)-margins, CGRectGetMinY(self.frame), CGRectGetWidth(rect)+margins, CGRectGetHeight(self.frame)+margins);
      break;
    }
    case LPDAdjustAlignmentBottom: {
      self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMaxY(self.frame)-CGRectGetHeight(rect)-margins, CGRectGetWidth(self.frame)+margins, CGRectGetHeight(rect)+margins);
      break;
    }
    case LPDAdjustAlignmentTop: {
      self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), CGRectGetWidth(self.frame)+margins, CGRectGetHeight(rect)+margins);
      break;
    }
    case LPDAdjustAlignmentCenter: {
      CGPoint center = self.center;
      self.frame = CGRectMake(0, 0, CGRectGetWidth(rect)+margins, CGRectGetHeight(rect)+margins);
      self.center = center;
      break;
    }
  }
}

- (NSDictionary *)attributes {

  return @{NSFontAttributeName:self.font};

}

@end
