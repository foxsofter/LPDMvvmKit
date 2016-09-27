//
//  LPDSegmented.h
//  LPDMvvmKit
//
//  Created by foxsofter on 15/2/13.
//  Copyright (c) 2015年 foxsofter. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LPDSegmented;

typedef void (^SelectionChangedBlock)(NSInteger index);

typedef NSAttributedString * (^TitleFormatterBlock)(LPDSegmented *segmentedControl, NSString *title, NSUInteger index,
                                                    BOOL selected);

typedef NS_ENUM(NSInteger, LPDSegmentedSelectionStyle) {
  LPDSegmentedSelectionStyleTextWidthStripe,
  LPDSegmentedSelectionStyleFullWidthStripe,
  LPDSegmentedSelectionStyleBox,
  LPDSegmentedSelectionStyleArrow
};

typedef NS_ENUM(NSInteger, LPDSegmentedSelectionIndicatorLocation) {
  LPDSegmentedSelectionIndicatorLocationTop,
  LPDSegmentedSelectionIndicatorLocationBottom,
  LPDSegmentedSelectionIndicatorLocationNone
};

typedef NS_ENUM(NSInteger, LPDSegmentedWidthStyle) {
  LPDSegmentedWidthStyleFixed,
  LPDSegmentedWidthStyleDynamic,
};

typedef NS_OPTIONS(NSInteger, LPDSegmentedBorderType) {
  LPDSegmentedBorderTypeNone = 0,
  LPDSegmentedBorderTypeTop = (1 << 0),
  LPDSegmentedBorderTypeLeft = (1 << 1),
  LPDSegmentedBorderTypeBottom = (1 << 2),
  LPDSegmentedBorderTypeRight = (1 << 3)
};

enum { LPDSegmentedNoSegment = -1 };

typedef NS_ENUM(NSInteger, LPDSegmentedType) {
  LPDSegmentedTypeText,
  LPDSegmentedTypeImages,
  LPDSegmentedTypeTextImages
};

@interface LPDScrollView : UIScrollView
@end

@interface LPDSegmented : UIControl

@property (nonatomic, copy) NSArray *sectionTitles;
@property (nonatomic, copy) NSArray *sectionImages;
@property (nonatomic, copy) NSArray *sectionSelectedImages;

@property (nonatomic, copy) SelectionChangedBlock selectionChanged;
@property (nonatomic, copy) TitleFormatterBlock titleFormatter;
@property (nonatomic, strong) NSDictionary *titleTextAttributes UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) NSDictionary *selectedTitleTextAttributes UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *backgroundColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *selectionIndicatorColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *verticalDividerColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat selectionIndicatorBoxOpacity;
@property (nonatomic, assign) CGFloat verticalDividerWidth;
@property (nonatomic, assign) LPDSegmentedType type;
@property (nonatomic, assign) LPDSegmentedSelectionStyle selectionStyle;
@property (nonatomic, assign) LPDSegmentedWidthStyle widthStyle;
@property (nonatomic, assign) LPDSegmentedSelectionIndicatorLocation selectionIndicatorLocation;
@property (nonatomic, assign) BOOL selectionIndicatorFullWidth;
@property (nonatomic, assign) LPDSegmentedBorderType borderType;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, getter=isUserDraggable) BOOL userDraggable;
@property (nonatomic, getter=isTouchEnabled) BOOL touchEnabled;
@property (nonatomic, getter=isVerticalDividerEnabled) BOOL verticalDividerEnabled;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, readwrite) CGFloat selectionIndicatorHeight;
@property (nonatomic, readwrite) UIEdgeInsets selectionIndicatorEdgeInsets;
@property (nonatomic, readwrite) UIEdgeInsets segmentEdgeInset;
@property (nonatomic) BOOL shouldAnimateUserSelection;

- (instancetype)initWithSectionTitles:(NSArray *)sectionTitles;
- (instancetype)initWithSectionImages:(NSArray *)sectionImages
                sectionSelectedImages:(NSArray *)sectionSelectedImages NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithSectionImages:(NSArray *)sectionImages
                sectionSelectedImages:(NSArray *)sectionSelectedImages
                    titlesForSections:(NSArray *)sectionTitles NS_DESIGNATED_INITIALIZER;
- (void)setSelectedIndex:(NSUInteger)index animated:(BOOL)animated;
- (void)setSelectedIndex:(NSUInteger)index animated:(BOOL)animated notify:(BOOL)notify;

- (void)setSectionTitle:(NSString *)title atIndex:(NSUInteger)index;

@property (nonatomic, strong) UIColor *badgeColor;
- (void)setShowBadge:(BOOL)show atIndex:(NSUInteger)index;

@end
