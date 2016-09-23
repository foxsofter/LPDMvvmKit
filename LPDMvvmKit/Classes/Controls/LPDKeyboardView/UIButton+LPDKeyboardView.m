//
//  UIButton+LPDKeyboardView.m
//  LPDKeyboardView
//
//  Created by fox softer on 15/11/24.
//  Copyright © 2015年 foxsofter. All rights reserved.
//

#import "LPDKeyButton.h"
#import "UIButton+LPDKeyboardView.h"

@implementation UIButton (LPDKeyboardView)

+ (instancetype)buttonWithCharStyle {
  UIButton *button = [LPDKeyButton buttonWithType:UIButtonTypeSystem];
  button.layer.backgroundColor = [UIColor whiteColor].CGColor;
  button.layer.cornerRadius = 3;
  button.layer.masksToBounds = NO;
  button.layer.shadowColor = [UIColor blackColor].CGColor;
  button.layer.shadowOffset = CGSizeMake(-.5, .5);
  button.layer.shadowRadius = 1;
  button.layer.shadowOpacity = 0.5;
  [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  button.titleLabel.font = [UIFont systemFontOfSize:20 weight:800];

  return button;
}

+ (instancetype)buttonWithSpaceStyle {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
  button.layer.backgroundColor = [UIColor whiteColor].CGColor;
  button.layer.cornerRadius = 3;
  button.layer.masksToBounds = NO;
  button.layer.shadowColor = [UIColor blackColor].CGColor;
  button.layer.shadowOffset = CGSizeMake(-.5, .5);
  button.layer.shadowRadius = 1;
  button.layer.shadowOpacity = 0.5;
  [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  button.titleLabel.font = [UIFont systemFontOfSize:20 weight:800];

  return button;
}

+ (instancetype)buttonWithCharControlStyle {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
  button.layer.backgroundColor = [UIColor colorWithRed:0.5569 green:0.5922 blue:0.6392 alpha:1.0].CGColor;
  button.layer.cornerRadius = 3;
  button.layer.masksToBounds = NO;
  button.layer.shadowColor = [UIColor blackColor].CGColor;
  button.layer.shadowOffset = CGSizeMake(-.5, .5);
  button.layer.shadowRadius = 1;
  button.layer.shadowOpacity = .8;
  [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  button.titleLabel.font = [UIFont systemFontOfSize:20 weight:800];
  return button;
}

+ (instancetype)buttonWithNumberStyle {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
  button.layer.backgroundColor = [UIColor whiteColor].CGColor;
  button.layer.borderColor = [UIColor colorWithRed:0.5569 green:0.5922 blue:0.6392 alpha:1.0].CGColor;
  button.layer.borderWidth = 0.25;
  [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  button.titleLabel.font = [UIFont systemFontOfSize:20 weight:800];
  return button;
}

+ (instancetype)buttonWithNumberControlStyle {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
  button.layer.backgroundColor = [UIColor colorWithRed:0.5569 green:0.5922 blue:0.6392 alpha:1.0].CGColor;
  button.layer.borderColor = [UIColor colorWithRed:0.749 green:0.7647 blue:0.7922 alpha:1.0].CGColor;
  button.layer.borderWidth = 0.25;
  [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  button.titleLabel.font = [UIFont systemFontOfSize:20 weight:800];
  return button;
}

@end
