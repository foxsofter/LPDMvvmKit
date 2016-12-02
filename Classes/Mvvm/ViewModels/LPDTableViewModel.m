//
//  LPDTableViewModel.m
//  LPDMvvmKit
//
//  Created by foxsofter on 16/1/3.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "LPDTableSectionViewModel+Private.h"
#import "LPDTableSectionViewModelProtocol.h"
#import "LPDTableViewFactory.h"
#import "LPDTableViewHeaderFooter.h"
#import "LPDTableViewModel.h"
#import "RACSignal+LPDAddition.h"
#import <ReactiveCocoa/ReactiveCocoa.h>


@class LPDTableViewModel;

@interface LPDTableViewDelegate : NSObject <UITableViewDelegate>

+ (instancetype) new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithViewModel:(__kindof LPDTableViewModel *)viewModel;

@property (nullable, nonatomic, weak, readonly) __kindof LPDTableViewModel *viewModel;

@end

@interface LPDTableViewDataSource : NSObject <UITableViewDataSource>

+ (instancetype) new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithViewModel:(__kindof LPDTableViewModel *)viewModel;

@property (nullable, nonatomic, weak, readonly) __kindof LPDTableViewModel *viewModel;

@end

@interface LPDTableViewModel ()

@property (nullable, nonatomic, weak, readwrite) __kindof id<LPDScrollViewModelProtocol> scrollViewModel;

@property (nonatomic, strong, readwrite) id<UITableViewDelegate> delegate;
@property (nonatomic, strong, readwrite) id<UITableViewDataSource> dataSource;

//@property (nonatomic, strong) NSMutableArray<__kindof id<LPDTableSectionViewModelProtocol>> *sections;

@property (nonatomic, strong) LPDTableViewFactory *tableViewFactory;

@property (nonatomic, strong) RACSubject *reloadDataSubject;

@property (nonatomic, strong) RACSubject *insertSectionsSubject;
@property (nonatomic, strong) RACSubject *deleteSectionsSubject;
@property (nonatomic, strong) RACSubject *replaceSectionsSubject;
@property (nonatomic, strong) RACSubject *reloadSectionsSubject;

@property (nonatomic, strong) RACSubject *insertRowsAtIndexPathsSubject;
@property (nonatomic, strong) RACSubject *deleteRowsAtIndexPathsSubject;
@property (nonatomic, strong) RACSubject *replaceRowsAtIndexPathsSubject;
@property (nonatomic, strong) RACSubject *reloadRowsAtIndexPathsSubject;

@property (nonatomic, strong) RACSubject *willDisplayCellSubject;
@property (nonatomic, strong) RACSubject *willDisplayHeaderViewSubject;
@property (nonatomic, strong) RACSubject *willDisplayFooterViewSubject;
@property (nonatomic, strong) RACSubject *didEndDisplayingCellSubject;
@property (nonatomic, strong) RACSubject *didEndDisplayingHeaderViewSubject;
@property (nonatomic, strong) RACSubject *didEndDisplayingFooterViewSubject;
@property (nonatomic, strong) RACSubject *didHighlightRowAtIndexPathSubject;
@property (nonatomic, strong) RACSubject *didUnhighlightRowAtIndexPathSubject;
@property (nonatomic, strong) RACSubject *didSelectRowAtIndexPathSubject;
@property (nonatomic, strong) RACSubject *didDeselectRowAtIndexPathSubject;
@property (nonatomic, strong) RACSubject *willBeginEditingRowAtIndexPathSubject;
@property (nonatomic, strong) RACSubject *didEndEditingRowAtIndexPathSubject;

@end

#define EnsureOneSectionExists                                                                                         \
  if (self.sections.count < 1) {                                                                                       \
    LPDTableSectionViewModel *section = [LPDTableSectionViewModel section];                                            \
    section.mutableRows = [NSMutableArray array];                                                                      \
    [self.sections addObject:section];                                                                                 \
    [self.reloadDataSubject sendNext:nil];                                                                             \
  }

static NSString *const kDefaultHeaderReuseIdentifier = @"kDefaultHeaderReuseIdentifier";
static NSString *const kDefaultFooterReuseIdentifier = @"kDefaultFooterReuseIdentifier";

@implementation LPDTableViewModel

- (instancetype)initWithScrollViewModel:(__kindof id<LPDScrollViewModelProtocol>)scrollViewModel {
  if (self = [super init]) {
    self.scrollViewModel = scrollViewModel;
    self.delegate = [[LPDTableViewDelegate alloc] initWithViewModel:self];
    self.dataSource = [[LPDTableViewDataSource alloc] initWithViewModel:self];
    self.tableViewFactory = [[LPDTableViewFactory alloc] init];
  }
  return self;
}

#pragma mark - LPDViewModelReactProtocl

- (LPDViewReactState)reactState {
  return self.scrollViewModel.reactState;
}

- (void)setReactState:(LPDViewReactState)reactState {
  [self.scrollViewModel setReactState:reactState];
}

- (BOOL)isSubmitting {
  return self.scrollViewModel.isSubmitting;
}

- (void)setSubmitting:(BOOL)submitting {
  self.scrollViewModel.submitting = submitting;
}

- (void)setSubmittingWithMessage:(NSString *)message {
  [self.scrollViewModel setSubmittingWithMessage:message];
}

- (RACSubject *)successSubject {
  return self.scrollViewModel.successSubject;
}

- (RACSubject *)errorSubject {
  return self.scrollViewModel.errorSubject;
}

#pragma mark - LPDTableViewModelProtocol

- (NSIndexPath *)indexPathForCellViewModel:(__kindof id<LPDTableCellViewModelProtocol>)cellViewModel {
  if (!cellViewModel) {
    return nil;
  }

  NSArray *sections = self.sections;
  for (NSUInteger sectionIndex = 0; sectionIndex < [sections count]; sectionIndex++) {
    NSArray *rows = [[sections objectAtIndex:sectionIndex] rows];
    for (NSUInteger rowIndex = 0; rowIndex < rows.count; rowIndex++) {
      if ([cellViewModel isEqual:[rows objectAtIndex:rowIndex]]) {
        return [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
      }
    }
  }

  return nil;
}

- (__kindof id<LPDTableCellViewModelProtocol>)cellViewModelFromIndexPath:(NSIndexPath *)indexPath {
  if (nil == indexPath) {
    return nil;
  }

  NSInteger section = [indexPath section];
  NSInteger row = [indexPath row];

  if ((NSUInteger)section < self.sections.count) {
    NSArray *rows = [[self.sections objectAtIndex:section] rows];
    if ((NSUInteger)row < rows.count) {
      return [rows objectAtIndex:row];
    }
  }

  return nil;
}

- (NSInteger)sectionIndexForHeaderViewModel:(__kindof id<LPDTableHeaderFooterViewModelProtocol>)headerViewModel {
  if (!headerViewModel) {
    return -1;
  }
  for (NSInteger i = 0; i < self.sections.count; i++) {
    id<LPDTableSectionViewModelProtocol> sectionViewModel = self.sections[i];
    if ([sectionViewModel respondsToSelector:@selector(headerViewModel)]) {
      if (sectionViewModel.headerViewModel == headerViewModel) {
        return i;
      }
    }
  }
  return -1;
}

- (__kindof id<LPDTableHeaderFooterViewModelProtocol>)headerViewModelFromSection:(NSInteger)sectionIndex {
  if (sectionIndex < 0 || sectionIndex >= self.sections.count) {
    return nil;
  }
  id<LPDTableSectionViewModelProtocol> sectionViewModel = self.sections[sectionIndex];
  if ([sectionViewModel respondsToSelector:@selector(headerViewModel)]) {
    return sectionViewModel.headerViewModel;
  }
  return nil;
}

- (NSInteger)sectionIndexForFooterViewModel:(__kindof id<LPDTableHeaderFooterViewModelProtocol>)footerViewModel {
  if (!footerViewModel) {
    return -1;
  }
  for (NSInteger i = 0; i < self.sections.count; i++) {
    id<LPDTableSectionViewModelProtocol> sectionViewModel = self.sections[i];
    if ([sectionViewModel respondsToSelector:@selector(footerViewModel)]) {
      if (sectionViewModel.footerViewModel == footerViewModel) {
        return i;
      }
    }
  }
  return -1;
}

- (__kindof id<LPDTableHeaderFooterViewModelProtocol>)footerViewModelFromSection:(NSInteger)sectionIndex {
  if (sectionIndex < 0 || sectionIndex >= self.sections.count) {
    return nil;
  }
  id<LPDTableSectionViewModelProtocol> sectionViewModel = self.sections[sectionIndex];
  if ([sectionViewModel respondsToSelector:@selector(footerViewModel)]) {
    return sectionViewModel.footerViewModel;
  }
  return nil;
}

- (void)addCellViewModel:(__kindof id<LPDTableCellViewModelProtocol>)cellViewModel {
  EnsureOneSectionExists;

  [self addCellViewModel:cellViewModel toSection:self.sections.count - 1 withRowAnimation:UITableViewRowAnimationNone];
}

- (void)addCellViewModel:(__kindof id<LPDTableCellViewModelProtocol>)cellViewModel
        withRowAnimation:(UITableViewRowAnimation)animation {
  EnsureOneSectionExists;

  [self addCellViewModel:cellViewModel toSection:self.sections.count - 1 withRowAnimation:animation];
}

- (void)addCellViewModel:(__kindof id<LPDTableCellViewModelProtocol>)cellViewModel toSection:(NSUInteger)sectionIndex {
  EnsureOneSectionExists;

  [self addCellViewModel:cellViewModel toSection:sectionIndex withRowAnimation:UITableViewRowAnimationNone];
}

- (void)addCellViewModel:(__kindof id<LPDTableCellViewModelProtocol>)cellViewModel
               toSection:(NSUInteger)sectionIndex
        withRowAnimation:(UITableViewRowAnimation)animation {
  EnsureOneSectionExists;

  LPDTableSectionViewModel *section = self.sections[sectionIndex];
  [self insertCellViewModel:cellViewModel
                    atIndex:section.mutableRows.count
                  inSection:sectionIndex
           withRowAnimation:animation];
}

//以动画的形式添加cell
- (void)addCellViewModel:(__kindof id<LPDTableCellViewModelProtocol>)cellViewModel
           withAnimation:(UITableViewRowAnimation)animation {
  EnsureOneSectionExists;

  [self addCellViewModel:cellViewModel toSection:self.sections.count - 1 withAnimation:animation];
}

- (void)addCellViewModel:(__kindof id<LPDTableCellViewModelProtocol>)cellViewModel
               toSection:(NSUInteger)sectionIndex
           withAnimation:(UITableViewRowAnimation)animation {
  EnsureOneSectionExists;

  if (sectionIndex < self.sections.count) {

    LPDTableSectionViewModel *section = self.sections[sectionIndex];
    [section.mutableRows addObject:cellViewModel];

    // send insertRowsAtIndexPathsSignal
    NSMutableArray<NSIndexPath *> *indexPaths = [NSMutableArray arrayWithCapacity:1];
    [indexPaths addObject:[NSIndexPath indexPathForRow:section.mutableRows.count - 1 inSection:sectionIndex]];

    [self.insertRowsAtIndexPathsSubject sendNext:RACTuplePack(indexPaths, @(animation))];
  }
}

- (void)addCellViewModels:(NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)cellViewModels {
  EnsureOneSectionExists;

  [self addCellViewModels:cellViewModels
                toSection:self.sections.count - 1
         withRowAnimation:UITableViewRowAnimationNone];
}

- (void)addCellViewModels:(NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)cellViewModels
         withRowAnimation:(UITableViewRowAnimation)animation {
  EnsureOneSectionExists;

  [self addCellViewModels:cellViewModels toSection:self.sections.count - 1 withRowAnimation:animation];
}

- (void)addCellViewModels:(NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)cellViewModels
                toSection:(NSUInteger)sectionIndex {
  EnsureOneSectionExists;

  [self addCellViewModels:cellViewModels toSection:sectionIndex withRowAnimation:UITableViewRowAnimationNone];
}

- (void)addCellViewModels:(NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)cellViewModels
                toSection:(NSUInteger)sectionIndex
         withRowAnimation:(UITableViewRowAnimation)animation {
  EnsureOneSectionExists;

  LPDTableSectionViewModel *section = self.sections[sectionIndex];
  [self insertCellViewModels:cellViewModels
                     atIndex:section.mutableRows.count
                   inSection:sectionIndex
            withRowAnimation:animation];
}

- (void)insertCellViewModel:(__kindof id<LPDTableCellViewModelProtocol>)cellViewModel atIndex:(NSUInteger)index {
  EnsureOneSectionExists;

  [self insertCellViewModel:cellViewModel
                    atIndex:index
                  inSection:self.sections.count - 1
           withRowAnimation:UITableViewRowAnimationNone];
}

- (void)insertCellViewModel:(__kindof id<LPDTableCellViewModelProtocol>)cellViewModel
                    atIndex:(NSUInteger)index
           withRowAnimation:(UITableViewRowAnimation)animation {
  EnsureOneSectionExists;

  [self insertCellViewModel:cellViewModel atIndex:index inSection:self.sections.count - 1 withRowAnimation:animation];
}

- (void)insertCellViewModel:(__kindof id<LPDTableCellViewModelProtocol>)cellViewModel
                    atIndex:(NSUInteger)index
                  inSection:(NSUInteger)sectionIndex {
  EnsureOneSectionExists;

  [self insertCellViewModel:cellViewModel
                    atIndex:index
                  inSection:sectionIndex
           withRowAnimation:UITableViewRowAnimationNone];
}

- (void)insertCellViewModel:(__kindof id<LPDTableCellViewModelProtocol>)cellViewModel
                    atIndex:(NSUInteger)index
                  inSection:(NSUInteger)sectionIndex
           withRowAnimation:(UITableViewRowAnimation)animation {
  EnsureOneSectionExists;

  if (sectionIndex < self.sections.count) {
    for (LPDTableSectionViewModel *section in self.sections) {
      for (id<LPDTableCellViewModelProtocol> currentCellViewModel in section.mutableRows) {
        if (currentCellViewModel == cellViewModel) {
          return;
        }
      }
    }

    LPDTableSectionViewModel *section = self.sections[sectionIndex];
    if (index <= section.mutableRows.count) {
      [section.mutableRows insertObject:cellViewModel atIndex:index];

      // send insertRowsAtIndexPathsSignal
      NSMutableArray<NSIndexPath *> *indexPaths = [NSMutableArray arrayWithCapacity:1];
      [indexPaths addObject:[NSIndexPath indexPathForRow:index inSection:sectionIndex]];
      [self.insertRowsAtIndexPathsSubject sendNext:RACTuplePack(indexPaths, @(animation))];
    }
  }
}

- (void)insertCellViewModels:(NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)cellViewModels
                     atIndex:(NSUInteger)index {
  EnsureOneSectionExists;

  [self insertCellViewModels:cellViewModels
                     atIndex:index
                   inSection:self.sections.count - 1
            withRowAnimation:UITableViewRowAnimationNone];
}

- (void)insertCellViewModels:(NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)cellViewModels
                     atIndex:(NSUInteger)index
            withRowAnimation:(UITableViewRowAnimation)animation {
  EnsureOneSectionExists;

  [self insertCellViewModels:cellViewModels atIndex:index inSection:self.sections.count - 1 withRowAnimation:animation];
}

- (void)insertCellViewModels:(NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)cellViewModels
                     atIndex:(NSUInteger)index
                   inSection:(NSUInteger)sectionIndex {
  EnsureOneSectionExists;

  [self insertCellViewModels:cellViewModels
                     atIndex:index
                   inSection:sectionIndex
            withRowAnimation:UITableViewRowAnimationNone];
}

- (void)insertCellViewModels:(NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)cellViewModels
                     atIndex:(NSUInteger)index
                   inSection:(NSUInteger)sectionIndex
            withRowAnimation:(UITableViewRowAnimation)animation {
  EnsureOneSectionExists;

  if (sectionIndex < self.sections.count) {

    NSMutableSet *testRepeatSet = [[NSMutableSet alloc] initWithArray:cellViewModels];
    if (testRepeatSet.count != cellViewModels.count) {
      return;
    }

    for (LPDTableSectionViewModel *section in self.sections) {
      for (id<LPDTableCellViewModelProtocol> currentCellViewModel in section.mutableRows) {
        if ([cellViewModels containsObject:currentCellViewModel]) {
          return;
        }
      }
    }

    LPDTableSectionViewModel *section = self.sections[sectionIndex];
    if (index <= section.mutableRows.count) {
      NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(index, cellViewModels.count)];
      [section.mutableRows insertObjects:cellViewModels atIndexes:indexSet];

      // send insertRowsAtIndexPathsSignal
      NSUInteger startIndex = index;
      NSMutableArray<NSIndexPath *> *indexPaths = [NSMutableArray arrayWithCapacity:cellViewModels.count];
      for (NSInteger i = startIndex; i < cellViewModels.count; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:sectionIndex]];
      }
      [self.insertRowsAtIndexPathsSubject sendNext:RACTuplePack(indexPaths, @(animation))];
    }
  }
}
// add cells with animation
- (void)insertCellViewModels:(NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)cellViewModels
                     atIndex:(NSUInteger)index
               withAnimation:(UITableViewRowAnimation)animation {
  EnsureOneSectionExists;

  [self insertCellViewModels:cellViewModels atIndex:index inSection:self.sections.count - 1 withAnimation:animation];
}

- (void)insertCellViewModels:(NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)cellViewModels
                     atIndex:(NSUInteger)index
                   inSection:(NSUInteger)sectionIndex
               withAnimation:(UITableViewRowAnimation)animation {
  EnsureOneSectionExists;

  if (sectionIndex < self.sections.count) {
    LPDTableSectionViewModel *section = self.sections[sectionIndex];
    if (index <= section.mutableRows.count) {
      NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(index, cellViewModels.count)];
      [section.mutableRows insertObjects:cellViewModels atIndexes:indexSet];

      // send insertRowsAtIndexPathsSignal
      NSUInteger startIndex = index;
      NSMutableArray<NSIndexPath *> *indexPaths = [NSMutableArray arrayWithCapacity:cellViewModels.count];
      for (NSInteger i = startIndex; i < cellViewModels.count; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:sectionIndex]];
      }
      [self.insertRowsAtIndexPathsSubject sendNext:RACTuplePack(indexPaths, @(animation))];
    }
  }
}

- (void)reloadCellViewModelAtIndex:(NSUInteger)index inSection:(NSInteger)sectionIndex {
  [self reloadCellViewModelsAtRange:NSMakeRange(index, 1)
                          inSection:sectionIndex
                   withRowAnimation:UITableViewRowAnimationNone];
}

- (void)reloadCellViewModelAtIndex:(NSUInteger)index
                         inSection:(NSInteger)sectionIndex
                  withRowAnimation:(UITableViewRowAnimation)animation {
  [self reloadCellViewModelsAtRange:NSMakeRange(index, 1) inSection:sectionIndex withRowAnimation:animation];
}

- (void)reloadCellViewModelsAtRange:(NSRange)range inSection:(NSInteger)sectionIndex {
  [self reloadCellViewModelsAtRange:range inSection:sectionIndex withRowAnimation:UITableViewRowAnimationNone];
}

- (void)reloadCellViewModelsAtRange:(NSRange)range
                          inSection:(NSInteger)sectionIndex
                   withRowAnimation:(UITableViewRowAnimation)animation {
  if (sectionIndex < self.sections.count) {
    LPDTableSectionViewModel *section = self.sections[sectionIndex];
    if (range.location < section.mutableRows.count && range.location + range.length <= section.mutableRows.count) {
      NSMutableArray<NSIndexPath *> *indexPaths = [NSMutableArray arrayWithCapacity:range.length];
      for (NSInteger i = range.location; i < range.location + range.length - 1; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:sectionIndex]];
      }

      [self.reloadRowsAtIndexPathsSubject sendNext:RACTuplePack(indexPaths, @(animation))];
    }
  }
}

- (void)removeLastCellViewModel {
  if (self.sections.count > 0) {
    [self removeLastCellViewModelFromSection:self.sections.count - 1 withRowAnimation:UITableViewRowAnimationNone];
  }
}

- (void)removeLastCellViewModelWithRowAnimation:(UITableViewRowAnimation)animation {
  if (self.sections.count > 0) {
    [self removeLastCellViewModelFromSection:self.sections.count - 1 withRowAnimation:animation];
  }
}

- (void)removeLastCellViewModelFromSection:(NSUInteger)sectionIndex {
  if (self.sections.count > 0) {
    [self removeLastCellViewModelFromSection:sectionIndex withRowAnimation:UITableViewRowAnimationNone];
  }
}

- (void)removeLastCellViewModelFromSection:(NSUInteger)sectionIndex
                          withRowAnimation:(UITableViewRowAnimation)animation {
  if (sectionIndex < self.sections.count) {
    LPDTableSectionViewModel *section = self.sections[sectionIndex];
    if (section.mutableRows.count > 0) {
      [section.mutableRows removeLastObject];

      // send deleteRowsAtIndexPathsSignal
      NSMutableArray<NSIndexPath *> *indexPaths = [NSMutableArray arrayWithCapacity:1];
      [indexPaths addObject:[NSIndexPath indexPathForRow:section.mutableRows.count - 1 inSection:sectionIndex]];
      [self.deleteRowsAtIndexPathsSubject sendNext:RACTuplePack(indexPaths, @(animation))];
    }
  }
}

- (void)removeCellViewModelAtIndex:(NSUInteger)index {
  if (self.sections.count > 0) {
    [self removeCellViewModelAtIndex:index
                         fromSection:self.sections.count - 1
                    withRowAnimation:UITableViewRowAnimationNone];
  }
}

- (void)removeCellViewModelAtIndex:(NSUInteger)index withRowAnimation:(UITableViewRowAnimation)animation {
  if (self.sections.count > 0) {
    [self removeCellViewModelAtIndex:index fromSection:self.sections.count - 1 withRowAnimation:animation];
  }
}

- (void)removeCellViewModelAtIndex:(NSUInteger)index fromSection:(NSUInteger)sectionIndex {
  if (self.sections.count > 0) {
    [self removeCellViewModelAtIndex:index fromSection:sectionIndex withRowAnimation:UITableViewRowAnimationNone];
  }
}

- (void)removeCellViewModelAtIndex:(NSUInteger)index
                       fromSection:(NSUInteger)sectionIndex
                  withRowAnimation:(UITableViewRowAnimation)animation {
  if (sectionIndex < self.sections.count) {
    LPDTableSectionViewModel *section = self.sections[sectionIndex];
    if (index < section.mutableRows.count) {
      [section.mutableRows removeObjectAtIndex:index];

      // send deleteRowsAtIndexPathsSignal
      NSMutableArray<NSIndexPath *> *indexPaths = [NSMutableArray arrayWithCapacity:1];
      [indexPaths addObject:[NSIndexPath indexPathForRow:index inSection:sectionIndex]];
      [self.deleteRowsAtIndexPathsSubject sendNext:RACTuplePack(indexPaths, @(animation))];
    }
  }
}

- (void)replaceCellViewModels:(NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)cellViewModels
                    fromIndex:(NSUInteger)index {
  EnsureOneSectionExists;

  [self replaceCellViewModels:cellViewModels fromIndex:index inSection:self.sections.count - 1];
}

- (void)replaceCellViewModels:(NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)cellViewModels
                    fromIndex:(NSUInteger)index
             withRowAnimation:(UITableViewRowAnimation)animation {
  EnsureOneSectionExists;

  [self replaceCellViewModels:cellViewModels fromIndex:index inSection:self.sections.count - 1];
}

- (void)replaceCellViewModels:(NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)cellViewModels
                    fromIndex:(NSUInteger)index
                    inSection:(NSUInteger)sectionIndex {
  EnsureOneSectionExists;

  [self replaceCellViewModels:cellViewModels
                    fromIndex:index
                    inSection:sectionIndex
             withRowAnimation:UITableViewRowAnimationNone];
}

- (void)replaceCellViewModels:(NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)cellViewModels
                    fromIndex:(NSUInteger)index
                    inSection:(NSUInteger)sectionIndex
             withRowAnimation:(UITableViewRowAnimation)animation {
  EnsureOneSectionExists;

  if (sectionIndex >= self.sections.count) {
    return;
  }
  LPDTableSectionViewModel *section = self.sections[sectionIndex];
  if (index >= section.mutableRows.count) {
    return;
  }

  NSMutableSet *testRepeatSet = [[NSMutableSet alloc] initWithArray:cellViewModels];
  if (testRepeatSet.count != cellViewModels.count) {
    return;
  }

  for (LPDTableSectionViewModel *section in self.sections) {
    for (id<LPDTableCellViewModelProtocol> currentCellViewModel in section.mutableRows) {
      if ([cellViewModels containsObject:currentCellViewModel]) {
        return;
      }
    }
  }

  NSRange oldRang = NSMakeRange(index, MIN(section.mutableRows.count - index, cellViewModels.count));
  [section.mutableRows removeObjectsInRange:oldRang];
  NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(index, cellViewModels.count)];
  [section.mutableRows insertObjects:cellViewModels atIndexes:indexSet];
  NSMutableArray<NSIndexPath *> *oldIndexPath = [NSMutableArray arrayWithCapacity:1];
  for (NSInteger i = oldRang.location; i < oldRang.location + oldRang.length - 1; i++) {
    [oldIndexPath addObject:[NSIndexPath indexPathForRow:i inSection:sectionIndex]];
  }
  NSMutableArray<NSIndexPath *> *newIndexPath = [NSMutableArray arrayWithCapacity:1];
  for (NSInteger i = index; i < index + cellViewModels.count - 1; i++) {
    [newIndexPath addObject:[NSIndexPath indexPathForRow:i inSection:sectionIndex]];
  }

  // send replaceRowsAtIndexPathsSignal
  [self.replaceRowsAtIndexPathsSubject sendNext:RACTuplePack(oldIndexPath, newIndexPath, @(animation))];
}

- (void)addSectionViewModel:(id<LPDTableSectionViewModelProtocol>)sectionViewModel {
  [self addSectionViewModel:sectionViewModel withCellViewModels:@[] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)addSectionViewModel:(id<LPDTableSectionViewModelProtocol>)sectionViewModel
           withRowAnimation:(UITableViewRowAnimation)animation {
  [self addSectionViewModel:sectionViewModel withCellViewModels:@[] withRowAnimation:animation];
}

- (void)addSectionViewModel:(id<LPDTableSectionViewModelProtocol>)sectionViewModel
         withCellViewModels:(NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)cellViewModels {
  [self addSectionViewModel:sectionViewModel
         withCellViewModels:cellViewModels
           withRowAnimation:UITableViewRowAnimationNone];
}

- (void)addSectionViewModel:(id<LPDTableSectionViewModelProtocol>)sectionViewModel
         withCellViewModels:(NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)cellViewModels
           withRowAnimation:(UITableViewRowAnimation)animation {
  if ([self.sections containsObject:sectionViewModel]) {
    return;
  }

  NSMutableSet *testRepeatSet = [[NSMutableSet alloc] initWithArray:cellViewModels];
  if (testRepeatSet.count != cellViewModels.count) {
    return;
  }

  for (LPDTableSectionViewModel *section in self.sections) {
    for (id<LPDTableCellViewModelProtocol> currentCellViewModel in section.mutableRows) {
      if ([cellViewModels containsObject:currentCellViewModel]) {
        return;
      }
    }
  }

  LPDTableSectionViewModel *section = sectionViewModel;
  if (cellViewModels && cellViewModels.count > 0) {
    [section.mutableRows addObjectsFromArray:cellViewModels];
  }

  [self.sections addObject:section];

  // send insertSectionsSignal
  NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:self.sections.count - 1];
  [self.insertSectionsSubject sendNext:RACTuplePack(indexSet, @(animation))];
}

- (void)insertSectionViewModel:(id<LPDTableSectionViewModelProtocol>)sectionViewModel atIndex:(NSUInteger)index {
  [self insertSectionViewModel:sectionViewModel
            withCellViewModels:@[]
                       atIndex:index
              withRowAnimation:UITableViewRowAnimationNone];
}

- (void)insertSectionViewModel:(id<LPDTableSectionViewModelProtocol>)sectionViewModel
                       atIndex:(NSUInteger)index
              withRowAnimation:(UITableViewRowAnimation)animation {
  [self insertSectionViewModel:sectionViewModel withCellViewModels:@[] atIndex:index withRowAnimation:animation];
}

- (void)insertSectionViewModel:(id<LPDTableSectionViewModelProtocol>)sectionViewModel
            withCellViewModels:(NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)cellViewModels
                       atIndex:(NSUInteger)index {
  [self insertSectionViewModel:sectionViewModel
            withCellViewModels:cellViewModels
                       atIndex:index
              withRowAnimation:UITableViewRowAnimationNone];
}

- (void)insertSectionViewModel:(id<LPDTableSectionViewModelProtocol>)sectionViewModel
            withCellViewModels:(NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)cellViewModels
                       atIndex:(NSUInteger)index
              withRowAnimation:(UITableViewRowAnimation)animation {
  if (index <= self.sections.count) {

    if ([self.sections containsObject:sectionViewModel]) {
      return;
    }

    NSMutableSet *testRepeatSet = [[NSMutableSet alloc] initWithArray:cellViewModels];
    if (testRepeatSet.count != cellViewModels.count) {
      return;
    }

    for (LPDTableSectionViewModel *section in self.sections) {
      for (id<LPDTableCellViewModelProtocol> currentCellViewModel in section.mutableRows) {
        if ([cellViewModels containsObject:currentCellViewModel]) {
          return;
        }
      }
    }

    LPDTableSectionViewModel *section = sectionViewModel;
    if (cellViewModels && cellViewModels.count > 0) {
      [section.mutableRows addObjectsFromArray:cellViewModels];
    }
    [self.sections insertObject:section atIndex:index];

    // send insertSectionsSignal
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:index];
    [self.insertSectionsSubject sendNext:RACTuplePack(indexSet, @(animation))];
  }
}

- (void)reloadSectionAtIndex:(NSUInteger)index {
  [self reloadSectionsAtRange:NSMakeRange(index, 1) withRowAnimation:UITableViewRowAnimationNone];
}

- (void)reloadSectionAtIndex:(NSUInteger)index withRowAnimation:(UITableViewRowAnimation)animation {
  [self reloadSectionsAtRange:NSMakeRange(index, 1) withRowAnimation:animation];
}

- (void)reloadSectionsAtRange:(NSRange)range {
  [self reloadSectionsAtRange:range withRowAnimation:UITableViewRowAnimationNone];
}

- (void)reloadSectionsAtRange:(NSRange)range withRowAnimation:(UITableViewRowAnimation)animation {
  if (range.location >= self.sections.count) {
    return;
  }
  NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
  [self.reloadSectionsSubject sendNext:RACTuplePack(indexSet, @(UITableViewRowAnimationNone))];
}

- (void)removeSectionAtIndex:(NSUInteger)index {
  [self removeSectionAtIndex:index withRowAnimation:UITableViewRowAnimationNone];
}

- (void)removeAllSections {
  [self removeAllSectionsWithRowAnimation:UITableViewRowAnimationNone];
}

- (void)removeSectionAtIndex:(NSUInteger)index withRowAnimation:(UITableViewRowAnimation)animation {
  if (index < self.sections.count) {
    [self.sections removeObjectAtIndex:index];

    // send deleteSectionsSignal
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:index];
    [self.deleteSectionsSubject sendNext:RACTuplePack(indexSet, @(animation))];
  }
}

- (void)removeAllSectionsWithRowAnimation:(UITableViewRowAnimation)animation {
  if (self.sections.count > 0) {

    // send deleteSectionsSignal
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, self.sections.count)];
    [self.sections removeAllObjects];
    [self.deleteSectionsSubject sendNext:RACTuplePack(indexSet, @(animation))];
  }
}

- (void)replaceSectionWithCellViewModels:(NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)cellViewModels {
  EnsureOneSectionExists;

  [self replaceSectionWithCellViewModels:cellViewModels
                               atSection:self.sections.count - 1
                        withRowAnimation:UITableViewRowAnimationNone];
}

- (void)replaceSectionWithCellViewModels:(NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)cellViewModels
                        withRowAnimation:(UITableViewRowAnimation)animation {
  EnsureOneSectionExists;

  [self replaceSectionWithCellViewModels:cellViewModels atSection:self.sections.count - 1 withRowAnimation:animation];
}

- (void)replaceSectionWithCellViewModels:(NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)cellViewModels
                               atSection:(NSUInteger)sectionIndex {
  EnsureOneSectionExists;

  [self replaceSectionWithCellViewModels:cellViewModels
                               atSection:sectionIndex
                        withRowAnimation:UITableViewRowAnimationNone];
}

- (void)replaceSectionWithCellViewModels:(NSArray<__kindof id<LPDTableCellViewModelProtocol>> *)cellViewModels
                               atSection:(NSUInteger)sectionIndex
                        withRowAnimation:(UITableViewRowAnimation)animation {
  EnsureOneSectionExists;

  if (sectionIndex < self.sections.count) {

    NSMutableSet *testRepeatSet = [[NSMutableSet alloc] initWithArray:cellViewModels];
    if (testRepeatSet.count != cellViewModels.count) {
      return;
    }

    for (LPDTableSectionViewModel *section in self.sections) {
      for (id<LPDTableCellViewModelProtocol> currentCellViewModel in section.mutableRows) {
        if ([cellViewModels containsObject:currentCellViewModel]) {
          return;
        }
      }
    }

    LPDTableSectionViewModel *section = self.sections[sectionIndex];
    [section.mutableRows removeAllObjects];
    [section.mutableRows addObjectsFromArray:cellViewModels];

    // send replaceSectionsSignal
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:sectionIndex];
    [self.replaceSectionsSubject sendNext:RACTuplePack(indexSet, @(animation))];
  }
}

#pragma mark - properties

- (NSMutableArray<__kindof id<LPDTableSectionViewModelProtocol>> *)sections {
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

- (RACSignal *)insertRowsAtIndexPathsSignal {
  return _insertRowsAtIndexPathsSubject ?: (_insertRowsAtIndexPathsSubject =
                                              [[RACSubject subject] setNameWithFormat:@"insertRowsAtIndexPathsSignal"]);
}

- (RACSignal *)deleteRowsAtIndexPathsSignal {
  return _deleteRowsAtIndexPathsSubject ?: (_deleteRowsAtIndexPathsSubject =
                                              [[RACSubject subject] setNameWithFormat:@"deleteRowsAtIndexPathsSignal"]);
}

- (RACSignal *)replaceRowsAtIndexPathsSignal {
  return _replaceRowsAtIndexPathsSubject ?: (_replaceRowsAtIndexPathsSubject = [[RACSubject subject]
                                               setNameWithFormat:@"replaceRowsAtIndexPathsSignal"]);
}

- (RACSignal *)reloadRowsAtIndexPathsSignal {
  return _reloadRowsAtIndexPathsSubject ?: (_reloadRowsAtIndexPathsSubject =
                                              [[RACSubject subject] setNameWithFormat:@"reloadRowsAtIndexPathsSignal"]);
}

- (RACSignal *)willDisplayCellSignal {
  return _willDisplayCellSubject
           ?: (_willDisplayCellSubject = [[RACSubject subject] setNameWithFormat:@"willDisplayCellSignal"]);
}

- (RACSignal *)willDisplayHeaderViewSignal {
  return _willDisplayHeaderViewSubject
           ?: (_willDisplayHeaderViewSubject = [[RACSubject subject] setNameWithFormat:@"willDisplayHeaderViewSignal"]);
}

- (RACSignal *)willDisplayFooterViewSignal {
  return _willDisplayFooterViewSubject
           ?: (_willDisplayFooterViewSubject = [[RACSubject subject] setNameWithFormat:@"willDisplayFooterViewSignal"]);
}

- (RACSignal *)didEndDisplayingCellSignal {
  return _didEndDisplayingCellSubject
           ?: (_didEndDisplayingCellSubject = [[RACSubject subject] setNameWithFormat:@"didEndDisplayingCellSignal"]);
}

- (RACSignal *)didEndDisplayingHeaderViewSignal {
  return _didEndDisplayingHeaderViewSubject ?: (_didEndDisplayingHeaderViewSubject = [[RACSubject subject]
                                                  setNameWithFormat:@"didEndDisplayingHeaderViewSignal"]);
}

- (RACSignal *)didEndDisplayingFooterViewSignal {
  return _didEndDisplayingFooterViewSubject ?: (_didEndDisplayingFooterViewSubject = [[RACSubject subject]
                                                  setNameWithFormat:@"didEndDisplayingFooterViewSignal"]);
}

- (RACSignal *)didHighlightRowAtIndexPathSignal {
  return _didHighlightRowAtIndexPathSubject ?: (_didHighlightRowAtIndexPathSubject = [[RACSubject subject]
                                                  setNameWithFormat:@"didHighlightRowAtIndexPathSignal"]);
}

- (RACSignal *)didUnhighlightRowAtIndexPathSignal {
  return _didUnhighlightRowAtIndexPathSubject ?: (_didUnhighlightRowAtIndexPathSubject = [[RACSubject subject]
                                                    setNameWithFormat:@"didUnhighlightRowAtIndexPathSignal"]);
}

- (RACSignal *)didSelectRowAtIndexPathSignal {
  return _didSelectRowAtIndexPathSubject ?: (_didSelectRowAtIndexPathSubject = [[RACSubject subject]
                                               setNameWithFormat:@"didSelectRowAtIndexPathSignal"]);
}

- (RACSignal *)didDeselectRowAtIndexPathSignal {
  return _didDeselectRowAtIndexPathSubject ?: (_didDeselectRowAtIndexPathSubject = [[RACSubject subject]
                                                 setNameWithFormat:@"didDeselectRowAtIndexPathSignal"]);
}

- (RACSignal *)willBeginEditingRowAtIndexPathSignal {
  return _willBeginEditingRowAtIndexPathSubject ?: (_willBeginEditingRowAtIndexPathSubject = [[RACSubject subject]
                                                      setNameWithFormat:@"willBeginEditingRowAtIndexPathSignal"]);
}

- (RACSignal *)didEndEditingRowAtIndexPathSignal {
  return _didEndEditingRowAtIndexPathSubject ?: (_didEndEditingRowAtIndexPathSubject = [[RACSubject subject]
                                                   setNameWithFormat:@"didEndEditingRowAtIndexPathSignal"]);
}

#pragma mark - private methods

@end

@interface LPDTableViewDelegate ()

@property (nullable, nonatomic, weak, readwrite) __kindof LPDTableViewModel *viewModel;

@end

@implementation LPDTableViewDelegate

- (instancetype)initWithViewModel:(__kindof LPDTableViewModel *)viewModel {
  if (self = [super init]) {
    self.viewModel = viewModel;
  }
  return self;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.viewModel.willDisplayCellSubject) {
    NSObject *cellViewModel = [self.viewModel cellViewModelFromIndexPath:indexPath];
    [self.viewModel.willDisplayCellSubject sendNext:RACTuplePack(tableView, cell, cellViewModel, indexPath)];
  }
}

- (void)tableView:(UITableView *)tableView
  didEndDisplayingCell:(UITableViewCell *)cell
     forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.viewModel.didEndDisplayingCellSubject) {
    NSObject *cellViewModel = [self.viewModel cellViewModelFromIndexPath:indexPath];
    [self.viewModel.didEndDisplayingCellSubject sendNext:RACTuplePack(tableView, cell, cellViewModel, indexPath)];
  }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
  if (self.viewModel.willDisplayHeaderViewSubject) {
    NSObject *headerViewModel = [self.viewModel headerViewModelFromSection:section];
    [self.viewModel.willDisplayHeaderViewSubject sendNext:RACTuplePack(tableView, view, headerViewModel, @(section))];
  }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section {
  if (self.viewModel.didEndDisplayingHeaderViewSubject) {
    NSObject *headerViewModel = [self.viewModel headerViewModelFromSection:section];
    [self.viewModel.didEndDisplayingHeaderViewSubject
      sendNext:RACTuplePack(tableView, view, headerViewModel, @(section))];
  }
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
  if (self.viewModel.willDisplayFooterViewSubject) {
    NSObject *footerViewModel = [self.viewModel footerViewModelFromSection:section];
    [self.viewModel.willDisplayFooterViewSubject sendNext:RACTuplePack(tableView, view, footerViewModel, @(section))];
  }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section {
  if (self.viewModel.didEndDisplayingFooterViewSubject) {
    NSObject *footerViewModel = [self.viewModel footerViewModelFromSection:section];
    [self.viewModel.didEndDisplayingFooterViewSubject
      sendNext:RACTuplePack(tableView, view, footerViewModel, @(section))];
  }
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.viewModel.didHighlightRowAtIndexPathSubject) {
    NSObject *cellViewModel = [self.viewModel cellViewModelFromIndexPath:indexPath];
    [self.viewModel.didHighlightRowAtIndexPathSubject sendNext:RACTuplePack(tableView, cellViewModel, indexPath)];
  }
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.viewModel.didUnhighlightRowAtIndexPathSubject) {
    NSObject *cellViewModel = [self.viewModel cellViewModelFromIndexPath:indexPath];
    [self.viewModel.didUnhighlightRowAtIndexPathSubject sendNext:RACTuplePack(tableView, cellViewModel, indexPath)];
  }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.viewModel.didSelectRowAtIndexPathSubject) {
    NSObject *cellViewModel = [self.viewModel cellViewModelFromIndexPath:indexPath];
    [self.viewModel.didSelectRowAtIndexPathSubject sendNext:RACTuplePack(tableView, cellViewModel, indexPath)];
  }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.viewModel.didDeselectRowAtIndexPathSubject) {
    NSObject *cellViewModel = [self.viewModel cellViewModelFromIndexPath:indexPath];
    [self.viewModel.didDeselectRowAtIndexPathSubject sendNext:RACTuplePack(tableView, cellViewModel, indexPath)];
  }
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.viewModel.willBeginEditingRowAtIndexPathSubject) {
    NSObject *cellViewModel = [self.viewModel cellViewModelFromIndexPath:indexPath];
    [self.viewModel.willBeginEditingRowAtIndexPathSubject sendNext:RACTuplePack(tableView, cellViewModel, indexPath)];
  }
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.viewModel.didEndEditingRowAtIndexPathSubject) {
    NSObject *cellViewModel = [self.viewModel cellViewModelFromIndexPath:indexPath];
    [self.viewModel.didEndEditingRowAtIndexPathSubject sendNext:RACTuplePack(tableView, cellViewModel, indexPath)];
  }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  // 这一步如果高度已经设定，那么直接返回设定的高度
  id<LPDTableCellViewModelProtocol> cellViewModel = [self.viewModel cellViewModelFromIndexPath:indexPath];
  if (cellViewModel && [cellViewModel respondsToSelector:@selector(height)] && cellViewModel.height > 0) {
    return cellViewModel.height;
  }

  if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
    // 9.0的系统会在已经创建好之后走这一步
    cellViewModel = [self.viewModel cellViewModelFromIndexPath:indexPath];
  } else {
    // 需要提前创建cell并进行绑定才能计算出高度
    id<LPDTableViewCellProtocol> cell =
      [self.viewModel.tableViewFactory tableViewModel:self.viewModel cellForTableView:tableView atIndexPath:indexPath];
    cellViewModel = cell.viewModel;
  }

  if (cellViewModel && [cellViewModel respondsToSelector:@selector(height)]) {
    return cellViewModel.height;
  }
  return 1.f;
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
//  return 1.f;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  id<LPDTableSectionViewModelProtocol> sectionViewModel = self.viewModel.sections[section];
  if ([sectionViewModel respondsToSelector:@selector(headerViewModel)]) {
    return sectionViewModel.headerViewModel.height;
  } else if ([sectionViewModel respondsToSelector:@selector(headerTitle)]) {
    return 44.f;
  }
  return .1f;
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section {
//  return 1.f;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  id<LPDTableSectionViewModelProtocol> sectionViewModel = self.viewModel.sections[section];
  if ([sectionViewModel respondsToSelector:@selector(footerViewModel)]) {
    return sectionViewModel.footerViewModel.height;
  } else if ([sectionViewModel respondsToSelector:@selector(footerTitle)]) {
    return 44.f;
  }
  return .1f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  id<LPDTableSectionViewModelProtocol> sectionViewModel = self.viewModel.sections[section];
  if ([sectionViewModel respondsToSelector:@selector(headerViewModel)]) {
    id<LPDTableHeaderFooterViewModelProtocol> headerViewModel = sectionViewModel.headerViewModel;
    return (UIView *)[self.viewModel.tableViewFactory headerWithViewModel:headerViewModel tableView:tableView];
  } else if ([sectionViewModel respondsToSelector:@selector(headerTitle)]) {
    LPDTableViewHeaderFooter *defaultHeader =
      [tableView dequeueReusableHeaderFooterViewWithIdentifier:kDefaultHeaderReuseIdentifier];
    if (!defaultHeader) {
      defaultHeader = [[LPDTableViewHeaderFooter alloc] initWithReuseIdentifier:kDefaultHeaderReuseIdentifier];
    }
    RAC(defaultHeader.textLabel, text) =
      [RACObserve(sectionViewModel, headerTitle) takeUntil:[defaultHeader rac_prepareForReuseSignal]];
    return defaultHeader;
  }
  return nil;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
  id<LPDTableSectionViewModelProtocol> sectionViewModel = self.viewModel.sections[section];
  if ([sectionViewModel respondsToSelector:@selector(footerViewModel)]) {
    id<LPDTableHeaderFooterViewModelProtocol> footerViewModel = sectionViewModel.footerViewModel;
    return (UIView *)[self.viewModel.tableViewFactory footerWithViewModel:footerViewModel tableView:tableView];
  } else if ([sectionViewModel respondsToSelector:@selector(footerTitle)]) {
    LPDTableViewHeaderFooter *defaultFooter =
      [tableView dequeueReusableHeaderFooterViewWithIdentifier:kDefaultFooterReuseIdentifier];
    if (!defaultFooter) {
      defaultFooter = [[LPDTableViewHeaderFooter alloc] initWithReuseIdentifier:kDefaultFooterReuseIdentifier];
    }
    RAC(defaultFooter.textLabel, text) =
      [RACObserve(sectionViewModel, footerTitle) takeUntil:[defaultFooter rac_prepareForReuseSignal]];
    return defaultFooter;
  }
  return nil;
}

@end

@interface LPDTableViewDataSource ()

@property (nullable, nonatomic, weak, readwrite) __kindof LPDTableViewModel *viewModel;

@end

@implementation LPDTableViewDataSource

- (instancetype)initWithViewModel:(__kindof LPDTableViewModel *)viewModel {
  if (self = [super init]) {
    self.viewModel = viewModel;
  }
  return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return self.viewModel.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  //  NSParameterAssert((NSUInteger)section < self.viewModel.sections.count || 0 == self.viewModel.sections.count);
  if ((NSUInteger)section < self.viewModel.sections.count) {
    return [self.viewModel.sections objectAtIndex:section].rows.count;
  } else {
    return 0;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = (UITableViewCell *)[self.viewModel.tableViewFactory tableViewModel:self.viewModel
                                                                            cellForTableView:tableView
                                                                                 atIndexPath:indexPath];
  return cell;
}

@end
