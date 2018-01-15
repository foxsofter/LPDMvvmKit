//
//  LPDTableViewStandardCell.h
//  LPDTeam
//
//  Created by 李博 on 16/4/6.
//  Copyright © 2016年 me.ele. All rights reserved.
//

#import "LPDTableViewCell.h"

@interface LPDTableViewStandardCell : LPDTableViewCell

@property (nonatomic, strong) UIImageView *icon;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;

- (void)loadSubviews;

@end
