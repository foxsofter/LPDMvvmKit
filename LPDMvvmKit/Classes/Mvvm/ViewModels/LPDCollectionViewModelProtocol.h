//
//  LPDCollectionViewModelProtocol.h
//  LPDMvvmKit
//
//  Created by foxsofter on 16/2/22.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LPDCollectionCellViewModelProtocol.h"
#import "LPDCollectionHeaderFooterViewModelProtocol.h"
#import "LPDCollectionSectionViewModelProtocol.h"
#import "LPDScrollViewModelProtocol.h"
#import "LPDViewModelReactProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LPDCollectionViewModelProtocol <LPDViewModelReactProtocol>

- (instancetype)initWithScrollViewModel:(__kindof id<LPDScrollViewModelProtocol>)scrollViewModel;

@property (nullable, nonatomic, weak, readonly) __kindof id<LPDScrollViewModelProtocol> scrollViewModel;

@property (nonatomic, strong, readonly) id<UICollectionViewDelegate> delegate;

@property (nonatomic, strong, readonly) id<UICollectionViewDataSource> dataSource;

#pragma mark - data operation

- (nullable NSIndexPath *)indexPathForCellViewModel:(__kindof id<LPDCollectionCellViewModelProtocol>)cellViewModel;

- (nullable __kindof id<LPDCollectionCellViewModelProtocol>)cellViewModelFromIndexPath:(NSIndexPath *)indexPath;

- (NSInteger)sectionIndexForHeaderViewModel:(__kindof id<LPDCollectionHeaderFooterViewModelProtocol>)headerViewModel;

- (nullable __kindof id<LPDCollectionHeaderFooterViewModelProtocol>)headerViewModelFromSection:(NSInteger)sectionIndex;

- (NSInteger)sectionIndexForFooterViewModel:(__kindof id<LPDCollectionHeaderFooterViewModelProtocol>)footerViewModel;

- (nullable __kindof id<LPDCollectionHeaderFooterViewModelProtocol>)footerViewModelFromSection:(NSInteger)sectionIndex;

/**
 *  @brief 添加cellViewModel到最后一个section，如果不存在section默认添加一个section
 *
 *  @param cellViewModel 同一个cellViewModel不可添加多次
 */
- (void)addCellViewModel:(__kindof id<LPDCollectionCellViewModelProtocol>)cellViewModel;

/**
 *  @brief 添加cellViewModel
 *
 *  @param cellViewModel 同一个cellViewModel不可添加多次
 *  @param sectionIndex   sectionIndex
 */
- (void)addCellViewModel:(__kindof id<LPDCollectionCellViewModelProtocol>)cellViewModel
               toSection:(NSUInteger)sectionIndex;

/**
 *  @brief 添加cellViewModels到最后一个section，如果不存在section默认添加一个section
 *
 *  @param cellViewModels 同一个cellViewModel不可添加多次
 */
- (void)addCellViewModels:(NSArray<__kindof id<LPDCollectionCellViewModelProtocol>> *)cellViewModels;

/**
 *  @brief 添加cellViewModels到最后一个section，如果不存在section默认添加一个section
 *
 *  @param cellViewModels 同一个cellViewModel不可添加多次
 *  @param sectionIndex   sectionIndex
 */
- (void)addCellViewModels:(NSArray<__kindof id<LPDCollectionCellViewModelProtocol>> *)cellViewModels
                toSection:(NSUInteger)sectionIndex;

/**
 *  @brief 插入cellViewModel到最后一个section，如果不存在section默认添加一个section
 *
 *  @param cellViewModel 同一个cellViewModel不可添加多次
 *  @param index         index
 */
- (void)insertCellViewModel:(__kindof id<LPDCollectionCellViewModelProtocol>)cellViewModel atIndex:(NSUInteger)index;

/**
 *  @brief 插入cellViewModel
 *
 *  @param cellViewModel 同一个cellViewModel不可添加多次
 *  @param index         index
 *  @param sectionIndex  sectionIndex
 */
- (void)insertCellViewModel:(__kindof id<LPDCollectionCellViewModelProtocol>)cellViewModel
                    atIndex:(NSUInteger)index
                  inSection:(NSUInteger)sectionIndex;

/**
 *  @brief 插入cellViewModels到最后一个section，如果不存在section默认添加一个section
 *
 *  @param cellViewModels 同一个cellViewModel不可添加多次
 *  @param index          index
 */
- (void)insertCellViewModels:(NSArray<__kindof id<LPDCollectionCellViewModelProtocol>> *)cellViewModels
                     atIndex:(NSUInteger)index;

/**
 *  @brief 插入cellViewModels
 *
 *  @param cellViewModels 同一个cellViewModel不可添加多次
 *  @param index          index
 *  @param sectionIndex   sectionIndex
 */
- (void)insertCellViewModels:(NSArray<__kindof id<LPDCollectionCellViewModelProtocol>> *)cellViewModels
                     atIndex:(NSUInteger)index
                   inSection:(NSUInteger)sectionIndex;

/**
 *  @brief 重载cellViewModel
 *
 *  @param index         index
 *  @param sectionIndex  sectionIndex
 */
- (void)reloadCellViewModelAtIndex:(NSUInteger)index inSection:(NSInteger)sectionIndex;

/**
 *  @brief 重载cellViewModels
 *
 *  @param range         range
 *  @param sectionIndex  sectionIndex
 *  @param animation     animation
 */
- (void)reloadCellViewModelsAtRange:(NSRange)range inSection:(NSInteger)sectionIndex;

/**
 *  @brief 移除最后一个section的最后一个cellViewModel
 */
- (void)removeLastCellViewModel;

/**
 *  @brief 移除最后一个section的最后一个cellViewModel
 */
- (void)removeLastCellViewModelFromSection:(NSUInteger)sectionIndex;

/**
 *  @brief 移除最后一个section的指定cellViewModel
 */
- (void)removeCellViewModelAtIndex:(NSUInteger)index;

/**
 *  @brief 移除指定section的指定cellViewModel
 */
- (void)removeCellViewModelAtIndex:(NSUInteger)index fromSection:(NSUInteger)sectionIndex;

/**
 *  @brief 替换最后一个section指定的index之后的cellViewModels
 *
 *  @param cellViewModels 同一个cellViewModel不可添加多次
 *  @param index          index
 */
- (void)replaceCellViewModels:(NSArray<__kindof id<LPDCollectionCellViewModelProtocol>> *)cellViewModels
                    fromIndex:(NSUInteger)index;

/**
 *  @brief 替换指定section指定的index之后的cellViewModels
 *
 *  @param cellViewModels 同一个cellViewModel不可添加多次
 *  @param index          index
 *  @param sectionIndex   sectionIndex
 */
- (void)replaceCellViewModels:(NSArray<__kindof id<LPDCollectionCellViewModelProtocol>> *)cellViewModels
                    fromIndex:(NSUInteger)index
                    inSection:(NSUInteger)sectionIndex;

/**
 *  @brief 添加sectionViewModel
 *
 *  @param sectionViewModel 同一个sectionViewModel不可添加多次
 */
- (void)addSectionViewModel:(id<LPDCollectionSectionViewModelProtocol>)sectionViewModel;

/**
 *  @brief 添加sectionViewModel
 *
 *  @param sectionViewModel 同一个sectionViewModel不可添加多次
 *  @param cellViewModels   同一个cellViewModel不可添加多次
 */
- (void)addSectionViewModel:(id<LPDCollectionSectionViewModelProtocol>)sectionViewModel
         withCellViewModels:(NSArray<__kindof id<LPDCollectionCellViewModelProtocol>> *)cellViewModels;

/**
 *  @brief 插入sectionViewModel
 *
 *  @param sectionViewModel 同一个sectionViewModel不可添加多次
 *  @param index            index
 */
- (void)insertSectionViewModel:(id<LPDCollectionSectionViewModelProtocol>)sectionViewModel atIndex:(NSUInteger)index;

/**
 *  @brief 插入sectionViewModel
 *
 *  @param sectionViewModel 同一个sectionViewModel不可添加多次
 *  @param cellViewModels   同一个cellViewModel不可添加多次
 *  @param index            index
 */
- (void)insertSectionViewModel:(id<LPDCollectionSectionViewModelProtocol>)sectionViewModel
            withCellViewModels:(NSArray<__kindof id<LPDCollectionCellViewModelProtocol>> *)cellViewModels
                       atIndex:(NSUInteger)index;

/**
 *  @brief 重载section
 *
 *  @param index        index
 */
- (void)reloadSectionAtIndex:(NSUInteger)index;

/**
 *  @brief 重载cellViewModels
 *
 *  @param range         range
 *  @param sectionIndex  sectionIndex
 *  @param animation     animation
 */
- (void)reloadSectionsAtRange:(NSRange)range;

/**
 *  @brief 移除指定的section
 *
 *  @param index     index
 */
- (void)removeSectionAtIndex:(NSUInteger)index;
/**
 *  @brief 移除所有的的section
 */
- (void)removeAllSections;

/**
 *  @brief 重置最后的section，替换该section下所有的cellViewModel
 *
 *  @param cellViewModels 同一个cellViewModel不可添加多次
 */
- (void)replaceSectionWithCellViewModels:(NSArray<__kindof id<LPDCollectionCellViewModelProtocol>> *)cellViewModels;

/**
 *  @brief 重置指定的section，替换该section下所有的cellViewModel
 *
 *  @param cellViewModels 同一个cellViewModel不可添加多次
 *  @param sectionIndex   sectionIndex
 */
- (void)replaceSectionWithCellViewModels:(NSArray<__kindof id<LPDCollectionCellViewModelProtocol>> *)cellViewModels
                               atSection:(NSUInteger)sectionIndex;

#pragma mark - data signal

//- (void)insertSections:(NSIndexSet *)sections;
//- (void)deleteSections:(NSIndexSet *)sections;
//- (void)reloadSections:(NSIndexSet *)sections;
//
//- (void)insertItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;
//- (void)deleteItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;
//- (void)reloadItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

@property (nonatomic, strong, readonly) RACSignal *reloadDataSignal;      // 请勿订阅此信号
@property (nonatomic, strong, readonly) RACSignal *insertSectionsSignal;  // 请勿订阅此信号
@property (nonatomic, strong, readonly) RACSignal *deleteSectionsSignal;  // 请勿订阅此信号
@property (nonatomic, strong, readonly) RACSignal *replaceSectionsSignal; // 请勿订阅此信号
@property (nonatomic, strong, readonly) RACSignal *reloadSectionsSignal;  // 请勿订阅此信号

@property (nonatomic, strong, readonly) RACSignal *insertItemsAtIndexPathsSignal;  // 请勿订阅此信号
@property (nonatomic, strong, readonly) RACSignal *deleteItemsAtIndexPathsSignal;  // 请勿订阅此信号
@property (nonatomic, strong, readonly) RACSignal *replaceItemsAtIndexPathsSignal; // 请勿订阅此信号
@property (nonatomic, strong, readonly) RACSignal *reloadItemsAtIndexPathsSignal;  // 请勿订阅此信号

#pragma mark - action signal

//- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath;
//- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath;
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
//- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath;
//
//- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell
// forItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0);
//- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView
//*)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0);
//- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell
// forItemAtIndexPath:(NSIndexPath *)indexPath;
//- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView
//*)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic, strong, readonly) RACSignal *didHighlightItemAtIndexPathSignal;
@property (nonatomic, strong, readonly) RACSignal *didUnhighlightItemAtIndexPathSignal;
@property (nonatomic, strong, readonly) RACSignal *didSelectItemAtIndexPathSignal;
@property (nonatomic, strong, readonly) RACSignal *didDeselectItemAtIndexPathSignal;
@property (nonatomic, strong, readonly) RACSignal *willDisplayCellSignal;
@property (nonatomic, strong, readonly) RACSignal *didEndDisplayingCellSignal;
@property (nonatomic, strong, readonly) RACSignal *willDisplayHeaderViewSignal;
@property (nonatomic, strong, readonly) RACSignal *didEndDisplayingHeaderViewSignal;
@property (nonatomic, strong, readonly) RACSignal *willDisplayFooterViewSignal;
@property (nonatomic, strong, readonly) RACSignal *didEndDisplayingFooterViewSignal;

@end

NS_ASSUME_NONNULL_END