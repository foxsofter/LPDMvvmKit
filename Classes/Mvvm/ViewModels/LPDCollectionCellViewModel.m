//
//  LPDCollectionCellViewModel.m
//  LPDMvvmKit
//
//  Created by foxsofter on 16/2/22.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "LPDCollectionCellViewModel.h"
#import "LPDCollectionViewModelProtocol.h"

@interface LPDCollectionCellViewModel ()

@property (nullable, nonatomic, weak, readwrite) __kindof id<LPDCollectionViewModelProtocol> viewModel;

@end

@implementation LPDCollectionCellViewModel

- (instancetype)initWithViewModel:(__kindof id<LPDCollectionViewModelProtocol>)viewModel {
  self = [super init];
  if (self) {
    _viewModel = viewModel;
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

#pragma mark - LPDCollectionCellViewModelProtocol

- (Class)cellClass {
  return NSClassFromString([[NSStringFromClass(self.class) stringByReplacingOccurrencesOfString:@"LPDCollection"
                                                                                     withString:@"LPDCollectionView"]
    stringByReplacingOccurrencesOfString:@"ViewModel"
                              withString:@""]);
}

- (NSString *)reuseIdentifier {
  return NSStringFromClass(self.class);
}

@end
