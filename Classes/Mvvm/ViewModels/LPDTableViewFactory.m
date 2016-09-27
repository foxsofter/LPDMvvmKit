//
//  LPDTableViewFactory.m
//  LPDMvvmKit
//
//  Created by foxsofter on 16/1/3.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "LPDTableCellViewModel.h"
#import "LPDTableViewFactory.h"

@interface LPDTableViewFactory ()

@property (nonatomic, copy) NSMutableArray *reuseIdentifiersOfCell;
@property (nonatomic, copy) NSMutableArray *reuseIdentifiersOfHeader;
@property (nonatomic, copy) NSMutableArray *reuseIdentifiersOfFooter;

@end

@implementation LPDTableViewFactory

- (instancetype)init {
  self = [super init];
  if (self) {
    _reuseIdentifiersOfCell = [NSMutableArray array];
  }
  return self;
}

- (__kindof id<LPDTableViewCellProtocol>)tableViewModel:(__kindof id<LPDTableViewModelProtocol>)tableViewModel
                                       cellForTableView:(UITableView *)tableView
                                            atIndexPath:(NSIndexPath *)indexPath {
  __kindof id<LPDTableCellViewModelProtocol> cellViewModel = [tableViewModel cellViewModelFromIndexPath:indexPath];
  if (cellViewModel) {
    return [self cellWithViewModel:cellViewModel tableView:tableView];
  }

  return nil;
}

- (__kindof id<LPDTableViewCellProtocol>)cellWithViewModel:(__kindof id<LPDTableCellViewModelProtocol>)viewModel
                                                 tableView:(UITableView *)tableView {
  NSString *reuseIdentifier =
    [NSString stringWithFormat:@"%@-%@", NSStringFromClass(viewModel.cellClass), viewModel.reuseIdentifier];
  if (![self.reuseIdentifiersOfCell containsObject:reuseIdentifier]) {
    [self.reuseIdentifiersOfCell addObject:reuseIdentifier];
    NSString *xibPath = [[NSBundle mainBundle] pathForResource:NSStringFromClass(viewModel.cellClass) ofType:@"nib"];
    if (xibPath && xibPath.length > 0) {
      [tableView registerNib:[UINib nibWithNibName:NSStringFromClass(viewModel.cellClass) bundle:nil]
        forCellReuseIdentifier:reuseIdentifier];
    } else {
      [tableView registerClass:viewModel.cellClass forCellReuseIdentifier:reuseIdentifier];
    }
  }

  id<LPDTableViewCellProtocol> cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  if (!cell) {
    cell = [[viewModel.cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
  }
  [cell bindingTo:viewModel];

  return cell;
}

- (__kindof id<LPDTableViewHeaderFooterProtocol>)tableViewModel:(__kindof id<LPDTableViewModelProtocol>)tableViewModel
                                             headerForTableView:(UITableView *)tableView
                                                      atSection:(NSInteger)sectionIndex {
  __kindof id<LPDTableHeaderFooterViewModelProtocol> headerViewModel =
    [tableViewModel headerViewModelFromSection:sectionIndex];
  if (headerViewModel) {
    return [self headerWithViewModel:headerViewModel tableView:tableView];
  }
  return nil;
}

- (__kindof id<LPDTableViewHeaderFooterProtocol>)headerWithViewModel:
                                                   (__kindof id<LPDTableHeaderFooterViewModelProtocol>)viewModel
                                                           tableView:(UITableView *)tableView {
  NSString *reuseIdentifier = [NSString
    stringWithFormat:@"header-%@-%@", NSStringFromClass(viewModel.headerFooterClass), viewModel.reuseIdentifier];
  if (![self.reuseIdentifiersOfHeader containsObject:reuseIdentifier]) {
    [self.reuseIdentifiersOfHeader addObject:reuseIdentifier];
    [tableView registerClass:viewModel.headerFooterClass forHeaderFooterViewReuseIdentifier:reuseIdentifier];
  }

  id<LPDTableViewHeaderFooterProtocol> header =
    [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseIdentifier];
  if (!header) {
    header = [[viewModel.headerFooterClass alloc] initWithReuseIdentifier:reuseIdentifier];
  }
  [header bindingTo:viewModel];
  return header;
}

- (__kindof id<LPDTableViewHeaderFooterProtocol>)tableViewModel:(__kindof id<LPDTableViewModelProtocol>)tableViewModel
                                             footerForTableView:(UITableView *)tableView
                                                      atSection:(NSInteger)sectionIndex {
  __kindof id<LPDTableHeaderFooterViewModelProtocol> footerViewModel =
    [tableViewModel footerViewModelFromSection:sectionIndex];
  if (footerViewModel) {
    return [self footerWithViewModel:footerViewModel tableView:tableView];
  }
  return nil;
}

- (__kindof id<LPDTableViewHeaderFooterProtocol>)footerWithViewModel:
                                                   (__kindof id<LPDTableHeaderFooterViewModelProtocol>)viewModel
                                                           tableView:(UITableView *)tableView {
  NSString *reuseIdentifier = [NSString
    stringWithFormat:@"footer-%@-%@", NSStringFromClass(viewModel.headerFooterClass), viewModel.reuseIdentifier];
  if (![self.reuseIdentifiersOfFooter containsObject:reuseIdentifier]) {
    [self.reuseIdentifiersOfFooter addObject:reuseIdentifier];
    [tableView registerClass:viewModel.headerFooterClass forHeaderFooterViewReuseIdentifier:reuseIdentifier];
  }

  id<LPDTableViewHeaderFooterProtocol> footer =
    [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseIdentifier];
  if (!footer) {
    footer = [[viewModel.headerFooterClass alloc] initWithReuseIdentifier:reuseIdentifier];
  }
  [footer bindingTo:viewModel];
  return footer;
}

@end
