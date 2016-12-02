//
//  LPDTableViewFactory.h
//  LPDMvvmKit
//
//  Created by foxsofter on 16/1/3.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LPDTableViewCellProtocol.h"
#import "LPDTableViewHeaderFooterProtocol.h"
#import "LPDTableViewProtocol.h"

@interface LPDTableViewFactory : NSObject

- (__kindof id<LPDTableViewCellProtocol>)tableViewModel:(__kindof id<LPDTableViewModelProtocol>)tableViewModel
                                       cellForTableView:(UITableView *)tableView
                                            atIndexPath:(NSIndexPath *)indexPath;

- (__kindof id<LPDTableViewCellProtocol>)cellWithViewModel:(__kindof id<LPDTableCellViewModelProtocol>)viewModel
                                                 tableView:(UITableView *)tableView;

- (__kindof id<LPDTableViewHeaderFooterProtocol>)tableViewModel:(__kindof id<LPDTableViewModelProtocol>)tableViewModel
                                             headerForTableView:(UITableView *)tableView
                                                      atSection:(NSInteger)sectionIndex;

- (__kindof id<LPDTableViewHeaderFooterProtocol>)headerWithViewModel:
                                                   (__kindof id<LPDTableHeaderFooterViewModelProtocol>)viewModel
                                                           tableView:(UITableView *)tableView;

- (__kindof id<LPDTableViewHeaderFooterProtocol>)tableViewModel:(__kindof id<LPDTableViewModelProtocol>)tableViewModel
                                             footerForTableView:(UITableView *)tableView
                                                      atSection:(NSInteger)sectionIndex;

- (__kindof id<LPDTableViewHeaderFooterProtocol>)footerWithViewModel:
                                                   (__kindof id<LPDTableHeaderFooterViewModelProtocol>)viewModel
                                                           tableView:(UITableView *)tableView;
@end
