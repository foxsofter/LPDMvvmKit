//
//  LPDScrollViewModelProtocol.h
//  LPDMvvmKit
//
//  Created by foxsofter on 15/12/13.
//  Copyright © 2015年 eleme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPDViewModelProtocol.h"
#import "LPDViewModelLoadingMoreProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LPDScrollViewModelProtocol <LPDViewModelProtocol, LPDViewModelLoadingMoreProtocol>

@end

NS_ASSUME_NONNULL_END
