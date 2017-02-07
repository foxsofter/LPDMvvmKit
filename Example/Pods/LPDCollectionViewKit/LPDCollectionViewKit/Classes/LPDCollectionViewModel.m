//
//  LPDCollectionViewModel.m
//  LPDMvvmKit
//
//  Created by foxsofter on 16/2/22.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "LPDCollectionSectionViewModel+Private.h"
#import "LPDCollectionSectionViewModel.h"
#import "LPDCollectionViewFactory.h"
#import "LPDCollectionViewHeader.h"
#import "LPDCollectionViewFooter.h"
#import "LPDCollectionViewModel.h"
#import "LPDCollectionViewModel+Private.h"

@interface LPDCollectionViewDelegate : NSObject <UICollectionViewDelegate>

+ (instancetype) new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithViewModel:(__kindof LPDCollectionViewModel *)viewModel;

@property (nullable, nonatomic, weak, readonly) __kindof LPDCollectionViewModel *viewModel;

@end

@interface LPDCollectionViewDataSource : NSObject <UICollectionViewDataSource>

+ (instancetype) new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithViewModel:(__kindof LPDCollectionViewModel *)viewModel;

@property (nullable, nonatomic, weak, readonly) __kindof LPDCollectionViewModel *viewModel;

@end

@interface LPDCollectionViewModel ()

@property (nonatomic, strong) NSMutableArray<__kindof id<LPDCollectionSectionViewModelProtocol>> *sections;

@property (nonatomic, strong) LPDCollectionViewFactory *collectionViewFactory;

@property (nonatomic, strong) RACSubject *reloadDataSubject;

@property (nonatomic, strong) RACSubject *insertSectionsSubject;
@property (nonatomic, strong) RACSubject *deleteSectionsSubject;
@property (nonatomic, strong) RACSubject *replaceSectionsSubject;
@property (nonatomic, strong) RACSubject *reloadSectionsSubject;

@property (nonatomic, strong) RACSubject *insertItemsAtIndexPathsSubject;
@property (nonatomic, strong) RACSubject *deleteItemsAtIndexPathsSubject;
@property (nonatomic, strong) RACSubject *replaceItemsAtIndexPathsSubject;
@property (nonatomic, strong) RACSubject *reloadItemsAtIndexPathsSubject;

@property (nonatomic, strong) RACSubject *didHighlightItemAtIndexPathSubject;
@property (nonatomic, strong) RACSubject *didUnhighlightItemAtIndexPathSubject;
@property (nonatomic, strong) RACSubject *didSelectItemAtIndexPathSubject;
@property (nonatomic, strong) RACSubject *didDeselectItemAtIndexPathSubject;
@property (nonatomic, strong) RACSubject *willDisplayCellSubject;
@property (nonatomic, strong) RACSubject *didEndDisplayingCellSubject;
@property (nonatomic, strong) RACSubject *willDisplayHeaderViewSubject;
@property (nonatomic, strong) RACSubject *didEndDisplayingHeaderViewSubject;
@property (nonatomic, strong) RACSubject *willDisplayFooterViewSubject;
@property (nonatomic, strong) RACSubject *didEndDisplayingFooterViewSubject;

@end

static NSString *const kDefaultHeaderReuseIdentifier = @"kDefaultHeaderReuseIdentifier";
static NSString *const kDefaultFooterReuseIdentifier = @"kDefaultFooterReuseIdentifier";

@implementation LPDCollectionViewModel  {
  id<UICollectionViewDelegate> _delegate;
  id<UICollectionViewDataSource> _dataSource;
}


- (instancetype)init {
  if (self = [super init]) {
    _delegate = [[LPDCollectionViewDelegate alloc] initWithViewModel:self];
    _dataSource = [[LPDCollectionViewDataSource alloc] initWithViewModel:self];
    self.collectionViewFactory = [[LPDCollectionViewFactory alloc] init];
  }
  return self;
}

#pragma mark - LPDCollectionViewModelProtocol

- (NSIndexPath *)indexPathForCellViewModel:(__kindof id<LPDCollectionItemViewModelProtocol>)cellViewModel {
  if (!cellViewModel) {
    return nil;
  }

  NSArray *sections = self.sections;
  for (NSUInteger sectionIndex = 0; sectionIndex < [sections count]; sectionIndex++) {
    NSArray *items = [[sections objectAtIndex:sectionIndex] items];
    for (NSUInteger itemIndex = 0; itemIndex < items.count; itemIndex++) {
      if ([cellViewModel isEqual:[items objectAtIndex:itemIndex]]) {
        return [NSIndexPath indexPathForRow:itemIndex inSection:sectionIndex];
      }
    }
  }

  return nil;
}

- (__kindof id<LPDCollectionItemViewModelProtocol>)cellViewModelFromIndexPath:(NSIndexPath *)indexPath {
  if (nil == indexPath) {
    return nil;
  }

  NSInteger sectionIndex = [indexPath section];
  NSInteger itemIndex = [indexPath item];

  if ((NSUInteger)sectionIndex < self.sections.count) {
    NSArray *items = [[self.sections objectAtIndex:sectionIndex] items];
    if ((NSUInteger)itemIndex < items.count) {
      return [items objectAtIndex:itemIndex];
    }
  }

  return nil;
}

- (NSInteger)sectionIndexForHeaderViewModel:(__kindof id<LPDCollectionItemViewModelProtocol>)headerViewModel {
  if (!headerViewModel) {
    return -1;
  }
  for (NSInteger i = 0; i < self.sections.count; i++) {
    id<LPDCollectionSectionViewModelProtocol> sectionViewModel = self.sections[i];
    if ([sectionViewModel respondsToSelector:@selector(headerViewModel)]) {
      if (sectionViewModel.headerViewModel == headerViewModel) {
        return i;
      }
    }
  }
  return -1;
}

- (__kindof id<LPDCollectionItemViewModelProtocol>)headerViewModelFromSection:(NSInteger)sectionIndex {
  if (sectionIndex < 0 || sectionIndex >= self.sections.count) {
    return nil;
  }
  id<LPDCollectionSectionViewModelProtocol> sectionViewModel = self.sections[sectionIndex];
  if ([sectionViewModel respondsToSelector:@selector(headerViewModel)]) {
    return sectionViewModel.headerViewModel;
  }
  return nil;
}

- (NSInteger)sectionIndexForFooterViewModel:(__kindof id<LPDCollectionItemViewModelProtocol>)footerViewModel {
  if (!footerViewModel) {
    return -1;
  }
  for (NSInteger i = 0; i < self.sections.count; i++) {
    id<LPDCollectionSectionViewModelProtocol> sectionViewModel = self.sections[i];
    if ([sectionViewModel respondsToSelector:@selector(footerViewModel)]) {
      if (sectionViewModel.footerViewModel == footerViewModel) {
        return i;
      }
    }
  }
  return -1;
}

- (__kindof id<LPDCollectionItemViewModelProtocol>)footerViewModelFromSection:(NSInteger)sectionIndex {
  if (sectionIndex < 0 || sectionIndex >= self.sections.count) {
    return nil;
  }
  id<LPDCollectionSectionViewModelProtocol> sectionViewModel = self.sections[sectionIndex];
  if ([sectionViewModel respondsToSelector:@selector(footerViewModel)]) {
    return sectionViewModel.footerViewModel;
  }
  return nil;
}

- (void)addCellViewModel:(__kindof id<LPDCollectionItemViewModelProtocol>)cellViewModel {
  NSUInteger sectionIndex = self.sections.count > 0 ? self.sections.count - 1 : 0;
  [self addCellViewModel:cellViewModel toSection:sectionIndex];
}

- (void)addCellViewModel:(__kindof id<LPDCollectionItemViewModelProtocol>)cellViewModel
               toSection:(NSUInteger)sectionIndex {
  NSUInteger index = 0;
  if (self.sections.count > 0) {
    LPDCollectionSectionViewModel *section = self.sections[sectionIndex];
    index = section.mutableItems.count;
  }
  [self insertCellViewModels:@[ cellViewModel ]
                    atIndex:index
                  inSection:sectionIndex];
}

- (void)addCellViewModels:(NSArray<__kindof id<LPDCollectionItemViewModelProtocol>> *)cellViewModels {
  NSUInteger sectionIndex = self.sections.count > 0 ? self.sections.count - 1 : 0;
  [self addCellViewModels:cellViewModels toSection:sectionIndex];
}

- (void)addCellViewModels:(NSArray<__kindof id<LPDCollectionItemViewModelProtocol>> *)cellViewModels
                toSection:(NSUInteger)sectionIndex {
  NSUInteger index = 0;
  if (self.sections.count > 0) {
    LPDCollectionSectionViewModel *section = self.sections[sectionIndex];
    index = section.mutableItems.count;
  }

  [self insertCellViewModels:cellViewModels
                     atIndex:index
                   inSection:sectionIndex];
}

- (void)insertCellViewModel:(__kindof id<LPDCollectionItemViewModelProtocol>)cellViewModel atIndex:(NSUInteger)index {
  NSUInteger sectionIndex = self.sections.count > 0 ? self.sections.count - 1 : 0;
  [self insertCellViewModels:@[ cellViewModel] atIndex:index inSection:sectionIndex];
}

- (void)insertCellViewModel:(__kindof id<LPDCollectionItemViewModelProtocol>)cellViewModel
                    atIndex:(NSUInteger)index
                  inSection:(NSUInteger)sectionIndex {
  [self insertCellViewModels:@[ cellViewModel ]
                     atIndex:index
                   inSection:sectionIndex];
}

- (void)insertCellViewModels:(NSArray<__kindof id<LPDCollectionItemViewModelProtocol>> *)cellViewModels
                     atIndex:(NSUInteger)index {
  NSUInteger sectionIndex = self.sections.count > 0 ? self.sections.count - 1 : 0;
  [self insertCellViewModels:cellViewModels atIndex:index inSection:sectionIndex];
}

- (void)insertCellViewModels:(NSArray<__kindof id<LPDCollectionItemViewModelProtocol>> *)cellViewModels
                     atIndex:(NSUInteger)index
                   inSection:(NSUInteger)sectionIndex {
  if (sectionIndex >= self.sections.count && self.sections.count > 1) {
    return;
  }
  
  BOOL needInsertSection = NO;
  LPDCollectionSectionViewModel *section = nil;
  if (self.sections.count < 1) {
    section = [LPDCollectionSectionViewModel section];
    section.mutableItems = [NSMutableArray array];
    [self.sections addObject:section];
    needInsertSection = YES;
  } else {
    section = self.sections[sectionIndex];
  }
  
  NSMutableSet *testRepeatSet = [[NSMutableSet alloc] initWithArray:cellViewModels];
  if (testRepeatSet.count != cellViewModels.count) {
    return;
  }

  for (LPDCollectionSectionViewModel *section in self.sections) {
    for (id<LPDCollectionItemViewModelProtocol> currentCellViewModel in section.mutableItems) {
      if ([cellViewModels containsObject:currentCellViewModel]) {
        return;
      }
    }
  }

  if (index <= section.mutableItems.count) {
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(index, cellViewModels.count)];
    [section.mutableItems insertObjects:cellViewModels atIndexes:indexSet];

    // send insertItemsAtIndexPathsSignal
    NSUInteger startIndex = index;
    NSMutableArray<NSIndexPath *> *indexPaths = [NSMutableArray arrayWithCapacity:cellViewModels.count];
    for (NSInteger i = startIndex; i < cellViewModels.count + startIndex; i++) {
      [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:sectionIndex]];
    }
    RACTuple *tuple = nil;
    if (needInsertSection) {
      tuple = RACTuplePack(indexPaths, [NSIndexSet indexSetWithIndex:sectionIndex]);
    } else {
      tuple = RACTuplePack(indexPaths);
    }
    [self.insertItemsAtIndexPathsSubject sendNext:tuple];
  }
}

- (void)reloadCellViewModelAtIndex:(NSUInteger)index inSection:(NSInteger)sectionIndex {
  [self reloadCellViewModelsAtRange:NSMakeRange(index, 1) inSection:sectionIndex];
}

- (void)reloadCellViewModelsAtRange:(NSRange)range inSection:(NSInteger)sectionIndex {
  if (sectionIndex < self.sections.count) {
    LPDCollectionSectionViewModel *section = self.sections[sectionIndex];
    if (range.location < section.mutableItems.count && range.location + range.length <= section.mutableItems.count) {
      NSMutableArray<NSIndexPath *> *indexPaths = [NSMutableArray arrayWithCapacity:range.length];
      for (NSInteger i = range.location; i < range.location + range.length - 1; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:sectionIndex]];
      }

      [self.reloadItemsAtIndexPathsSubject sendNext:indexPaths];
    }
  }
}

- (void)removeLastCellViewModel {
  if (self.sections.count > 0) {
    [self removeLastCellViewModelFromSection:self.sections.count - 1];
  }
}

- (void)removeLastCellViewModelFromSection:(NSUInteger)sectionIndex {
  if (sectionIndex < self.sections.count) {
    LPDCollectionSectionViewModel *section = self.sections[sectionIndex];
    if (section.mutableItems.count > 0) {
      NSUInteger index = section.mutableItems.count - 1;
      [section.mutableItems removeLastObject];

      // send deleteItemsAtIndexPathsSignal
      NSMutableArray<NSIndexPath *> *indexPaths = [NSMutableArray arrayWithCapacity:1];
      [indexPaths addObject:[NSIndexPath indexPathForRow:index inSection:sectionIndex]];
      [self.deleteItemsAtIndexPathsSubject sendNext:indexPaths];
    }
  }
}

- (void)removeCellViewModelAtIndex:(NSUInteger)index {
  if (self.sections.count > 0) {
    [self removeCellViewModelAtIndex:index fromSection:self.sections.count - 1];
  }
}

- (void)removeCellViewModelAtIndex:(NSUInteger)index fromSection:(NSUInteger)sectionIndex {
  if (sectionIndex < self.sections.count) {
    LPDCollectionSectionViewModel *section = self.sections[sectionIndex];
    if (index < section.mutableItems.count) {
      [section.mutableItems removeObjectAtIndex:index];

      // send deleteItemsAtIndexPathsSignal
      NSMutableArray<NSIndexPath *> *indexPaths = [NSMutableArray arrayWithCapacity:1];
      [indexPaths addObject:[NSIndexPath indexPathForRow:index inSection:sectionIndex]];
      [self.deleteItemsAtIndexPathsSubject sendNext:indexPaths];
    }
  }
}

- (void)replaceCellViewModels:(NSArray<__kindof id<LPDCollectionItemViewModelProtocol>> *)cellViewModels
                    fromIndex:(NSUInteger)index {
  NSUInteger sectionIndex = self.sections.count > 0 ? self.sections.count - 1 : 0;
  [self replaceCellViewModels:cellViewModels fromIndex:index inSection:sectionIndex];
}

- (void)replaceCellViewModels:(NSArray<__kindof id<LPDCollectionItemViewModelProtocol>> *)cellViewModels
                    fromIndex:(NSUInteger)index
                    inSection:(NSUInteger)sectionIndex {
  BOOL needInsertSection = NO;
  if (self.sections.count < 1) {
    LPDCollectionSectionViewModel *section = [LPDCollectionSectionViewModel section];
    section.mutableItems = [NSMutableArray array];
    [self.sections addObject:section];
    needInsertSection = YES;
  }
  if (sectionIndex >= self.sections.count) {
    return;
  }
  LPDCollectionSectionViewModel *section = self.sections[sectionIndex];
  if (index > section.mutableItems.count) {
    if (needInsertSection) {
      [self.sections removeLastObject];
    }
    return;
  }

  NSMutableSet *testRepeatSet = [[NSMutableSet alloc] initWithArray:cellViewModels];
  if (testRepeatSet.count != cellViewModels.count) {
    if (needInsertSection) {
      [self.sections removeLastObject];
    }
    return;
  }

  for (LPDCollectionSectionViewModel *section in self.sections) {
    for (id<LPDCollectionItemViewModelProtocol> currentCellViewModel in section.mutableItems) {
      if ([cellViewModels containsObject:currentCellViewModel]) {
        if (needInsertSection) {
          [self.sections removeLastObject];
        }
        return;
      }
    }
  }

  NSRange oldRange = NSMakeRange(index, MIN(section.mutableItems.count - index, cellViewModels.count));
  [section.mutableItems removeObjectsInRange:oldRange];
  NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(index, cellViewModels.count)];
  [section.mutableItems insertObjects:cellViewModels atIndexes:indexSet];
  NSMutableArray<NSIndexPath *> *oldIndexPaths = [NSMutableArray arrayWithCapacity:1];
  for (NSInteger i = oldRange.location; i < oldRange.location + oldRange.length; i++) {
    [oldIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:sectionIndex]];
  }
  NSMutableArray<NSIndexPath *> *newIndexPaths = [NSMutableArray arrayWithCapacity:1];
  for (NSInteger i = index; i < index + cellViewModels.count; i++) {
    [newIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:sectionIndex]];
  }

  // send replaceItemsAtIndexPathsSignal
  RACTuple *tuple = nil;
  if (needInsertSection) {
    tuple = RACTuplePack(oldIndexPaths, newIndexPaths, [NSIndexSet indexSetWithIndex:sectionIndex]);
  } else {
    tuple = RACTuplePack(oldIndexPaths, newIndexPaths);
  }
  [self.replaceItemsAtIndexPathsSubject sendNext:tuple];
}

- (void)addSectionViewModel:(id<LPDCollectionSectionViewModelProtocol>)sectionViewModel {
  [self addSectionViewModel:sectionViewModel withCellViewModels:@[]];
}

- (void)addSectionViewModel:(id<LPDCollectionSectionViewModelProtocol>)sectionViewModel
         withCellViewModels:(NSArray<__kindof id<LPDCollectionItemViewModelProtocol>> *)cellViewModels {
  [self insertSectionViewModel:sectionViewModel withCellViewModels:cellViewModels atIndex:self.sections.count];
}

- (void)insertSectionViewModel:(id<LPDCollectionSectionViewModelProtocol>)sectionViewModel atIndex:(NSUInteger)index {
  [self insertSectionViewModel:sectionViewModel withCellViewModels:@[] atIndex:index];
}

- (void)insertSectionViewModel:(id<LPDCollectionSectionViewModelProtocol>)sectionViewModel
            withCellViewModels:(NSArray<__kindof id<LPDCollectionItemViewModelProtocol>> *)cellViewModels
                       atIndex:(NSUInteger)index {
  if (index <= self.sections.count) {

    if ([self.sections containsObject:sectionViewModel]) {
      return;
    }

    NSMutableSet *testRepeatSet = [[NSMutableSet alloc] initWithArray:cellViewModels];
    if (testRepeatSet.count != cellViewModels.count) {
      return;
    }

    for (LPDCollectionSectionViewModel *section in self.sections) {
      for (id<LPDCollectionItemViewModelProtocol> currentCellViewModel in section.mutableItems) {
        if ([cellViewModels containsObject:currentCellViewModel]) {
          return;
        }
      }
    }

    LPDCollectionSectionViewModel *section = sectionViewModel;
    section.mutableItems = cellViewModels && cellViewModels.count > 0 ? [NSMutableArray arrayWithArray:cellViewModels]
                                                                      : [NSMutableArray array];
    [self.sections insertObject:section atIndex:index];

    // send insertSectionsSignal
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:index];
    [self.insertSectionsSubject sendNext:indexSet];
  }
}

- (void)removeSectionAtIndex:(NSUInteger)index {
  if (index < self.sections.count) {
    [self.sections removeObjectAtIndex:index];

    // send deleteSectionsSignal
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:index];
    [self.deleteSectionsSubject sendNext:indexSet];
  }
}

- (void)removeAllSections {
  if (self.sections.count > 0) {
    // send deleteSectionsSignal
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, self.sections.count)];
    [self.sections removeAllObjects];
    [self.deleteSectionsSubject sendNext:indexSet];
  }
}

- (void)reloadSectionAtIndex:(NSUInteger)index {
  [self reloadSectionsAtRange:NSMakeRange(index, 1)];
}

- (void)reloadSectionsAtRange:(NSRange)range {
  if (range.location >= self.sections.count) {
    return;
  }
  NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
  [self.reloadSectionsSubject sendNext:indexSet];
}

- (void)replaceSectionWithCellViewModels:(NSArray<__kindof id<LPDCollectionItemViewModelProtocol>> *)cellViewModels {
  NSUInteger sectionIndex = self.sections.count > 0 ? self.sections.count - 1 : 0;
  [self replaceSectionWithCellViewModels:cellViewModels atSection:sectionIndex];
}

- (void)replaceSectionWithCellViewModels:(NSArray<__kindof id<LPDCollectionItemViewModelProtocol>> *)cellViewModels
                               atSection:(NSUInteger)sectionIndex {
  BOOL needInsertSection = NO;
  if (self.sections.count < 1) {
    LPDCollectionSectionViewModel *section = [LPDCollectionSectionViewModel section];
    section.mutableItems = [NSMutableArray array];
    [self.sections addObject:section];
    needInsertSection = YES;
  }
  if (sectionIndex < self.sections.count) {

    NSMutableSet *testRepeatSet = [[NSMutableSet alloc] initWithArray:cellViewModels];
    if (testRepeatSet.count != cellViewModels.count) {
      if (needInsertSection) {
        [self.sections removeLastObject];
      }
      return;
    }

    for (LPDCollectionSectionViewModel *section in self.sections) {
      for (id<LPDCollectionItemViewModelProtocol> currentCellViewModel in section.mutableItems) {
        if ([cellViewModels containsObject:currentCellViewModel]) {
          if (needInsertSection) {
            [self.sections removeLastObject];
          }
          return;
        }
      }
    }

    LPDCollectionSectionViewModel *section = self.sections[sectionIndex];
    [section.mutableItems removeAllObjects];
    [section.mutableItems addObjectsFromArray:cellViewModels];

    // send reloadSectionsSignal
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:sectionIndex];
    if (needInsertSection) {
      [self.insertSectionsSubject sendNext:indexSet];
    } else {
      [self.replaceSectionsSubject sendNext:indexSet];
    }
  } else {
    if (needInsertSection) {
      [self.sections removeLastObject];
    }
  }
}

#pragma mark - properties

/**
 *  @brief 返回当前sections，确保有section且至少有一个
 */
- (NSMutableArray<__kindof id<LPDCollectionSectionViewModelProtocol>> *)sections {
  if (!_sections) {
    _sections = [NSMutableArray array];
  }
  return _sections;
}

- (RACSignal *)reloadDataSignal {
  return _reloadDataSubject ?: (_reloadDataSubject = [[RACSubject subject] setNameWithFormat:@"reloadDataSignal"]);
}

- (RACSignal *)insertSectionsSignal {
  return _insertSectionsSubject
           ?: (_insertSectionsSubject = [[RACSubject subject] setNameWithFormat:@"insertSectionsSignal"]);
}

- (RACSignal *)deleteSectionsSignal {
  return _deleteSectionsSubject
           ?: (_deleteSectionsSubject = [[RACSubject subject] setNameWithFormat:@"deleteSectionsSignal"]);
}

- (RACSignal *)replaceSectionsSignal {
  return _replaceSectionsSubject
           ?: (_replaceSectionsSubject = [[RACSubject subject] setNameWithFormat:@"replaceSectionsSignal"]);
}

- (RACSignal *)reloadSectionsSignal {
  return _reloadSectionsSubject
           ?: (_reloadSectionsSubject = [[RACSubject subject] setNameWithFormat:@"reloadSectionsSignal"]);
}

- (RACSignal *)insertItemsAtIndexPathsSignal {
  return _insertItemsAtIndexPathsSubject ?: (_insertItemsAtIndexPathsSubject = [[RACSubject subject]
                                               setNameWithFormat:@"insertItemsAtIndexPathsSignal"]);
}

- (RACSignal *)deleteItemsAtIndexPathsSignal {
  return _deleteItemsAtIndexPathsSubject ?: (_deleteItemsAtIndexPathsSubject = [[RACSubject subject]
                                               setNameWithFormat:@"deleteItemsAtIndexPathsSignal"]);
}

- (RACSignal *)replaceItemsAtIndexPathsSignal {
  return _replaceItemsAtIndexPathsSubject ?: (_replaceItemsAtIndexPathsSubject = [[RACSubject subject]
                                                setNameWithFormat:@"replaceRowsAtIndexPathsSignal"]);
}

- (RACSignal *)reloadItemsAtIndexPathsSignal {
  return _reloadItemsAtIndexPathsSubject ?: (_reloadItemsAtIndexPathsSubject = [[RACSubject subject]
                                               setNameWithFormat:@"reloadItemsAtIndexPathsSignal"]);
}

- (RACSignal *)willDisplayCellSignal {
  return _willDisplayCellSubject
           ?: (_willDisplayCellSubject = [[RACSubject subject] setNameWithFormat:@"willDisplayCellSignal"]);
}

- (RACSignal *)didEndDisplayingCellSignal {
  return _didEndDisplayingCellSubject
           ?: (_didEndDisplayingCellSubject = [[RACSubject subject] setNameWithFormat:@"didEndDisplayingCellSignal"]);
}

- (RACSignal *)willDisplayHeaderViewSignal {
  return _willDisplayHeaderViewSubject
           ?: (_willDisplayHeaderViewSubject = [[RACSubject subject] setNameWithFormat:@"willDisplayHeaderViewSignal"]);
}

- (RACSignal *)didEndDisplayingHeaderViewSignal {
  return _didEndDisplayingHeaderViewSubject ?: (_didEndDisplayingHeaderViewSubject = [[RACSubject subject]
                                                  setNameWithFormat:@"didEndDisplayingHeaderViewSignal"]);
}

- (RACSignal *)willDisplayFooterViewSignal {
  return _willDisplayFooterViewSubject
           ?: (_willDisplayFooterViewSubject = [[RACSubject subject] setNameWithFormat:@"willDisplayFooterViewSignal"]);
}

- (RACSignal *)didEndDisplayingFooterViewSignal {
  return _didEndDisplayingFooterViewSubject ?: (_didEndDisplayingFooterViewSubject = [[RACSubject subject]
                                                  setNameWithFormat:@"didEndDisplayingFooterViewSignal"]);
}

- (RACSignal *)didHighlightItemAtIndexPathSignal {
  return _didHighlightItemAtIndexPathSubject ?: (_didHighlightItemAtIndexPathSubject = [[RACSubject subject]
                                                   setNameWithFormat:@"didHighlightItemAtIndexPathSignal"]);
}

- (RACSignal *)didUnhighlightItemAtIndexPathSignal {
  return _didUnhighlightItemAtIndexPathSubject ?: (_didUnhighlightItemAtIndexPathSubject = [[RACSubject subject]
                                                     setNameWithFormat:@"didUnhighlightItemAtIndexPathSignal"]);
}

- (RACSignal *)didSelectItemAtIndexPathSignal {
  return _didSelectItemAtIndexPathSubject ?: (_didSelectItemAtIndexPathSubject = [[RACSubject subject]
                                                setNameWithFormat:@"didSelectItemAtIndexPathSignal"]);
}

- (RACSignal *)didDeselectItemAtIndexPathSignal {
  return _didDeselectItemAtIndexPathSubject ?: (_didDeselectItemAtIndexPathSubject = [[RACSubject subject]
                                                  setNameWithFormat:@"didDeselectItemAtIndexPathSignal"]);
}

@end

@interface LPDCollectionViewDelegate ()

@property (nullable, nonatomic, weak, readwrite) __kindof LPDCollectionViewModel *viewModel;

@end

@implementation LPDCollectionViewDelegate

- (instancetype)initWithViewModel:(__kindof LPDCollectionViewModel *)viewModel {
  if (self = [super init]) {
    self.viewModel = viewModel;
  }
  return self;
}

- (void)collectionView:(UICollectionView *)collectionView
       willDisplayCell:(UICollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath {
  if (self.viewModel.willDisplayCellSignal) {
    NSObject *cellViewModel = [self.viewModel cellViewModelFromIndexPath:indexPath];
    [self.viewModel.willDisplayCellSubject sendNext:RACTuplePack(collectionView, cell, cellViewModel, indexPath)];
  }
}

- (void)collectionView:(UICollectionView *)collectionView
  didEndDisplayingCell:(UICollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath {
  if (self.viewModel.didEndDisplayingCellSignal) {
    NSObject *cellViewModel = [self.viewModel cellViewModelFromIndexPath:indexPath];
    [self.viewModel.didEndDisplayingCellSubject sendNext:RACTuplePack(collectionView, cell, cellViewModel, indexPath)];
  }
}

- (void)collectionView:(UICollectionView *)collectionView
  willDisplaySupplementaryView:(UICollectionReusableView *)view
                forElementKind:(NSString *)elementKind
                   atIndexPath:(NSIndexPath *)indexPath {
  if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
    if (self.viewModel.willDisplayHeaderViewSignal) {
      NSObject *cellViewModel = [self.viewModel cellViewModelFromIndexPath:indexPath];
      [self.viewModel.willDisplayHeaderViewSubject
        sendNext:RACTuplePack(collectionView, view, cellViewModel, indexPath)];
    }
  } else if (self.viewModel.willDisplayFooterViewSignal) {
    NSObject *cellViewModel = [self.viewModel cellViewModelFromIndexPath:indexPath];
    [self.viewModel.willDisplayFooterViewSubject sendNext:RACTuplePack(collectionView, view, cellViewModel, indexPath)];
  }
}

- (void)collectionView:(UICollectionView *)collectionView
  didEndDisplayingSupplementaryView:(UICollectionReusableView *)view
                   forElementOfKind:(NSString *)elementKind
                        atIndexPath:(NSIndexPath *)indexPath {
  if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
    if (self.viewModel.didEndDisplayingHeaderViewSignal) {
      NSObject *cellViewModel = [self.viewModel cellViewModelFromIndexPath:indexPath];
      [self.viewModel.didEndDisplayingHeaderViewSubject
        sendNext:RACTuplePack(collectionView, view, cellViewModel, indexPath)];
    }
  } else if (self.viewModel.didEndDisplayingFooterViewSignal) {
    NSObject *cellViewModel = [self.viewModel cellViewModelFromIndexPath:indexPath];
    [self.viewModel.didEndDisplayingFooterViewSubject
      sendNext:RACTuplePack(collectionView, view, cellViewModel, indexPath)];
  }
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
  if (self.viewModel.didHighlightItemAtIndexPathSignal) {
    NSObject *cellViewModel = [self.viewModel cellViewModelFromIndexPath:indexPath];
    [self.viewModel.didHighlightItemAtIndexPathSubject sendNext:RACTuplePack(collectionView, cellViewModel, indexPath)];
  }
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
  if (self.viewModel.didUnhighlightItemAtIndexPathSignal) {
    NSObject *cellViewModel = [self.viewModel cellViewModelFromIndexPath:indexPath];
    [self.viewModel.didUnhighlightItemAtIndexPathSubject
      sendNext:RACTuplePack(collectionView, cellViewModel, indexPath)];
  }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  if (self.viewModel.didSelectItemAtIndexPathSignal) {
    NSObject *cellViewModel = [self.viewModel cellViewModelFromIndexPath:indexPath];
    [self.viewModel.didSelectItemAtIndexPathSubject sendNext:RACTuplePack(collectionView, cellViewModel, indexPath)];
  }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
  if (self.viewModel.didDeselectItemAtIndexPathSignal) {
    NSObject *cellViewModel = [self.viewModel cellViewModelFromIndexPath:indexPath];
    [self.viewModel.didDeselectItemAtIndexPathSubject sendNext:RACTuplePack(collectionView, cellViewModel, indexPath)];
  }
}

@end

@interface LPDCollectionViewDataSource ()

@property (nullable, nonatomic, weak, readwrite) __kindof LPDCollectionViewModel *viewModel;

@end

@implementation LPDCollectionViewDataSource

- (instancetype)initWithViewModel:(__kindof LPDCollectionViewModel *)viewModel {
  if (self = [super init]) {
    self.viewModel = viewModel;
  }
  return self;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return self.viewModel.sections.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//  NSParameterAssert((NSUInteger)section < self.viewModel.sections.count || 0 == self.viewModel.sections.count);
  NSLog(@"numberOfItemsInSection：%d", [[self.viewModel.sections objectAtIndex:section] mutableItems].count);
  if ((NSUInteger)section < self.viewModel.sections.count) {
    return [[self.viewModel.sections objectAtIndex:section] mutableItems].count;
  } else {
    return 0;
  }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  UICollectionViewCell *cell =
    (UICollectionViewCell *)[self.viewModel.collectionViewFactory collectionViewModel:self.viewModel
                                                                cellForCollectionView:collectionView
                                                                          atIndexPath:indexPath];
  return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
  id<LPDCollectionSectionViewModelProtocol> sectionViewModel = self.viewModel.sections[indexPath.section];
  if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
    if ([sectionViewModel respondsToSelector:@selector(headerViewModel)]) {
      id<LPDCollectionItemViewModelProtocol> headerViewModel = sectionViewModel.headerViewModel;
      return (UICollectionReusableView *)[self.viewModel.collectionViewFactory headerWithViewModel:headerViewModel
                                                                                    collectionView:collectionView
                                                                                       atIndexPath:indexPath];
    } else {
      [collectionView registerClass:[LPDCollectionViewHeader class]
         forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                withReuseIdentifier:kDefaultHeaderReuseIdentifier];
      LPDCollectionViewHeader *defaultHeader =
        [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                           withReuseIdentifier:kDefaultHeaderReuseIdentifier
                                                  forIndexPath:indexPath];
      if ([sectionViewModel respondsToSelector:@selector(headerTitle)]) {
        RAC(defaultHeader.textLabel, text) =
          [RACObserve(sectionViewModel, headerTitle) takeUntil:[defaultHeader rac_prepareForReuseSignal]];
      }
      return defaultHeader;
    }
  } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
    if ([sectionViewModel respondsToSelector:@selector(footerViewModel)]) {
      id<LPDCollectionItemViewModelProtocol> footerViewModel = sectionViewModel.footerViewModel;
      return (UICollectionReusableView *)[self.viewModel.collectionViewFactory footerWithViewModel:footerViewModel
                                                                                    collectionView:collectionView
                                                                                       atIndexPath:indexPath];
    } else {
      [collectionView registerClass:[LPDCollectionViewFooter class]
         forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                withReuseIdentifier:kDefaultFooterReuseIdentifier];
      LPDCollectionViewFooter *defaultFooter =
        [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                           withReuseIdentifier:kDefaultFooterReuseIdentifier
                                                  forIndexPath:indexPath];
      if (([sectionViewModel respondsToSelector:@selector(footerTitle)])) {
        RAC(defaultFooter.textLabel, text) =
          [RACObserve(sectionViewModel, footerTitle) takeUntil:[defaultFooter rac_prepareForReuseSignal]];
      }
      return defaultFooter;
    }
  }
  return nil;
}

@end
