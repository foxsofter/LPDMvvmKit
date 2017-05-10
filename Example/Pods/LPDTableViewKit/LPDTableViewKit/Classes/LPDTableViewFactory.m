//
//  LPDTableViewFactory.m
//  LPDTableViewKit
//
//  Created by foxsofter on 16/1/3.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "LPDTableCellViewModel.h"
#import "LPDTableViewFactory.h"

@implementation LPDTableViewFactory

- (__kindof id<LPDTableViewItemProtocol>)tableViewModel:(__kindof id<LPDTableViewModelProtocol>)tableViewModel
                                          cellForTableView:(UITableView *)tableView
                                               atIndexPath:(NSIndexPath *)indexPath {
  __kindof id<LPDTableItemViewModelProtocol> cellViewModel = [tableViewModel cellViewModelFromIndexPath:indexPath];
  if (cellViewModel) {
    return [self cellWithViewModel:cellViewModel tableView:tableView];
  }

  return nil;
}

- (__kindof id<LPDTableViewItemProtocol>)cellWithViewModel:(__kindof id<LPDTableItemViewModelProtocol>)viewModel
                                                    tableView:(UITableView *)tableView {
  Class viewClass = NSClassFromString(viewModel.reuseViewClass);
  NSBundle *bundle = [NSBundle bundleForClass:viewClass];
  NSString *xibPath = [bundle pathForResource:viewModel.reuseViewClass ofType:@"nib"];
  if (xibPath && xibPath.length > 0) {
    [tableView registerNib:[UINib nibWithNibName:viewModel.reuseViewClass bundle:bundle]
      forCellReuseIdentifier:viewModel.reuseIdentifier];
  } else {
    [tableView registerClass:viewClass forCellReuseIdentifier:viewModel.reuseIdentifier];
  }

  id<LPDTableViewItemProtocol> cell = [tableView dequeueReusableCellWithIdentifier:viewModel.reuseIdentifier];
  if (!cell) {
    cell = [[viewClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:viewModel.reuseIdentifier];
  }
  [cell bindingTo:viewModel];

  return cell;
}

- (__kindof id<LPDTableViewItemProtocol>)tableViewModel:(__kindof id<LPDTableViewModelProtocol>)tableViewModel
                                        headerForTableView:(UITableView *)tableView
                                                 atSection:(NSInteger)sectionIndex {
  __kindof id<LPDTableItemViewModelProtocol> headerViewModel =
    [tableViewModel headerViewModelFromSection:sectionIndex];
  if (headerViewModel) {
    return [self hfWithViewModel:headerViewModel tableView:tableView];
  }
  return nil;
}

- (__kindof id<LPDTableItemViewModelProtocol>)headerWithViewModel:(__kindof id<LPDTableItemViewModelProtocol>)viewModel
                                                        tableView:(UITableView *)tableView {
  return [self hfWithViewModel:viewModel tableView:tableView];
}


- (__kindof id<LPDTableViewItemProtocol>)tableViewModel:(__kindof id<LPDTableViewModelProtocol>)tableViewModel
                                        footerForTableView:(UITableView *)tableView
                                                 atSection:(NSInteger)sectionIndex {
  __kindof id<LPDTableItemViewModelProtocol> footerViewModel =
    [tableViewModel footerViewModelFromSection:sectionIndex];
  if (footerViewModel) {
    return [self hfWithViewModel:footerViewModel tableView:tableView];
  }
  return nil;
}

- (__kindof id<LPDTableItemViewModelProtocol>)footerWithViewModel:(__kindof id<LPDTableItemViewModelProtocol>)viewModel
                                                        tableView:(UITableView *)tableView {
  return [self hfWithViewModel:viewModel tableView:tableView];
}


- (__kindof id<LPDTableViewItemProtocol>)hfWithViewModel:(__kindof id<LPDTableItemViewModelProtocol>)viewModel
                                                  tableView:(UITableView *)tableView {
  Class viewClass = NSClassFromString(viewModel.reuseViewClass);
  [tableView registerClass:viewClass forHeaderFooterViewReuseIdentifier:viewModel.reuseIdentifier];
  
  id<LPDTableViewItemProtocol> headerFooter =
  [tableView dequeueReusableHeaderFooterViewWithIdentifier:viewModel.reuseIdentifier];
  if (!headerFooter) {
    headerFooter = [[viewClass alloc] initWithReuseIdentifier:viewModel.reuseIdentifier];
  }
  [headerFooter bindingTo:viewModel];
  return headerFooter;
}


@end
