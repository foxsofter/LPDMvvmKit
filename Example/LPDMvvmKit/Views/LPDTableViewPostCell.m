//
//  LPDTableViewPostCell.m
//  LPDMvvmKit
//
//  Created by foxsofter on 16/9/21.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "LPDTableViewPostCell.h"
#import "Masonry.h"
#import "LPDPostModel.h"

@interface LPDTableViewPostCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *bodyLabel;

@end

@implementation LPDTableViewPostCell

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
  
  self.titleLabel = [[UILabel alloc]init];
  self.titleLabel.numberOfLines = 0;
  self.titleLabel.textColor = [UIColor blackColor];
  self.titleLabel.font = [UIFont systemFontOfSize:16];
  self.titleLabel.preferredMaxLayoutWidth = UIScreen.width - 30;
  [self.contentView addSubview:self.titleLabel];
  
  self.bodyLabel =[[UILabel alloc]init];
  self.bodyLabel.numberOfLines = 0;
  self.bodyLabel.textColor = [UIColor darkTextColor];
  self.bodyLabel.font = [UIFont systemFontOfSize:13];
  self.bodyLabel.preferredMaxLayoutWidth = UIScreen.width - 30;
  [self.contentView addSubview:self.bodyLabel];
  
  [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
    make.top.equalTo(@8);
    make.left.equalTo(@15);
    make.right.equalTo(@(-15));
  }];
  
  [self.bodyLabel mas_makeConstraints:^(MASConstraintMaker *make){
    make.left.equalTo(@15);
    make.top.equalTo(self.titleLabel.mas_bottom).offset(4);
    make.right.equalTo(@(-15));
    make.bottom.equalTo(@(-8)).priorityMedium();
  }];
}

-(void)bindingTo:(__kindof id<LPDTableCellViewModelProtocol>)viewModel {
  [super bindingTo:viewModel];
  
  self.titleLabel.text = ((LPDPostModel*)viewModel.model).title;
  self.bodyLabel.text = ((LPDPostModel*)viewModel.model).body;
  
  self.viewModel.height = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
}

@end
