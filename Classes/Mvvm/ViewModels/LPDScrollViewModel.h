//
//  LPDScrollViewModel.h
//  LPDMvvmKit
//
//  Created by foxsofter on 15/12/13.
//  Copyright © 2015年 eleme. All rights reserved.
//

#import "LPDScrollViewModelProtocol.h"
#import "LPDViewModel.h"

/**
 *  @brief base view model for view controller with scrollView
 *   tableView, collectionView...
 */
@interface LPDScrollViewModel : LPDViewModel <LPDScrollViewModelProtocol>

@end
