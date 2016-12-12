//
//  LPDTableViewFactory.h
//  LPDTableViewKit
//
//  Created by foxsofter on 16/1/3.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LPDTableViewCell.h"
#import "LPDTableCellViewModel.h"
#import "LPDTableViewHeader.h"
#import "LPDTableHeaderViewModel.h"
#import "LPDTableViewFooter.h"
#import "LPDTableFooterViewModel.h"
#import "LPDTableViewProtocol.h"

@interface LPDTableViewFactory : NSObject

- (__kindof id<LPDTableItemViewModelProtocol>)tableViewModel:(__kindof id<LPDTableViewModelProtocol>)tableViewModel
                            cellForTableView:(UITableView *)tableView
                                 atIndexPath:(NSIndexPath *)indexPath;

- (__kindof id<LPDTableItemViewModelProtocol>)cellWithViewModel:(__kindof id<LPDTableItemViewModelProtocol>)viewModel
                                      tableView:(UITableView *)tableView;

- (__kindof id<LPDTableItemViewModelProtocol>)tableViewModel:(__kindof id<LPDTableViewModelProtocol>)tableViewModel
                            headerForTableView:(UITableView *)tableView
                                     atSection:(NSInteger)sectionIndex;

- (__kindof id<LPDTableItemViewModelProtocol>)headerWithViewModel:(__kindof id<LPDTableItemViewModelProtocol>)viewModel
                                          tableView:(UITableView *)tableView;

- (__kindof id<LPDTableItemViewModelProtocol>)tableViewModel:(__kindof id<LPDTableItemViewModelProtocol>)tableViewModel
                            footerForTableView:(UITableView *)tableView
                                     atSection:(NSInteger)sectionIndex;

- (__kindof id<LPDTableItemViewModelProtocol>)footerWithViewModel:(__kindof id<LPDTableItemViewModelProtocol>)viewModel
                                          tableView:(UITableView *)tableView;
@end
