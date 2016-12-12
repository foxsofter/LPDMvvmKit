//
//  LPDCollectionViewHeader.h
//  LPDMvvmKit
//
//  Created by foxsofter on 16/2/22.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "LPDCollectionItemViewModelProtocol.h"
#import <UIKit/UIKit.h>

@interface LPDCollectionViewHeader : UICollectionReusableView <LPDCollectionItemViewModelProtocol>

+ (instancetype) new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

@property (nonatomic, strong) UILabel *textLabel;

@end
