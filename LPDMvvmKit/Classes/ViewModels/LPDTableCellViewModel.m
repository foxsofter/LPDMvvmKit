//
//  LPDTableCellViewModel.m
//  LPDMvvmKit
//
//  Created by foxsofter on 16/1/4.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "LPDTableCellViewModel.h"
#import "LPDTableViewModelProtocol.h"

@interface LPDTableCellViewModel ()

@property (nullable, nonatomic, weak, readwrite) __kindof id<LPDTableViewModelProtocol> viewModel;

@end

@implementation LPDTableCellViewModel

@synthesize height = _height;

- (instancetype)initWithViewModel:(__kindof id<LPDTableViewModelProtocol>)viewModel {
  self = [super init];
  if (self) {
    _viewModel = viewModel;
    _height = 44.f;
  }
  return self;
}

#pragma mark - LPDViewModelReactProtocl

- (LPDViewReactState)reactState {
  return self.viewModel.scrollViewModel.reactState;
}

- (void)setReactState:(LPDViewReactState)reactState {
  [self.viewModel.scrollViewModel setReactState:reactState];
}

- (BOOL)isSubmitting {
  return self.viewModel.scrollViewModel.isSubmitting;
}

- (void)setSubmitting:(BOOL)submitting {
  self.viewModel.scrollViewModel.submitting = submitting;
}

- (void)setSubmittingWithMessage:(NSString *)message {
  [self.viewModel.scrollViewModel setSubmittingWithMessage:message];
}

- (RACSubject *)successSubject {
  return self.viewModel.scrollViewModel.successSubject;
}

- (RACSubject *)errorSubject {
  return self.viewModel.scrollViewModel.errorSubject;
}

#pragma mark - LPDTableCellViewModelProtocol

- (Class)cellClass {
  return NSClassFromString(
    [[NSStringFromClass(self.class) stringByReplacingOccurrencesOfString:@"LPDTable" withString:@"LPDTableView"]
      stringByReplacingOccurrencesOfString:@"ViewModel"
                                withString:@""]);
}

- (NSString *)reuseIdentifier {
  return NSStringFromClass(self.class);
}

@end

@implementation LPDTableDefaultCellViewModel

- (Class)cellClass {
  return NSClassFromString(@"LPDTableViewDefaultCell");
}

@end

@implementation LPDTableValue1CellViewModel

- (Class)cellClass {
  return NSClassFromString(@"LPDTableViewValue1Cell");
}

@end

@implementation LPDTableValue2CellViewModel

- (Class)cellClass {
  return NSClassFromString(@"LPDTableViewValue2Cell");
}

@end

@implementation LPDTableSubtitleCellViewModel

- (Class)cellClass {
  return NSClassFromString(@"LPDTableViewSubtitleCell");
}

@end
