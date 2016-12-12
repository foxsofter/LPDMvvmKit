//
//  LPDTableItemViewModelReactProtocol.h
//  LPDMvvmKit
//
//  Created by foxsofter on 16/12/12.
//
//

#import <Foundation/Foundation.h>
#import <LPDTableViewKit/LPDTableViewKit.h>
#import "LPDViewModelReactProtocol.h"
#import "LPDTableViewModel+React.h"

@protocol LPDTableItemViewModelReactProtocol <LPDViewModelReactProtocol>

@property (nullable, nonatomic, weak) __kindof LPDTableViewModel *viewModel;

@end

//#ifndef LPDSubviewModelReactProtocol_Extension
//#define LPDSubviewModelReactProtocol_Extension
//
//@defs(LPDSubviewModelReactProtocol)
//
//- (LPDViewReactState)reactState {
//  return self.viewModel.reactState;
//}
//
//- (void)setReactState:(LPDViewReactState)reactState {
//  [self.viewModel setReactState:reactState];
//}
//
//- (BOOL)isSubmitting {
//  return self.viewModel.isSubmitting;
//}
//
//- (void)setSubmitting:(BOOL)submitting {
//  self.viewModel.submitting = submitting;
//}
//
//- (void)setSubmittingWithMessage:(NSString *)message {
//  [self.viewModel setSubmittingWithMessage:message];
//}
//
//- (RACSubject *)successSubject {
//  return self.viewModel.successSubject;
//}
//
//- (RACSubject *)errorSubject {
//  return self.viewModel.errorSubject;
//}
//
//@end
//
//#endif //LPDSubviewModelReactProtocol_Extension
