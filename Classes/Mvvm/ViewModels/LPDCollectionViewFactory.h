//
//  LPDCollectionViewFactory.h
//  LPDMvvmKit
//
//  Created by foxsofter on 16/2/22.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LPDCollectionViewCellProtocol.h"
#import "LPDCollectionViewHeaderFooterProtocol.h"
#import "LPDCollectionViewProtocol.h"

@interface LPDCollectionViewFactory : NSObject

- (__kindof id<LPDCollectionViewCellProtocol>)collectionViewModel:
                                                (__kindof id<LPDCollectionViewModelProtocol>)collectionViewModel
                                            cellForCollectionView:(UICollectionView *)collectionView
                                                      atIndexPath:(NSIndexPath *)indexPath;

- (__kindof id<LPDCollectionViewCellProtocol>)cellWithViewModel:
                                                (__kindof id<LPDCollectionCellViewModelProtocol>)viewModel
                                                 collectionView:(UICollectionView *)collectionView
                                                    atIndexPath:(NSIndexPath *)indexPath;

- (__kindof id<LPDCollectionViewHeaderFooterProtocol>)collectionViewModel:
                                                        (__kindof id<LPDCollectionViewModelProtocol>)collectionViewModel
                                                  headerForCollectionView:(UICollectionView *)collectionView
                                                              atIndexPath:(NSIndexPath *)indexPath;

- (__kindof id<LPDCollectionViewHeaderFooterProtocol>)
headerWithViewModel:(__kindof id<LPDCollectionHeaderFooterViewModelProtocol>)viewModel
     collectionView:(UICollectionView *)collectionView
        atIndexPath:(NSIndexPath *)indexPath;

- (__kindof id<LPDCollectionViewHeaderFooterProtocol>)collectionViewModel:
                                                        (__kindof id<LPDCollectionViewModelProtocol>)collectionViewModel
                                                  footerForCollectionView:(UICollectionView *)collectionView
                                                              atIndexPath:(NSIndexPath *)indexPath;

- (__kindof id<LPDCollectionViewHeaderFooterProtocol>)
footerWithViewModel:(__kindof id<LPDCollectionHeaderFooterViewModelProtocol>)viewModel
     collectionView:(UICollectionView *)collectionView
        atIndexPath:(NSIndexPath *)indexPath;

@end
