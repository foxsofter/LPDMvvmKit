//
//  LPDCollectionViewFactory.m
//  LPDMvvmKit
//
//  Created by foxsofter on 16/2/22.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "LPDCollectionViewFactory.h"

@interface LPDCollectionViewFactory ()

@property (nonatomic, copy) NSMutableArray *reuseIdentifiersOfCell;
@property (nonatomic, copy) NSMutableArray *reuseIdentifiersOfHeader;
@property (nonatomic, copy) NSMutableArray *reuseIdentifiersOfFooter;

@end

@implementation LPDCollectionViewFactory

- (instancetype)init {
  self = [super init];
  if (self) {
    _reuseIdentifiersOfCell = [NSMutableArray array];
  }
  return self;
}

- (__kindof id<LPDCollectionViewCellProtocol>)collectionViewModel:
                                                (__kindof id<LPDCollectionViewModelProtocol>)collectionViewModel
                                            cellForCollectionView:(UICollectionView *)collectionView
                                                      atIndexPath:(NSIndexPath *)indexPath {
  __kindof id<LPDCollectionCellViewModelProtocol> cellViewModel =
    [collectionViewModel cellViewModelFromIndexPath:indexPath];
  if (cellViewModel) {
    return [self cellWithViewModel:cellViewModel collectionView:collectionView atIndexPath:indexPath];
  }

  return nil;
}

- (__kindof id<LPDCollectionViewCellProtocol>)cellWithViewModel:
                                                (__kindof id<LPDCollectionCellViewModelProtocol>)viewModel
                                                 collectionView:(UICollectionView *)collectionView
                                                    atIndexPath:(NSIndexPath *)indexPath {

  NSString *reuseIdentifier =
    [NSString stringWithFormat:@"%@-%@", NSStringFromClass(viewModel.cellClass), viewModel.reuseIdentifier];
  if (![self.reuseIdentifiersOfCell containsObject:reuseIdentifier]) {
    [self.reuseIdentifiersOfCell addObject:reuseIdentifier];
    NSString *xibPath = [[NSBundle mainBundle] pathForResource:NSStringFromClass(viewModel.cellClass) ofType:@"nib"];
    if (xibPath && xibPath.length > 0) {
      [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(viewModel.cellClass) bundle:nil]
        forCellWithReuseIdentifier:reuseIdentifier];
    } else {
      [collectionView registerClass:viewModel.cellClass forCellWithReuseIdentifier:reuseIdentifier];
    }
  }

  id<LPDCollectionViewCellProtocol> cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
  [cell bindingTo:viewModel];
  return cell;
}

- (__kindof id<LPDCollectionViewHeaderFooterProtocol>)collectionViewModel:
                                                        (__kindof id<LPDCollectionViewModelProtocol>)collectionViewModel
                                                  headerForCollectionView:(UICollectionView *)collectionView
                                                              atIndexPath:(NSIndexPath *)indexPath {
  __kindof id<LPDCollectionHeaderFooterViewModelProtocol> headerViewModel =
    [collectionViewModel headerViewModelFromSection:indexPath.section];
  if (headerViewModel) {
    return [self headerWithViewModel:headerViewModel collectionView:collectionView atIndexPath:indexPath];
  }
  return nil;
}

- (__kindof id<LPDCollectionViewHeaderFooterProtocol>)
headerWithViewModel:(__kindof id<LPDCollectionHeaderFooterViewModelProtocol>)viewModel
     collectionView:(UICollectionView *)collectionView
        atIndexPath:(NSIndexPath *)indexPath {
  NSString *reuseIdentifier =
    [NSString stringWithFormat:@"header-%@-%@", NSStringFromClass(viewModel.headerFooterClass), viewModel.reuseIdentifier];
  if (![self.reuseIdentifiersOfHeader containsObject:reuseIdentifier]) {
    [self.reuseIdentifiersOfHeader addObject:reuseIdentifier];
    [collectionView registerClass:viewModel.headerFooterClass
       forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
              withReuseIdentifier:reuseIdentifier];
  }

  id<LPDCollectionViewHeaderFooterProtocol> header =
    [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                       withReuseIdentifier:reuseIdentifier
                                              forIndexPath:indexPath];
  [header bindingTo:viewModel];
  return header;
}

- (__kindof id<LPDCollectionViewHeaderFooterProtocol>)collectionViewModel:
                                                        (__kindof id<LPDCollectionViewModelProtocol>)collectionViewModel
                                                  footerForCollectionView:(UICollectionView *)collectionView
                                                              atIndexPath:(NSIndexPath *)indexPath {
  __kindof id<LPDCollectionHeaderFooterViewModelProtocol> footerViewModel =
    [collectionViewModel footerViewModelFromSection:indexPath.section];
  if (footerViewModel) {
    return [self footerWithViewModel:footerViewModel collectionView:collectionView atIndexPath:indexPath];
  }
  return nil;
}

- (__kindof id<LPDCollectionViewHeaderFooterProtocol>)
footerWithViewModel:(__kindof id<LPDCollectionHeaderFooterViewModelProtocol>)viewModel
     collectionView:(UICollectionView *)collectionView
        atIndexPath:(NSIndexPath *)indexPath {
  NSString *reuseIdentifier =
    [NSString stringWithFormat:@"footer-%@-%@", NSStringFromClass(viewModel.headerFooterClass), viewModel.reuseIdentifier];
  if (![self.reuseIdentifiersOfFooter containsObject:reuseIdentifier]) {
    [self.reuseIdentifiersOfFooter addObject:reuseIdentifier];
    [collectionView registerClass:viewModel.headerFooterClass
       forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
              withReuseIdentifier:reuseIdentifier];
  }

  id<LPDCollectionViewHeaderFooterProtocol> footer =
    [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                       withReuseIdentifier:reuseIdentifier
                                              forIndexPath:indexPath];
  [footer bindingTo:viewModel];
  return footer;
}

@end
