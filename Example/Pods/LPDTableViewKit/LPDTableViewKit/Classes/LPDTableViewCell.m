//
//  LPDTableViewCell.m
//  LPDTableViewKit
//
//  Created by foxsofter on 16/1/3.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "LPDTableViewCell.h"
#import "LPDTableCellViewModel.h"

@interface LPDTableViewCell ()

@property (nullable, nonatomic, weak, readwrite) __kindof id<LPDTableItemViewModelProtocol> viewModel;

@end

@implementation LPDTableViewCell

- (void)bindingTo:(__kindof id<LPDTableItemViewModelProtocol>)viewModel {
  NSParameterAssert(viewModel);

  self.viewModel = viewModel;
  LPDTableCellViewModel *cellViewModel = viewModel;
  self.textLabel.text = cellViewModel.text;
  self.detailTextLabel.text = cellViewModel.detail;
  self.imageView.image = cellViewModel.image;
  self.accessoryType = cellViewModel.accessoryType;
  self.selectionStyle = cellViewModel.selectionStyle;
  if (cellViewModel.attributedText) {
    self.textLabel.attributedText = cellViewModel.attributedText;
  }
}


-(void)prepareForReuse {
  [super prepareForReuse];
  self.textLabel.text = nil;
  self.detailTextLabel.text = nil;
  self.imageView.image = nil;
}

@end

@implementation LPDTableViewDefaultCell

@end

@implementation LPDTableViewValue1Cell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  return [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
}

@end

@implementation LPDTableViewValue2Cell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  return [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:reuseIdentifier];
}

@end

@implementation LPDTableViewSubtitleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  return [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
}

@end
