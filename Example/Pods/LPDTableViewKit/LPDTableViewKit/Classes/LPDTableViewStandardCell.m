//
//  LPDTableViewStandardCell.m
//  LPDTeam
//
//  Created by 李博 on 16/4/6.
//  Copyright © 2016年 me.ele. All rights reserved.
//

#import "LPDTableStandardCellViewModel.h"
#import "LPDTableViewStandardCell.h"
#import <Masonry/Masonry.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import <LPDAdditionsKit/UIScreen+LPDAccessor.h>

@interface LPDTableViewStandardCell ()

@end

@implementation LPDTableViewStandardCell

#pragma mark - life cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    [self loadSubviews];
  }
  return self;
}

- (void)loadSubviews {
  self.selectionStyle = UITableViewCellSelectionStyleNone;

  _icon = [[UIImageView alloc] init];
  [self.contentView addSubview:_icon];

  _titleLabel = [[UILabel alloc] init];
  _titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
  _titleLabel.font = [UIFont systemFontOfSize:16];
  [self.contentView addSubview:_titleLabel];

  _contentLabel = [[UILabel alloc] init];
  _contentLabel.font = [UIFont systemFontOfSize:13];
  _contentLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
  _contentLabel.textAlignment = NSTextAlignmentRight;
  [self.contentView addSubview:_contentLabel];

  [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
    make.width.height.equalTo(@22);
    make.left.equalTo(@20);
    make.centerY.equalTo(self.contentView.mas_centerY);
  }];

  [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(self.contentView.mas_centerY);
    make.left.equalTo(self.contentView.mas_left).with.offset(57);
  }];

  [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(self.contentView.mas_centerY);
    make.right.equalTo(@-20);
  }];
}

- (void)bindingTo:(__kindof id<LPDTableItemViewModelProtocol>)viewModel {
  [super bindingTo:viewModel];
  
  LPDTableStandardCellViewModel *cellViewModel = viewModel;

  RAC(self.icon, image) = [RACObserve(cellViewModel, icon) takeUntil:[self rac_prepareForReuseSignal]];
  RAC(self.titleLabel, text) = [RACObserve(cellViewModel, title) takeUntil:[self rac_prepareForReuseSignal]];
  RAC(self.contentLabel, text) = [RACObserve(cellViewModel, content) takeUntil:[self rac_prepareForReuseSignal]];
  RAC(self.contentLabel, hidden) =
    [[RACObserve(cellViewModel, contentShow) not] takeUntil:[self rac_prepareForReuseSignal]];

  cellViewModel.height = 49.5f;
}

@end
