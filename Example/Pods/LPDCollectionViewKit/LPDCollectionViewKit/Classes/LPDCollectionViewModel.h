//
//  LPDCollectionViewModel.h
//  LPDMvvmKit
//
//  Created by foxsofter on 16/2/22.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "LPDCollectionViewModelProtocol.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LPDCollectionViewModelProtocol;

@interface LPDCollectionViewModel : NSObject <LPDCollectionViewModelProtocol>

+ (instancetype) new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
