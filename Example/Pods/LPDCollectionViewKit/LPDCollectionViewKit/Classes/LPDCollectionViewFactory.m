//
//  LPDCollectionViewFactory.m
//  LPDMvvmKit
//
//  Created by foxsofter on 16/2/22.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "LPDCollectionViewFactory.h"

@implementation LPDCollectionViewFactory

- (__kindof id<LPDCollectionViewItemProtocol>)collectionViewModel:
  (__kindof id<LPDCollectionViewModelProtocol>)collectionViewModel
                                            cellForCollectionView:(UICollectionView *)collectionView
                                                      atIndexPath:(NSIndexPath *)indexPath {
  __kindof id<LPDCollectionItemViewModelProtocol> cellViewModel =
    [collectionViewModel cellViewModelFromIndexPath:indexPath];
  if (cellViewModel) {
    return [self cellWithViewModel:cellViewModel collectionView:collectionView atIndexPath:indexPath];
  }

  return nil;
}

- (__kindof id<LPDCollectionViewItemProtocol>)cellWithViewModel:
  (__kindof id<LPDCollectionItemViewModelProtocol>)viewModel
                                                 collectionView:(UICollectionView *)collectionView
                                                    atIndexPath:(NSIndexPath *)indexPath {
  NSString *xibPath = [[NSBundle mainBundle] pathForResource:viewModel.reuseViewClass ofType:@"nib"];
  if (xibPath && xibPath.length > 0) {
    [collectionView registerNib:[UINib nibWithNibName:viewModel.reuseViewClass bundle:nil]
      forCellWithReuseIdentifier:viewModel.reuseIdentifier];
  } else {
    [collectionView registerClass:NSClassFromString(viewModel.reuseViewClass) forCellWithReuseIdentifier:viewModel.reuseIdentifier];
  }

  id<LPDCollectionViewItemProtocol> cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:viewModel.reuseIdentifier forIndexPath:indexPath];
  [cell bindingTo:viewModel];
  return cell;
}

- (__kindof id<LPDCollectionItemViewModelProtocol>)collectionViewModel:
  (__kindof id<LPDCollectionViewModelProtocol>)collectionViewModel
                                               headerForCollectionView:(UICollectionView *)collectionView
                                                           atIndexPath:(NSIndexPath *)indexPath {
  __kindof id<LPDCollectionItemViewModelProtocol> headerViewModel =
    [collectionViewModel headerViewModelFromSection:indexPath.section];
  if (headerViewModel) {
    return [self headerWithViewModel:headerViewModel collectionView:collectionView atIndexPath:indexPath];
  }
  return nil;
}

- (__kindof id<LPDCollectionItemViewModelProtocol>)headerWithViewModel:
  (__kindof id<LPDCollectionItemViewModelProtocol>)viewModel
                                                        collectionView:(UICollectionView *)collectionView
                                                           atIndexPath:(NSIndexPath *)indexPath {

  [collectionView registerClass:NSClassFromString(viewModel.reuseViewClass)
     forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
            withReuseIdentifier:viewModel.reuseIdentifier];

  id<LPDCollectionViewItemProtocol> header =
    [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                       withReuseIdentifier:viewModel.reuseIdentifier
                                              forIndexPath:indexPath];
  [header bindingTo:viewModel];
  return header;
}

- (__kindof id<LPDCollectionItemViewModelProtocol>)collectionViewModel:
  (__kindof id<LPDCollectionViewModelProtocol>)collectionViewModel
                                               footerForCollectionView:(UICollectionView *)collectionView
                                                           atIndexPath:(NSIndexPath *)indexPath {
  __kindof id<LPDCollectionItemViewModelProtocol> footerViewModel =
    [collectionViewModel footerViewModelFromSection:indexPath.section];
  if (footerViewModel) {
    return [self footerWithViewModel:footerViewModel collectionView:collectionView atIndexPath:indexPath];
  }
  return nil;
}

- (__kindof id<LPDCollectionItemViewModelProtocol>)footerWithViewModel:
  (__kindof id<LPDCollectionItemViewModelProtocol>)viewModel
                                                        collectionView:(UICollectionView *)collectionView
                                                           atIndexPath:(NSIndexPath *)indexPath {
  [collectionView registerClass:NSClassFromString(viewModel.reuseViewClass)
     forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
            withReuseIdentifier:viewModel.reuseIdentifier];

  id<LPDCollectionViewItemProtocol> footer =
    [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                       withReuseIdentifier:viewModel.reuseIdentifier
                                              forIndexPath:indexPath];
  [footer bindingTo:viewModel];
  return footer;
}

@end
