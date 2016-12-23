//
//  LPDTableItemViewModel+React.m
//  LPDMvvmKit
//
//  Created by foxsofter on 16/1/4.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import <objc/runtime.h>
#import "LPDTableItemViewModel+React.h"
#import "LPDTableViewModel+React.h"

@implementation LPDTableCellViewModel (React)

- (RACSignal *)viewDidLoadSignal {
  return [self.viewModel viewDidLoadSignal];
}

- (RACSignal *)viewDidLayoutSubviewsSignal {
  return [self.viewModel viewDidLayoutSubviewsSignal];
}

- (RACSignal *)didBecomeActiveSignal {
  return [self.viewModel didBecomeActiveSignal];
}

- (RACSignal *)didBecomeInactiveSignal {
  return [self.viewModel didBecomeInactiveSignal];
}

- (LPDViewReactState)reactState {
  return [self.viewModel reactState];
}

- (void)setReactState:(LPDViewReactState)reactState {
  [self.viewModel setReactState:reactState];
}

- (BOOL)isSubmitting {
  return [self.viewModel isSubmitting];
}

- (void)setSubmitting:(BOOL)submitting {
  ((id<LPDViewModelReactProtocol>)self.viewModel).submitting = submitting;
}

- (void)setSubmittingWithMessage:(NSString *)message {
  [self.viewModel setSubmittingWithMessage:message];
}

- (RACSubject *)successSubject {
  return [self.viewModel successSubject];
}

- (RACSubject *)errorSubject {
  return [self.viewModel errorSubject];
}


@end
