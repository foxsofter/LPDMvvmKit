//
//  LPDSubviewModelReactProtocol.h
//  LPDMvvmKit
//
//  Created by foxsofter on 16/12/12.
//
//

#import <Foundation/Foundation.h>
#import "LPDViewModelReactProtocol.h"
#import "LPDViewModelProtocol.h"

@protocol LPDSubviewModelReactProtocol <LPDViewModelReactProtocol>

@property (nullable, nonatomic, weak) __kindof id<LPDViewModelProtocol> viewModel;

@end
