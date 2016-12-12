//
//  LPDTableView.h
//  LPDTableViewKit
//
//  Created by foxsofter on 16/1/5.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPDTableViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPDTableView : UITableView <LPDTableViewProtocol>

+ (instancetype) new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
