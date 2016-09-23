//
//  LPDKeyButtonPopupView.h
//  FoxKit
//
//  Created by ZhongDanWei on 15/11/30.
//  Copyright © 2015年 foxsofter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LPDKeyButtonPopupView : UIView

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (instancetype)initWithKeyboardButton:(UIButton *)keyButton;

@end
