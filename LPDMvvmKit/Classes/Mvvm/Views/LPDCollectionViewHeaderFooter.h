//
//  LPDCollectionViewHeaderFooter.h
//  LPDMvvmKit
//
//  Created by foxsofter on 16/2/22.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "LPDCollectionViewHeaderFooterProtocol.h"
#import <UIKit/UIKit.h>

@interface LPDCollectionViewHeaderFooter : UICollectionReusableView <LPDCollectionViewHeaderFooterProtocol>

+ (instancetype) new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

@property (nonatomic, strong) UILabel *textLabel;

@end

@interface LPDCollectionViewHeader : LPDCollectionViewHeaderFooter

@end

@interface LPDCollectionViewFooter : LPDCollectionViewHeaderFooter

@end