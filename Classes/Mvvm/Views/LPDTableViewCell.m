//
//  LPDTableViewCell.m
//  LPDMvvmKit
//
//  Created by foxsofter on 16/1/3.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "LPDTableCellViewModel.h"
#import "LPDTableViewCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>


@interface LPDTableViewCell ()

@property (nullable, nonatomic, weak, readwrite) __kindof id<LPDTableCellViewModelProtocol> viewModel;

@end

@implementation LPDTableViewCell

- (void)bindingTo:(__kindof id<LPDTableCellViewModelProtocol>)viewModel {
  NSParameterAssert(viewModel);

  self.viewModel = viewModel;

  //  RAC(self.textLabel, text) = [RACObserve(self.selfViewModel, text) takeUntil:[self rac_prepareForReuseSignal]];
  //  RAC(self.detailTextLabel, text) = [RACObserve(self.selfViewModel, detail) takeUntil:[self
  //  rac_prepareForReuseSignal]];
  //  RAC(self.imageView, image) = [RACObserve(self.selfViewModel, image) takeUntil:[self rac_prepareForReuseSignal]];

  self.textLabel.text = self.selfViewModel.text;
  self.detailTextLabel.text = self.selfViewModel.detail;
  self.imageView.image = self.selfViewModel.image;
}

- (LPDTableCellViewModel *)selfViewModel {
  return self.viewModel;
}

-(void)prepareForReuse {
  self.textLabel.text = nil;
  self.detailTextLabel.text = nil;
}

@end

@implementation LPDTableViewDefaultCell

- (void)bindingTo:(__kindof id<LPDTableCellViewModelProtocol>)viewModel {
  [super bindingTo:viewModel];
  self.selectionStyle = UITableViewCellSelectionStyleNone;
}

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
