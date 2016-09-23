//
//  LPDTableCellViewModelProtocol.h
//  LPDMvvmKit
//
//  Created by foxsofter on 16/1/3.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LPDModelProtocol.h"
#import "LPDViewModelReactProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LPDTableViewModelProtocol;

@protocol LPDTableCellViewModelProtocol <LPDViewModelReactProtocol>

@required

- (instancetype)initWithViewModel:(__kindof id<LPDTableViewModelProtocol>)viewModel;

@property (nullable, nonatomic, weak, readonly) __kindof id<LPDTableViewModelProtocol> viewModel;

@property (nonatomic, copy, readonly) NSString *reuseIdentifier;

@property (nonatomic, assign, readonly) Class cellClass;

@property (nonatomic, assign) CGFloat height;

@optional

@property (nonatomic, strong) id<LPDModelProtocol> model;

@end

NS_ASSUME_NONNULL_END