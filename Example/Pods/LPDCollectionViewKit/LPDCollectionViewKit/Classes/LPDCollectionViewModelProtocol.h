//
//  LPDCollectionViewModelProtocol.h
//  LPDMvvmKit
//
//  Created by foxsofter on 16/2/22.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "LPDCollectionItemViewModelProtocol.h"
#import "LPDCollectionSectionViewModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LPDCollectionViewModelProtocol

#pragma mark - read data methods

- (nullable NSIndexPath *)indexPathForCellViewModel:(__kindof id<LPDCollectionItemViewModelProtocol>)cellViewModel;

- (nullable __kindof id<LPDCollectionItemViewModelProtocol>)cellViewModelFromIndexPath:(NSIndexPath *)indexPath;

- (NSInteger)sectionIndexForHeaderViewModel:(__kindof id<LPDCollectionItemViewModelProtocol>)headerViewModel;

- (nullable __kindof id<LPDCollectionItemViewModelProtocol>)headerViewModelFromSection:(NSInteger)sectionIndex;

- (NSInteger)sectionIndexForFooterViewModel:(__kindof id<LPDCollectionItemViewModelProtocol>)footerViewModel;

- (nullable __kindof id<LPDCollectionItemViewModelProtocol>)footerViewModelFromSection:(NSInteger)sectionIndex;

#pragma mark - add cells methods

/**
 *  @brief 添加cellViewModel到最后一个section，如果不存在section默认添加一个section
 *
 *  @param cellViewModel 同一个cellViewModel不可添加多次
 */
- (void)addCellViewModel:(__kindof id<LPDCollectionItemViewModelProtocol>)cellViewModel;

/**
 *  @brief 添加cellViewModel
 *
 *  @param cellViewModel 同一个cellViewModel不可添加多次
 *  @param sectionIndex   sectionIndex
 */
- (void)addCellViewModel:(__kindof id<LPDCollectionItemViewModelProtocol>)cellViewModel
               toSection:(NSUInteger)sectionIndex;

/**
 *  @brief 添加cellViewModels到最后一个section，如果不存在section默认添加一个section
 *
 *  @param cellViewModels 同一个cellViewModel不可添加多次
 */
- (void)addCellViewModels:(NSArray<__kindof id<LPDCollectionItemViewModelProtocol>> *)cellViewModels;

/**
 *  @brief 添加cellViewModels到最后一个section，如果不存在section默认添加一个section
 *
 *  @param cellViewModels 同一个cellViewModel不可添加多次
 *  @param sectionIndex   sectionIndex
 */
- (void)addCellViewModels:(NSArray<__kindof id<LPDCollectionItemViewModelProtocol>> *)cellViewModels
                toSection:(NSUInteger)sectionIndex;

#pragma mark - insert cells methods

/**
 *  @brief 插入cellViewModel到最后一个section，如果不存在section默认添加一个section
 *
 *  @param cellViewModel 同一个cellViewModel不可添加多次
 *  @param index         index
 */
- (void)insertCellViewModel:(__kindof id<LPDCollectionItemViewModelProtocol>)cellViewModel atIndex:(NSUInteger)index;

/**
 *  @brief 插入cellViewModel
 *
 *  @param cellViewModel 同一个cellViewModel不可添加多次
 *  @param index         index
 *  @param sectionIndex  sectionIndex
 */
- (void)insertCellViewModel:(__kindof id<LPDCollectionItemViewModelProtocol>)cellViewModel
                    atIndex:(NSUInteger)index
                  inSection:(NSUInteger)sectionIndex;

/**
 *  @brief 插入cellViewModels到最后一个section，如果不存在section默认添加一个section
 *
 *  @param cellViewModels 同一个cellViewModel不可添加多次
 *  @param index          index
 */
- (void)insertCellViewModels:(NSArray<__kindof id<LPDCollectionItemViewModelProtocol>> *)cellViewModels
                     atIndex:(NSUInteger)index;

/**
 *  @brief 插入cellViewModels
 *
 *  @param cellViewModels 同一个cellViewModel不可添加多次
 *  @param index          index
 *  @param sectionIndex   sectionIndex
 */
- (void)insertCellViewModels:(NSArray<__kindof id<LPDCollectionItemViewModelProtocol>> *)cellViewModels
                     atIndex:(NSUInteger)index
                   inSection:(NSUInteger)sectionIndex;

#pragma mark - reload cells methods

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

#pragma mark - remove cells methods

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

#pragma mark - replace cells methods

/**
 *  @brief 替换最后一个section指定的index之后的cellViewModels
 *
 *  @param cellViewModels 同一个cellViewModel不可添加多次
 *  @param index          index
 */
- (void)replaceCellViewModels:(NSArray<__kindof id<LPDCollectionItemViewModelProtocol>> *)cellViewModels
                    fromIndex:(NSUInteger)index;

/**
 *  @brief 替换指定section指定的index之后的cellViewModels
 *
 *  @param cellViewModels 同一个cellViewModel不可添加多次
 *  @param index          index
 *  @param sectionIndex   sectionIndex
 */
- (void)replaceCellViewModels:(NSArray<__kindof id<LPDCollectionItemViewModelProtocol>> *)cellViewModels
                    fromIndex:(NSUInteger)index
                    inSection:(NSUInteger)sectionIndex;

#pragma mark - add section methods

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
         withCellViewModels:(NSArray<__kindof id<LPDCollectionItemViewModelProtocol>> *)cellViewModels;

#pragma mark - insert section methods

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
            withCellViewModels:(NSArray<__kindof id<LPDCollectionItemViewModelProtocol>> *)cellViewModels
                       atIndex:(NSUInteger)index;

#pragma mark - reload sections methods

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

#pragma mark - remove sections methods

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

#pragma mark - replace sections methods

/**
 *  @brief 重置最后的section，替换该section下所有的cellViewModel
 *
 *  @param cellViewModels 同一个cellViewModel不可添加多次
 */
- (void)replaceSectionWithCellViewModels:(NSArray<__kindof id<LPDCollectionItemViewModelProtocol>> *)cellViewModels;

/**
 *  @brief 重置指定的section，替换该section下所有的cellViewModel
 *
 *  @param cellViewModels 同一个cellViewModel不可添加多次
 *  @param sectionIndex   sectionIndex
 */
- (void)replaceSectionWithCellViewModels:(NSArray<__kindof id<LPDCollectionItemViewModelProtocol>> *)cellViewModels
                               atSection:(NSUInteger)sectionIndex;


#pragma mark - action signals

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
