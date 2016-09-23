//
//  LPDCollectionViewCell.h
//  LPDMvvmKit
//
//  Created by foxsofter on 16/2/22.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "LPDCollectionViewCellProtocol.h"
#import <UIKit/UIKit.h>

@interface LPDCollectionViewCell : UICollectionViewCell <LPDCollectionViewCellProtocol>

+ (instancetype) new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

@end
