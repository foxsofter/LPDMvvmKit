//
//  LPDCollectionViewFactory.h
//  LPDMvvmKit
//
//  Created by foxsofter on 16/2/22.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LPDCollectionViewItemProtocol.h"
#import "LPDCollectionItemViewModelProtocol.h"
#import "LPDCollectionViewProtocol.h"

@interface LPDCollectionViewFactory : NSObject

- (__kindof id<LPDCollectionViewItemProtocol>)collectionViewModel:
  (__kindof id<LPDCollectionViewModelProtocol>)collectionViewModel
                                            cellForCollectionView:(UICollectionView *)collectionView
                                                      atIndexPath:(NSIndexPath *)indexPath;

- (__kindof id<LPDCollectionViewItemProtocol>)cellWithViewModel:
  (__kindof id<LPDCollectionItemViewModelProtocol>)viewModel
                                                 collectionView:(UICollectionView *)collectionView
                                                    atIndexPath:(NSIndexPath *)indexPath;

- (__kindof id<LPDCollectionItemViewModelProtocol>)collectionViewModel:
  (__kindof id<LPDCollectionViewModelProtocol>)collectionViewModel
                                               headerForCollectionView:(UICollectionView *)collectionView
                                                           atIndexPath:(NSIndexPath *)indexPath;

- (__kindof id<LPDCollectionItemViewModelProtocol>)headerWithViewModel:
  (__kindof id<LPDCollectionItemViewModelProtocol>)viewModel
                                                        collectionView:(UICollectionView *)collectionView
                                                           atIndexPath:(NSIndexPath *)indexPath;

- (__kindof id<LPDCollectionItemViewModelProtocol>)collectionViewModel:
  (__kindof id<LPDCollectionViewModelProtocol>)collectionViewModel
                                               footerForCollectionView:(UICollectionView *)collectionView
                                                           atIndexPath:(NSIndexPath *)indexPath;

- (__kindof id<LPDCollectionItemViewModelProtocol>)footerWithViewModel:
  (__kindof id<LPDCollectionItemViewModelProtocol>)viewModel
                                                        collectionView:(UICollectionView *)collectionView
                                                           atIndexPath:(NSIndexPath *)indexPath;

@end
