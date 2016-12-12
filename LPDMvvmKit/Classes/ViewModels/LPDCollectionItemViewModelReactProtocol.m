//
//  LPDCollectionItemViewModelReactProtocol.m
//  LPDMvvmKit
//
//  Created by foxsofter on 16/12/12.
//
//

//#ifndef LPDSubviewModelReactProtocol_h
//#define LPDSubviewModelReactProtocol_h

#import <objc/runtime.h>
#import <ProtocolKit/ProtocolKit.h>
#import "LPDCollectionItemViewModelReactProtocol.h"

@defs(LPDCollectionItemViewModelReactProtocol)

//- (__kindof id<LPDViewModelProtocol>)viewModel {
//  return objc_getAssociatedObject(self, @selector(setViewModel:));
//}
//
//- (void)setViewModel:(__kindof id<LPDViewModelProtocol> _Nullable)viewModel {
//  objc_setAssociatedObject(self, @selector(setViewModel:), viewModel, OBJC_ASSOCIATION_ASSIGN);
//}

- (LPDViewReactState)reactState {
  return self.viewModel.reactState;
}

- (void)setReactState:(LPDViewReactState)reactState {
  [self.viewModel setReactState:reactState];
}

- (BOOL)isSubmitting {
  return self.viewModel.isSubmitting;
}

- (void)setSubmitting:(BOOL)submitting {
  self.viewModel.submitting = submitting;
}

- (void)setSubmittingWithMessage:(NSString *)message {
  [self.viewModel setSubmittingWithMessage:message];
}

- (RACSubject *)successSubject {
  return self.viewModel.successSubject;
}

- (RACSubject *)errorSubject {
  return self.viewModel.errorSubject;
}

@end

//#endif // LPDSubviewModelReactProtocol_h
