//
//  LPDTableHeaderFooterViewModelProtocol.h
//  LPDMvvmKit
//
//  Created by foxsofter on 16/1/8.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LPDViewModelReactProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LPDTableViewModelProtocol;

@protocol LPDTableHeaderFooterViewModelProtocol <LPDViewModelReactProtocol>
@required

- (instancetype)initWithViewModel:(__kindof id<LPDTableViewModelProtocol>)viewModel;

@property (nullable, nonatomic, weak, readonly) __kindof id<LPDTableViewModelProtocol> viewModel;

@property (nonatomic, copy, readonly) NSString *reuseIdentifier;

@property (nonatomic, assign, readonly) Class headerFooterClass;

@property (nonatomic, assign) CGFloat height;

@end

NS_ASSUME_NONNULL_END
