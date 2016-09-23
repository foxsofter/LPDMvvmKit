//
//  LPDTableViewHeaderFooter.m
//  LPDMvvmKit
//
//  Created by foxsofter on 16/1/8.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "LPDTableViewHeaderFooter.h"
#import "ReactiveCocoa.h"
#import "UITableViewHeaderFooterView+RACSignalSupport.h"

@interface LPDTableViewHeaderFooter ()

@property (nullable, nonatomic, weak, readwrite) __kindof id<LPDTableHeaderFooterViewModelProtocol> viewModel;

@end

@implementation LPDTableViewHeaderFooter

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithReuseIdentifier:reuseIdentifier];
  if (self) {
    self.contentView.backgroundColor = [UIColor colorWithRed:0.9216 green:0.9216 blue:0.9451 alpha:1.0];
    self.textLabel.font = [UIFont systemFontOfSize:13];
    self.textLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
  }
  return self;
}

- (void)bindingTo:(__kindof id<LPDTableHeaderFooterViewModelProtocol>)viewModel {
  NSParameterAssert(viewModel);

  self.viewModel = viewModel;

  @weakify(self);
  [[self rac_prepareForReuseSignal] subscribeNext:^(id x) {
    @strongify(self);
    self.viewModel = nil;
  }];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  self.textLabel.font = [UIFont systemFontOfSize:13];
  self.textLabel.superview.backgroundColor = [UIColor colorWithRed:0.9216 green:0.9216 blue:0.9451 alpha:1.0];
  self.textLabel.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0];
}

@end

@implementation LPDTableViewHeader

@end

@implementation LPDTableViewFooter

@end