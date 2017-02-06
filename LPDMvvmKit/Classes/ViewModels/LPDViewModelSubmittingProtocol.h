//
//  LPDViewModelSubmittingProtocol.h
//  LPDMvvmKit
//
//  Created by foxsofter on 17/2/3.
//
//

#import <Foundation/Foundation.h>

@protocol LPDViewModelSubmittingProtocol<NSObject>

@property (nonatomic, assign, getter=isSubmitting) BOOL submitting;

- (void)setSubmittingWithMessage:(NSString *)message;

@end
