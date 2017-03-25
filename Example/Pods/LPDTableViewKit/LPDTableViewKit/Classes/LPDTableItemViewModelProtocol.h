//
//  LPDTableItemViewModelProtocol.h
//  LPDTableViewKit
//
//  Created by foxsofter on 16/1/8.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LPDTableViewModelProtocol;

@protocol LPDTableItemViewModelProtocol<NSObject>

@required

- (instancetype)initWithViewModel:(__kindof id<LPDTableViewModelProtocol>)viewModel;

@property (nullable, nonatomic, weak, readonly) __kindof id<LPDTableViewModelProtocol> viewModel;

@property (nonatomic, copy, readonly) NSString *reuseIdentifier;

@property (nonatomic, copy, readonly) NSString *reuseViewClass;

@optional

@property (nonatomic, assign) CGFloat height;

@end

NS_ASSUME_NONNULL_END
