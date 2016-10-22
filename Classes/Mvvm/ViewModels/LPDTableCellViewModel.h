//
//  LPDTableCellViewModel.h
//  LPDMvvmKit
//
//  Created by foxsofter on 16/1/4.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "LPDTableCellViewModelProtocol.h"

@interface LPDTableCellViewModel : NSObject <LPDTableCellViewModelProtocol>

+ (instancetype) new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, copy) NSString *text;

@property (nonatomic, copy) NSString *detail;

@property (nonatomic) UITableViewCellAccessoryType accessoryType;

@property (nonatomic) UITableViewCellSelectionStyle   selectionStyle;
@end

@interface LPDTableDefaultCellViewModel : LPDTableCellViewModel

@end

@interface LPDTableValue1CellViewModel : LPDTableCellViewModel

@end

@interface LPDTableValue2CellViewModel : LPDTableCellViewModel

@end

@interface LPDTableSubtitleCellViewModel : LPDTableCellViewModel

@end
