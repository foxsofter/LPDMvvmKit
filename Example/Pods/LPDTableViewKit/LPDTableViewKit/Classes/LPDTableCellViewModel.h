//
//  LPDTableCellViewModel.h
//  LPDTableViewKit
//
//  Created by foxsofter on 16/1/4.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "LPDTableItemViewModel.h"

@interface LPDTableCellViewModel : LPDTableItemViewModel

+ (instancetype) new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, copy) NSString *text;

@property (nonatomic, copy) NSString *detail;

@property (nonatomic) UITableViewCellAccessoryType accessoryType;

@property (nonatomic) UITableViewCellSelectionStyle   selectionStyle;

@property (nonatomic, strong) NSMutableAttributedString *attributedText;

@end

@interface LPDTableDefaultCellViewModel : LPDTableCellViewModel

@end

@interface LPDTableValue1CellViewModel : LPDTableCellViewModel

@end

@interface LPDTableValue2CellViewModel : LPDTableCellViewModel

@end

@interface LPDTableSubtitleCellViewModel : LPDTableCellViewModel

@end
