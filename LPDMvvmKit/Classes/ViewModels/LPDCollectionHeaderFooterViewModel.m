//
//  LPDCollectionHeaderFooterViewModel.m
//  LPDMvvmKit
//
//  Created by foxsofter on 16/2/22.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "LPDCollectionHeaderFooterViewModel.h"
#import "LPDCollectionViewModelProtocol.h"

@protocol LPDCollectionViewModelProtocol;

@interface LPDCollectionHeaderFooterViewModel ()

@property (nullable, nonatomic, weak, readwrite) __kindof id<LPDCollectionViewModelProtocol> viewModel;

@end

@implementation LPDCollectionHeaderFooterViewModel

@synthesize height = _height;

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

#pragma mark - LPDCollectionViewModelProtocol

- (Class)headerFooterClass {
  return NSClassFromString([[NSStringFromClass(self.class) stringByReplacingOccurrencesOfString:@"LPDCollection"
                                                                                     withString:@"LPDCollectionView"]
    stringByReplacingOccurrencesOfString:@"ViewModel"
                              withString:@""]);
}

- (NSString *)reuseIdentifier {
  return NSStringFromClass(self.class);
}

@end

@implementation LPDCollectionHeaderViewModel

@end

@implementation LPDCollectionFooterViewModel

@end
