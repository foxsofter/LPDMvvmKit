//
//  UIButton+LPDAddition.m
//  LPDMvvmKit
//
//  Created by foxsofter on 16/4/6.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "UIButton+LPDAddition.h"
#import "UIImage+LPDAddition.h"

@implementation UIButton (LPDAddition)

- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state {
  UIImage *backgroundImage = [UIImage createImageWithColor:color];
  self.clipsToBounds = YES;
  [self setBackgroundImage:backgroundImage forState:state];
}

@end
