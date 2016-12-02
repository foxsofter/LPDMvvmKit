//
//  LPDSegmented.m
//  LPDMvvmKit
//
//  Created by foxsofter on 15/2/13.
//  Copyright (c) 2015年 foxsofter. All rights reserved.
//

#import "LPDSegmented.h"
#import "UIColor+LPDAddition.h"

@implementation LPDScrollView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  if (!self.dragging) {
    [self.nextResponder touchesBegan:touches withEvent:event];
  } else {
    [super touchesBegan:touches withEvent:event];
  }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  if (!self.dragging) {
    [self.nextResponder touchesMoved:touches withEvent:event];
  } else {
    [super touchesMoved:touches withEvent:event];
  }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  if (!self.dragging) {
    [self.nextResponder touchesEnded:touches withEvent:event];
  } else {
    [super touchesEnded:touches withEvent:event];
  }
}

@end

@interface LPDSegmented ()

@property (nonatomic, strong) CALayer *selectionIndicatorStripLayer;
@property (nonatomic, strong) CALayer *selectionIndicatorBoxLayer;
@property (nonatomic, strong) CALayer *selectionIndicatorArrowLayer;
@property (nonatomic, readwrite) CGFloat segmentWidth;
@property (nonatomic, assign) CGFloat segmentActualWidth;
@property (nonatomic, readwrite, copy) NSArray *segmentWidthsArray;
@property (nonatomic, strong) LPDScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *showBadgesArray;

@end

@implementation LPDSegmented

@synthesize badgeColor = _badgeColor;

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self initialize];
  }
  return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self initialize];
  }
  return self;
}

- (instancetype)initWithSectionTitles:(NSArray *)sectionTitles {
  self = [super initWithFrame:CGRectZero];
  if (self) {
    [self initialize];
    self.sectionTitles = sectionTitles;
    self.type = LPDSegmentedTypeText;
  }

  return self;
}

- (instancetype)initWithSectionImages:(NSArray *)sectionImages sectionSelectedImages:(NSArray *)sectionSelectedImages {
  self = [super initWithFrame:CGRectZero];

  if (self) {
    [self initialize];
    self.sectionImages = sectionImages;
    self.sectionSelectedImages = sectionSelectedImages;
    self.type = LPDSegmentedTypeImages;
  }

  return self;
}

- (instancetype)initWithSectionImages:(NSArray *)sectionImages
                sectionSelectedImages:(NSArray *)sectionSelectedImages
                    titlesForSections:(NSArray *)sectiontitles {
  self = [super initWithFrame:CGRectZero];

  if (self) {
    [self initialize];

    if (sectionImages.count != sectiontitles.count) {
      [NSException raise:NSRangeException
                  format:@"***%s: Images bounds (%ld) Dont match Title bounds (%ld)", sel_getName(_cmd),
                         (unsigned long)sectionImages.count, (unsigned long)sectiontitles.count];
    }

    self.sectionImages = sectionImages;
    self.sectionSelectedImages = sectionSelectedImages;
    self.sectionTitles = sectiontitles;
    self.type = LPDSegmentedTypeTextImages;
  }

  return self;
}

- (void)awakeFromNib {
  [super awakeFromNib];

  self.segmentWidth = 0.0f;
  [self initialize];
}

- (void)initialize {
  self.scrollView = [[LPDScrollView alloc] init];
  self.scrollView.scrollsToTop = NO;
  self.scrollView.showsVerticalScrollIndicator = NO;
  self.scrollView.showsHorizontalScrollIndicator = NO;
  [self addSubview:self.scrollView];

  _backgroundColor = [UIColor whiteColor];
  self.opaque = NO;
  _selectionIndicatorColor = [UIColor colorWithHexString:@"#008AF1"];

  self.selectedIndex = 0;
  self.segmentEdgeInset = UIEdgeInsetsMake(0, 5, 0, 5);
  self.selectionIndicatorHeight = 5.0f;
  self.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
  self.selectionStyle = LPDSegmentedSelectionStyleTextWidthStripe;
  self.selectionIndicatorLocation = LPDSegmentedSelectionIndicatorLocationTop;
  self.segmentWidthStyle = LPDSegmentedWidthStyleFixed;
  self.userDraggable = YES;
  self.touchEnabled = YES;
  self.verticalDividerEnabled = NO;
  self.type = LPDSegmentedTypeText;
  self.verticalDividerWidth = 1.0f;
  _verticalDividerColor = [UIColor blackColor];
  self.borderColor = [UIColor blackColor];
  self.borderWidth = 1.0f;

  self.shouldAnimateUserSelection = YES;

  self.selectionIndicatorArrowLayer = [CALayer layer];
  self.selectionIndicatorStripLayer = [CALayer layer];
  self.selectionIndicatorBoxLayer = [CALayer layer];
  self.selectionIndicatorBoxLayer.opacity = self.selectionIndicatorBoxOpacity;
  self.selectionIndicatorBoxLayer.borderWidth = 1.0f;
  self.selectionIndicatorBoxOpacity = 0.2;

  self.contentMode = UIViewContentModeRedraw;
}

- (void)layoutSubviews {
  [super layoutSubviews];

  [self updateSegmentsRects];
}

- (void)setFrame:(CGRect)frame {
  [super setFrame:frame];

  [self updateSegmentsRects];
}

- (void)setCenter:(CGPoint)center {
  [super setCenter:center];

  [self updateSegmentsRects];
}

- (void)setSectionTitles:(NSArray *)sectionTitles {
  _sectionTitles = sectionTitles;

  _showBadgesArray = [NSMutableArray arrayWithCapacity:sectionTitles.count];
  for (NSInteger i = 0; i < sectionTitles.count; i++) {
    [_showBadgesArray addObject:@0];
  }

  [self setNeedsLayout];
  [self setNeedsDisplay];
}

- (void)setSectionTitle:(NSString *)title atIndex:(NSUInteger)index {
  if (!_sectionTitles || _sectionTitles.count < 1 || index >= _sectionTitles.count) {
    return;
  }

  NSMutableArray *sectionTitles = [NSMutableArray arrayWithArray:_sectionTitles];
  [sectionTitles replaceObjectAtIndex:index withObject:title];
  _sectionTitles = [sectionTitles copy];

  [self setNeedsLayout];
  [self setNeedsDisplay];
}

- (UIColor *)badgeColor {
  return _badgeColor ?: (_badgeColor = [UIColor redColor]);
}

- (void)setBadgeColor:(UIColor *)badgeColor {
  _badgeColor = badgeColor;
  [self setNeedsDisplay];
}

- (void)setShowBadge:(BOOL)show atIndex:(NSUInteger)index {
  NSNumber *showBadge = [_showBadgesArray objectAtIndex:index];
  if ([showBadge boolValue] == show) {
    return;
  }
  [_showBadgesArray replaceObjectAtIndex:index withObject:@(show)];
  [self setNeedsDisplay];
}

- (void)setSectionImages:(NSArray *)sectionImages {
  _sectionImages = sectionImages;

  [self setNeedsLayout];
  [self setNeedsDisplay];
}

- (void)setSelectionIndicatorLocation:(LPDSegmentedSelectionIndicatorLocation)selectionIndicatorLocation {
  _selectionIndicatorLocation = selectionIndicatorLocation;

  if (selectionIndicatorLocation == LPDSegmentedSelectionIndicatorLocationNone) {
    self.selectionIndicatorHeight = 0.0f;
  }
  [self setNeedsLayout];
  [self setNeedsDisplay];
}

- (void)setSelectionIndicatorBoxOpacity:(CGFloat)selectionIndicatorBoxOpacity {
  _selectionIndicatorBoxOpacity = selectionIndicatorBoxOpacity;

  self.selectionIndicatorBoxLayer.opacity = _selectionIndicatorBoxOpacity;
}

- (void)setSegmentWidthStyle:(LPDSegmentedWidthStyle)widthStyle {
  if (self.type == LPDSegmentedTypeImages) {
    _widthStyle = LPDSegmentedWidthStyleFixed;
  } else {
    _widthStyle = widthStyle;
  }
}

- (void)setBorderType:(LPDSegmentedBorderType)borderType {
  _borderType = borderType;

  [self setNeedsDisplay];
}

#pragma mark - Drawing

- (CGSize)measureTitleAtIndex:(NSUInteger)index {
  id title = self.sectionTitles[index];
  CGSize size = CGSizeZero;
  BOOL selected = (index == self.selectedIndex) ? YES : NO;
  if ([title isKindOfClass:[NSString class]] && !self.titleFormatter) {
    NSDictionary *titleAttrs =
      selected ? [self resultingSelectedTitleTextAttributes] : [self resultingTitleTextAttributes];
    size = [(NSString *)title sizeWithAttributes:titleAttrs];
  } else if ([title isKindOfClass:[NSString class]] && self.titleFormatter) {
    size = [self.titleFormatter(self, title, index, selected) size];
  } else if ([title isKindOfClass:[NSAttributedString class]]) {
    size = [(NSAttributedString *)title size];
  } else {
    NSAssert(title == nil, @"Unexpected type of segment title: %@", [title class]);
    size = CGSizeZero;
  }
  return CGRectIntegral((CGRect){CGPointZero, size}).size;
}

- (NSAttributedString *)attributedTitleAtIndex:(NSUInteger)index {
  NSString *title = self.sectionTitles[index];
  BOOL selected = (index == self.selectedIndex) ? YES : NO;

  if (!self.titleFormatter) {
    NSDictionary *titleAttrs =
      selected ? [self resultingSelectedTitleTextAttributes] : [self resultingTitleTextAttributes];
    return [[NSAttributedString alloc] initWithString:(NSString *)title attributes:titleAttrs];
  } else {
    return self.titleFormatter(self, title, index, selected);
  }
}

- (void)drawRect:(CGRect)rect {
  [super drawRect:rect];

  [self.backgroundColor setFill];
  UIRectFill([self bounds]);

  self.selectionIndicatorArrowLayer.backgroundColor = self.selectionIndicatorColor.CGColor;

  self.selectionIndicatorStripLayer.backgroundColor = self.selectionIndicatorColor.CGColor;

  self.selectionIndicatorBoxLayer.backgroundColor = self.selectionIndicatorColor.CGColor;
  self.selectionIndicatorBoxLayer.borderColor = self.selectionIndicatorColor.CGColor;

  self.scrollView.layer.sublayers = nil;

  CGRect oldRect = rect;

  if (self.type == LPDSegmentedTypeText) {
    [self.sectionTitles enumerateObjectsUsingBlock:^(id titleString, NSUInteger idx, BOOL *stop) {

      CGFloat stringWidth = 0;
      CGFloat stringHeight = 0;
      CGSize size = [self measureTitleAtIndex:idx];
      stringWidth = size.width;
      stringHeight = size.height;
      CGRect rectDiv, fullRect;

      BOOL locationUp = (self.selectionIndicatorLocation == LPDSegmentedSelectionIndicatorLocationTop);
      BOOL selectionStyleNotBox = (self.selectionStyle != LPDSegmentedSelectionStyleBox);

      CGFloat y = roundf((CGRectGetHeight(self.frame) - selectionStyleNotBox * self.selectionIndicatorHeight) / 2 -
                         stringHeight / 2 + self.selectionIndicatorHeight * locationUp);
      CGRect rect;
      if (self.widthStyle == LPDSegmentedWidthStyleFixed) {
        rect =
          CGRectMake((self.segmentWidth * idx) + (self.segmentWidth - stringWidth) / 2, y, stringWidth, stringHeight);
        rectDiv =
          CGRectMake((self.segmentWidth * idx) - (self.verticalDividerWidth / 2), self.selectionIndicatorHeight * 2,
                     self.verticalDividerWidth, self.frame.size.height - (self.selectionIndicatorHeight * 4));
        fullRect = CGRectMake(self.segmentWidth * idx, 0, self.segmentWidth, oldRect.size.height);
      } else if (self.widthStyle == LPDSegmentedWidthStyleDynamic) {
        CGFloat xOffset = 0;
        NSInteger i = 0;
        for (NSNumber *width in self.segmentWidthsArray) {
          if (idx == i)
            break;
          xOffset = xOffset + [width floatValue];
          i++;
        }

        CGFloat widthForIndex = [(self.segmentWidthsArray)[idx] floatValue];
        rect = CGRectMake(xOffset, y, widthForIndex, stringHeight);
        fullRect = CGRectMake(self.segmentWidth * idx, 0, widthForIndex, oldRect.size.height);
        rectDiv = CGRectMake(xOffset - (self.verticalDividerWidth / 2), self.selectionIndicatorHeight * 2,
                             self.verticalDividerWidth, self.frame.size.height - (self.selectionIndicatorHeight * 4));
      }

      rect = CGRectMake(ceilf(rect.origin.x), ceilf(rect.origin.y), ceilf(rect.size.width), ceilf(rect.size.height));

      CATextLayer *titleLayer = [CATextLayer layer];
      titleLayer.frame = rect;
      titleLayer.alignmentMode = kCAAlignmentCenter;
      titleLayer.truncationMode = kCATruncationEnd;
      titleLayer.string = [self attributedTitleAtIndex:idx];
      titleLayer.contentsScale = [[UIScreen mainScreen] scale];
      [self.scrollView.layer addSublayer:titleLayer];

      if ([[self.showBadgesArray objectAtIndex:idx] boolValue]) {
        CALayer *badgeLayer = [CALayer layer];
        badgeLayer.frame = CGRectMake(rect.origin.x + rect.size.width + 6, rect.origin.y, 6, 6);
        badgeLayer.cornerRadius = 3;
        badgeLayer.backgroundColor = self.badgeColor.CGColor;
        [self.scrollView.layer addSublayer:badgeLayer];
      }

      if (self.isVerticalDividerEnabled && idx > 0) {
        CALayer *verticalDividerLayer = [CALayer layer];
        verticalDividerLayer.frame = rectDiv;
        verticalDividerLayer.backgroundColor = self.verticalDividerColor.CGColor;

        [self.scrollView.layer addSublayer:verticalDividerLayer];
      }

      [self addBackgroundAndBorderLayerWithRect:fullRect];
    }];
  } else if (self.type == LPDSegmentedTypeImages) {
    [self.sectionImages enumerateObjectsUsingBlock:^(id iconImage, NSUInteger idx, BOOL *stop) {
      UIImage *icon = iconImage;
      CGFloat imageWidth = icon.size.width;
      CGFloat imageHeight = icon.size.height;
      CGFloat y =
        roundf(CGRectGetHeight(self.frame) - self.selectionIndicatorHeight) / 2 - imageHeight / 2 +
        ((self.selectionIndicatorLocation == LPDSegmentedSelectionIndicatorLocationTop) ? self.selectionIndicatorHeight
                                                                                        : 0);
      CGFloat x = self.segmentWidth * idx + (self.segmentWidth - imageWidth) / 2.0f;
      CGRect rect = CGRectMake(x, y, imageWidth, imageHeight);

      CALayer *imageLayer = [CALayer layer];
      imageLayer.frame = rect;

      if (self.selectedIndex == idx) {
        if (self.sectionSelectedImages) {
          UIImage *highlightIcon = (self.sectionSelectedImages)[idx];
          imageLayer.contents = (id)highlightIcon.CGImage;
        } else {
          imageLayer.contents = (id)icon.CGImage;
        }
      } else {
        imageLayer.contents = (id)icon.CGImage;
      }

      [self.scrollView.layer addSublayer:imageLayer];

      if ([[self.showBadgesArray objectAtIndex:idx] boolValue]) {
        CALayer *badgeLayer = [CALayer layer];
        badgeLayer.frame = CGRectMake(rect.origin.x + rect.size.width + 6, rect.origin.y, 6, 6);
        badgeLayer.cornerRadius = 3;
        badgeLayer.backgroundColor = self.badgeColor.CGColor;
        [self.scrollView.layer addSublayer:badgeLayer];
      }

      if (self.isVerticalDividerEnabled && idx > 0) {
        CALayer *verticalDividerLayer = [CALayer layer];
        verticalDividerLayer.frame =
          CGRectMake((self.segmentWidth * idx) - (self.verticalDividerWidth / 2), self.selectionIndicatorHeight * 2,
                     self.verticalDividerWidth, self.frame.size.height - (self.selectionIndicatorHeight * 4));
        verticalDividerLayer.backgroundColor = self.verticalDividerColor.CGColor;

        [self.scrollView.layer addSublayer:verticalDividerLayer];
      }

      [self addBackgroundAndBorderLayerWithRect:rect];
    }];
  } else if (self.type == LPDSegmentedTypeTextImages) {
    [self.sectionImages enumerateObjectsUsingBlock:^(id iconImage, NSUInteger idx, BOOL *stop) {
      UIImage *icon = iconImage;
      CGFloat imageWidth = icon.size.width;
      CGFloat imageHeight = icon.size.height;

      CGFloat stringHeight = [self measureTitleAtIndex:idx].height;
      CGFloat yOffset =
        roundf(((CGRectGetHeight(self.frame) - self.selectionIndicatorHeight) / 2) - (stringHeight / 2));

      CGFloat imageXOffset = self.segmentEdgeInset.left;
      CGFloat textXOffset = self.segmentEdgeInset.left;
      CGFloat textWidth = 0;

      if (self.widthStyle == LPDSegmentedWidthStyleFixed) {
        imageXOffset = (self.segmentWidth * idx) + (self.segmentWidth / 2.0f) - (imageWidth / 2.0f);
        textXOffset = self.segmentWidth * idx;
        textWidth = self.segmentWidth;
      } else if (self.widthStyle == LPDSegmentedWidthStyleDynamic) {
        CGFloat xOffset = 0;
        NSInteger i = 0;

        for (NSNumber *width in self.segmentWidthsArray) {
          if (idx == i) {
            break;
          }

          xOffset = xOffset + [width floatValue];
          i++;
        }

        imageXOffset = xOffset + ([self.segmentWidthsArray[idx] floatValue] / 2.0f) - (imageWidth / 2.0f);
        textXOffset = xOffset;
        textWidth = [self.segmentWidthsArray[idx] floatValue];
      }

      CGFloat imageYOffset = roundf((CGRectGetHeight(self.frame) - self.selectionIndicatorHeight) / 2.0f);
      CGRect imageRect = CGRectMake(imageXOffset, imageYOffset, imageWidth, imageHeight);
      CGRect textRect = CGRectMake(textXOffset, yOffset, textWidth, stringHeight);

      textRect = CGRectMake(ceilf(textRect.origin.x), ceilf(textRect.origin.y), ceilf(textRect.size.width),
                            ceilf(textRect.size.height));

      CATextLayer *titleLayer = [CATextLayer layer];
      titleLayer.frame = textRect;
      titleLayer.alignmentMode = kCAAlignmentCenter;
      titleLayer.string = [self attributedTitleAtIndex:idx];
      titleLayer.truncationMode = kCATruncationEnd;
      CALayer *imageLayer = [CALayer layer];
      imageLayer.frame = imageRect;

      if (self.selectedIndex == idx) {
        if (self.sectionSelectedImages) {
          UIImage *highlightIcon = (self.sectionSelectedImages)[idx];
          imageLayer.contents = (id)highlightIcon.CGImage;
        } else {
          imageLayer.contents = (id)icon.CGImage;
        }
      } else {
        imageLayer.contents = (id)icon.CGImage;
      }

      [self.scrollView.layer addSublayer:imageLayer];
      titleLayer.contentsScale = [[UIScreen mainScreen] scale];
      [self.scrollView.layer addSublayer:titleLayer];

      if ([[self.showBadgesArray objectAtIndex:idx] boolValue]) {
        CALayer *badgeLayer = [CALayer layer];
        badgeLayer.frame = CGRectMake(textRect.origin.x + textRect.size.width + 6, textRect.origin.y, 6, 6);
        badgeLayer.cornerRadius = 3;
        badgeLayer.backgroundColor = self.badgeColor.CGColor;
        [self.scrollView.layer addSublayer:badgeLayer];
      }

      [self addBackgroundAndBorderLayerWithRect:imageRect];
    }];
  }

  if (self.selectedIndex != LPDSegmentedNoSegment) {
    if (self.selectionStyle == LPDSegmentedSelectionStyleArrow) {
      if (!self.selectionIndicatorArrowLayer.superlayer) {
        [self setArrowFrame];
        [self.scrollView.layer addSublayer:self.selectionIndicatorArrowLayer];
      }
    } else {
      if (!self.selectionIndicatorStripLayer.superlayer) {
        self.selectionIndicatorStripLayer.frame = [self frameForSelectionIndicator];
        [self.scrollView.layer addSublayer:self.selectionIndicatorStripLayer];

        if (self.selectionStyle == LPDSegmentedSelectionStyleBox && !self.selectionIndicatorBoxLayer.superlayer) {
          self.selectionIndicatorBoxLayer.frame = [self frameForFillerSelectionIndicator];
          [self.scrollView.layer insertSublayer:self.selectionIndicatorBoxLayer atIndex:0];
        }
      }
    }
  }
}

- (void)addBackgroundAndBorderLayerWithRect:(CGRect)fullRect {
  CALayer *backgroundLayer = [CALayer layer];
  backgroundLayer.frame = fullRect;
  [self.scrollView.layer insertSublayer:backgroundLayer atIndex:0];

  if (self.borderType & LPDSegmentedBorderTypeTop) {
    CALayer *borderLayer = [CALayer layer];
    borderLayer.frame = CGRectMake(0, 0, fullRect.size.width, self.borderWidth);
    borderLayer.backgroundColor = self.borderColor.CGColor;
    [backgroundLayer addSublayer:borderLayer];
  }
  if (self.borderType & LPDSegmentedBorderTypeLeft) {
    CALayer *borderLayer = [CALayer layer];
    borderLayer.frame = CGRectMake(0, 0, self.borderWidth, fullRect.size.height);
    borderLayer.backgroundColor = self.borderColor.CGColor;
    [backgroundLayer addSublayer:borderLayer];
  }
  if (self.borderType & LPDSegmentedBorderTypeBottom) {
    CALayer *borderLayer = [CALayer layer];
    borderLayer.frame = CGRectMake(0, fullRect.size.height - self.borderWidth, fullRect.size.width, self.borderWidth);
    borderLayer.backgroundColor = self.borderColor.CGColor;
    [backgroundLayer addSublayer:borderLayer];
  }
  if (self.borderType & LPDSegmentedBorderTypeRight) {
    CALayer *borderLayer = [CALayer layer];
    borderLayer.frame = CGRectMake(fullRect.size.width - self.borderWidth, 0, self.borderWidth, fullRect.size.height);
    borderLayer.backgroundColor = self.borderColor.CGColor;
    [backgroundLayer addSublayer:borderLayer];
  }
}

- (void)setArrowFrame {
  self.selectionIndicatorArrowLayer.frame = [self frameForSelectionIndicator];

  self.selectionIndicatorArrowLayer.mask = nil;

  UIBezierPath *arrowPath = [UIBezierPath bezierPath];

  CGPoint p1 = CGPointZero;
  CGPoint p2 = CGPointZero;
  CGPoint p3 = CGPointZero;

  if (self.selectionIndicatorLocation == LPDSegmentedSelectionIndicatorLocationBottom) {
    p1 = CGPointMake(self.selectionIndicatorArrowLayer.bounds.size.width / 2, 0);
    p2 = CGPointMake(0, self.selectionIndicatorArrowLayer.bounds.size.height);
    p3 = CGPointMake(self.selectionIndicatorArrowLayer.bounds.size.width,
                     self.selectionIndicatorArrowLayer.bounds.size.height);
  }

  if (self.selectionIndicatorLocation == LPDSegmentedSelectionIndicatorLocationTop) {
    p1 = CGPointMake(self.selectionIndicatorArrowLayer.bounds.size.width / 2,
                     self.selectionIndicatorArrowLayer.bounds.size.height);
    p2 = CGPointMake(self.selectionIndicatorArrowLayer.bounds.size.width, 0);
    p3 = CGPointMake(0, 0);
  }

  [arrowPath moveToPoint:p1];
  [arrowPath addLineToPoint:p2];
  [arrowPath addLineToPoint:p3];
  [arrowPath closePath];

  CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
  maskLayer.frame = self.selectionIndicatorArrowLayer.bounds;
  maskLayer.path = arrowPath.CGPath;
  self.selectionIndicatorArrowLayer.mask = maskLayer;
}

- (CGRect)frameForSelectionIndicator {
  CGFloat indicatorYOffset = 0.0f;

  if (self.selectionIndicatorLocation == LPDSegmentedSelectionIndicatorLocationBottom) {
    indicatorYOffset =
      self.bounds.size.height - self.selectionIndicatorHeight + self.selectionIndicatorEdgeInsets.bottom;
  }

  if (self.selectionIndicatorLocation == LPDSegmentedSelectionIndicatorLocationTop) {
    indicatorYOffset = self.selectionIndicatorEdgeInsets.top;
  }

  CGFloat sectionWidth = 0.0f;

  if (self.selectionIndicatorFullWidth) {
    sectionWidth = self.segmentWidth - self.selectionIndicatorEdgeInsets.right;
  } else {
    if (self.type == LPDSegmentedTypeText) {
      CGFloat stringWidth = [self measureTitleAtIndex:self.selectedIndex].width;
      sectionWidth = stringWidth;
    } else if (self.type == LPDSegmentedTypeImages) {
      UIImage *sectionImage = (self.sectionImages)[self.selectedIndex];
      CGFloat imageWidth = sectionImage.size.width;
      sectionWidth = imageWidth;
    } else if (self.type == LPDSegmentedTypeTextImages) {
      CGFloat stringWidth = [self measureTitleAtIndex:self.selectedIndex].width;
      UIImage *sectionImage = (self.sectionImages)[self.selectedIndex];
      CGFloat imageWidth = sectionImage.size.width;
      sectionWidth = MAX(stringWidth, imageWidth);
    }
  }

  if (self.selectionStyle == LPDSegmentedSelectionStyleArrow) {
    CGFloat widthToEndOfSelectedSegment = (self.segmentWidth * self.selectedIndex) + self.segmentWidth;
    CGFloat widthToStartOfSelectedIndex = (self.segmentWidth * self.selectedIndex);

    CGFloat x = widthToStartOfSelectedIndex + ((widthToEndOfSelectedSegment - widthToStartOfSelectedIndex) / 2) -
                (self.selectionIndicatorHeight / 2);
    return CGRectMake(x - (self.selectionIndicatorHeight / 2), indicatorYOffset, self.selectionIndicatorHeight * 2,
                      self.selectionIndicatorHeight);
  } else {
    if (self.selectionStyle == LPDSegmentedSelectionStyleTextWidthStripe && sectionWidth <= self.segmentWidth &&
        self.widthStyle != LPDSegmentedWidthStyleDynamic) {
      CGFloat widthToEndOfSelectedSegment = (self.segmentWidth * self.selectedIndex) + self.segmentWidth;
      CGFloat widthToStartOfSelectedIndex = (self.segmentWidth * self.selectedIndex);

      CGFloat x = ((widthToEndOfSelectedSegment - widthToStartOfSelectedIndex) / 2) +
                  (widthToStartOfSelectedIndex - sectionWidth / 2);
      return CGRectMake(x + self.selectionIndicatorEdgeInsets.left, indicatorYOffset,
                        sectionWidth - self.selectionIndicatorEdgeInsets.right, self.selectionIndicatorHeight);
    } else {
      if (self.widthStyle == LPDSegmentedWidthStyleDynamic) {
        CGFloat selectedSegmentOffset = 0.0f;

        NSInteger i = 0;
        for (NSNumber *width in self.segmentWidthsArray) {
          if (self.selectedIndex == i)
            break;
          selectedSegmentOffset = selectedSegmentOffset + [width floatValue];
          i++;
        }
        return CGRectMake(selectedSegmentOffset + self.selectionIndicatorEdgeInsets.left, indicatorYOffset,
                          [(self.segmentWidthsArray)[self.selectedIndex] floatValue] -
                            self.selectionIndicatorEdgeInsets.right,
                          self.selectionIndicatorHeight + self.selectionIndicatorEdgeInsets.bottom);
      }

      return CGRectMake((self.segmentWidth + self.selectionIndicatorEdgeInsets.left) * self.selectedIndex,
                        indicatorYOffset, self.segmentWidth - self.selectionIndicatorEdgeInsets.right,
                        self.selectionIndicatorHeight);
    }
  }
}

- (CGRect)frameForFillerSelectionIndicator {
  if (self.widthStyle == LPDSegmentedWidthStyleDynamic) {
    CGFloat selectedSegmentOffset = 0.0f;

    NSInteger i = 0;
    for (NSNumber *width in self.segmentWidthsArray) {
      if (self.selectedIndex == i) {
        break;
      }
      selectedSegmentOffset = selectedSegmentOffset + [width floatValue];

      i++;
    }

    return CGRectMake(selectedSegmentOffset, 0, [(self.segmentWidthsArray)[self.selectedIndex] floatValue],
                      CGRectGetHeight(self.frame));
  }
  return CGRectMake(self.segmentWidth * self.selectedIndex, 0, self.segmentWidth, CGRectGetHeight(self.frame));
}

- (void)updateSegmentsRects {
  self.scrollView.contentInset = UIEdgeInsetsZero;
  self.scrollView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));

  if ([self sectionCount] > 0) {
    self.segmentWidth = self.frame.size.width / [self sectionCount];
  }

  if (self.type == LPDSegmentedTypeText && self.widthStyle == LPDSegmentedWidthStyleFixed) {
    [self.sectionTitles enumerateObjectsUsingBlock:^(id titleString, NSUInteger idx, BOOL *stop) {
      CGFloat stringWidth =
        [self measureTitleAtIndex:idx].width + self.segmentEdgeInset.left + self.segmentEdgeInset.right;
      self.segmentWidth = MAX(stringWidth, self.segmentWidth);
    }];
  } else if (self.type == LPDSegmentedTypeText && self.widthStyle == LPDSegmentedWidthStyleDynamic) {
    NSMutableArray *mutableSegmentWidths = [NSMutableArray array];

    [self.sectionTitles enumerateObjectsUsingBlock:^(id titleString, NSUInteger idx, BOOL *stop) {
      CGFloat stringWidth =
        [self measureTitleAtIndex:idx].width + self.segmentEdgeInset.left + self.segmentEdgeInset.right;
      [mutableSegmentWidths addObject:[NSNumber numberWithFloat:stringWidth]];
    }];
    self.segmentWidthsArray = [mutableSegmentWidths copy];
  } else if (self.type == LPDSegmentedTypeImages) {
    for (UIImage *sectionImage in self.sectionImages) {
      CGFloat imageWidth = sectionImage.size.width + self.segmentEdgeInset.left + self.segmentEdgeInset.right;
      self.segmentWidth = MAX(imageWidth, self.segmentWidth);
    }
  } else if (self.type == LPDSegmentedTypeTextImages && self.widthStyle == LPDSegmentedWidthStyleFixed) {
    [self.sectionTitles enumerateObjectsUsingBlock:^(id titleString, NSUInteger idx, BOOL *stop) {
      CGFloat stringWidth =
        [self measureTitleAtIndex:idx].width + self.segmentEdgeInset.left + self.segmentEdgeInset.right;
      self.segmentWidth = MAX(stringWidth, self.segmentWidth);
    }];
  } else if (self.type == LPDSegmentedTypeTextImages && LPDSegmentedWidthStyleDynamic) {
    NSMutableArray *mutableSegmentWidths = [NSMutableArray array];

    int i = 0;
    [self.sectionTitles enumerateObjectsUsingBlock:^(id titleString, NSUInteger idx, BOOL *stop) {
      CGFloat stringWidth = [self measureTitleAtIndex:idx].width + self.segmentEdgeInset.right;
      UIImage *sectionImage = (self.sectionImages)[i];
      CGFloat imageWidth = sectionImage.size.width + self.segmentEdgeInset.left;

      CGFloat combinedWidth = MAX(imageWidth, stringWidth);

      [mutableSegmentWidths addObject:[NSNumber numberWithFloat:combinedWidth]];
    }];
    self.segmentWidthsArray = [mutableSegmentWidths copy];
  }

  self.scrollView.scrollEnabled = self.isUserDraggable;
  self.scrollView.contentSize = CGSizeMake([self totalSegmentedControlWidth], self.frame.size.height);
}

- (NSUInteger)sectionCount {
  if (self.type == LPDSegmentedTypeText) {
    return self.sectionTitles.count;
  } else if (self.type == LPDSegmentedTypeImages || self.type == LPDSegmentedTypeTextImages) {
    return self.sectionImages.count;
  }

  return 0;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
  if (newSuperview == nil)
    return;

  if (self.sectionTitles || self.sectionImages) {
    [self updateSegmentsRects];
  }
}

#pragma mark - Touch

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  UITouch *touch = [touches anyObject];
  CGPoint touchLocation = [touch locationInView:self];

  if (CGRectContainsPoint(self.bounds, touchLocation)) {
    NSInteger segment = 0;
    if (self.widthStyle == LPDSegmentedWidthStyleFixed) {
      segment = (touchLocation.x + self.scrollView.contentOffset.x) / self.segmentWidth;
    } else if (self.widthStyle == LPDSegmentedWidthStyleDynamic) {
      CGFloat widthLeft = (touchLocation.x + self.scrollView.contentOffset.x);
      for (NSNumber *width in self.segmentWidthsArray) {
        widthLeft = widthLeft - [width floatValue];

        if (widthLeft <= 0)
          break;

        segment++;
      }
    }

    NSUInteger sectionsCount = 0;

    if (self.type == LPDSegmentedTypeImages) {
      sectionsCount = [self.sectionImages count];
    } else if (self.type == LPDSegmentedTypeTextImages || self.type == LPDSegmentedTypeText) {
      sectionsCount = [self.sectionTitles count];
    }

    if (segment != self.selectedIndex && segment < sectionsCount) {
      if (self.isTouchEnabled)
        [self setSelectedIndex:segment animated:self.shouldAnimateUserSelection notify:YES];
    }
  }
}

#pragma mark - Scrolling

- (CGFloat)totalSegmentedControlWidth {
  if (self.type == LPDSegmentedTypeText && self.widthStyle == LPDSegmentedWidthStyleFixed) {
    _segmentActualWidth = self.sectionTitles.count * self.segmentWidth;
  } else if (self.widthStyle == LPDSegmentedWidthStyleDynamic) {
    _segmentActualWidth = [[self.segmentWidthsArray valueForKeyPath:@"@sum.self"] floatValue];
  } else {
    _segmentActualWidth = (CGFloat)(self.sectionImages.count * self.segmentWidth);
  }
  return _segmentActualWidth;
}

- (void)scrollToSelectedSegmentIndex:(BOOL)animated {
  CGRect rectForSelectedIndex;
  CGFloat selectedSegmentOffset = 0;
  if (self.widthStyle == LPDSegmentedWidthStyleFixed) {
    rectForSelectedIndex =
      CGRectMake(self.segmentWidth * self.selectedIndex, 0, self.segmentWidth, self.frame.size.height);

    selectedSegmentOffset = (CGRectGetWidth(self.frame) / 2) - (self.segmentWidth / 2);
  } else if (self.widthStyle == LPDSegmentedWidthStyleDynamic) {
    NSInteger i = 0;
    CGFloat offsetter = 0;
    for (NSNumber *width in self.segmentWidthsArray) {
      if (self.selectedIndex == i)
        break;
      offsetter = offsetter + [width floatValue];
      i++;
    }

    rectForSelectedIndex =
      CGRectMake(offsetter, 0, [(self.segmentWidthsArray)[self.selectedIndex] floatValue], self.frame.size.height);

    selectedSegmentOffset =
      (CGRectGetWidth(self.frame) / 2) - ([(self.segmentWidthsArray)[self.selectedIndex] floatValue] / 2);
  }

  CGRect rectToScrollTo = rectForSelectedIndex;
  rectToScrollTo.origin.x -= selectedSegmentOffset;
  rectToScrollTo.size.width += selectedSegmentOffset * 2;
  [self.scrollView scrollRectToVisible:rectToScrollTo animated:animated];
}

#pragma mark - Index Change

- (void)setSelectedIndex:(NSInteger)index {
  [self setSelectedIndex:index animated:NO notify:NO];
}

- (void)setSelectedIndex:(NSUInteger)index animated:(BOOL)animated {
  [self setSelectedIndex:index animated:animated notify:NO];
}

- (void)setSelectedIndex:(NSUInteger)index animated:(BOOL)animated notify:(BOOL)notify {
  _selectedIndex = index;
  [self setNeedsDisplay];

  if (index == LPDSegmentedNoSegment) {
    [self.selectionIndicatorArrowLayer removeFromSuperlayer];
    [self.selectionIndicatorStripLayer removeFromSuperlayer];
    [self.selectionIndicatorBoxLayer removeFromSuperlayer];
  } else {
    [self scrollToSelectedSegmentIndex:animated];

    if (animated) {
      if (self.selectionStyle == LPDSegmentedSelectionStyleArrow) {
        if ([self.selectionIndicatorArrowLayer superlayer] == nil) {
          [self.scrollView.layer addSublayer:self.selectionIndicatorArrowLayer];

          [self setSelectedIndex:index animated:NO notify:YES];
          return;
        }
      } else {
        if ([self.selectionIndicatorStripLayer superlayer] == nil) {
          [self.scrollView.layer addSublayer:self.selectionIndicatorStripLayer];

          if (self.selectionStyle == LPDSegmentedSelectionStyleBox &&
              [self.selectionIndicatorBoxLayer superlayer] == nil)
            [self.scrollView.layer insertSublayer:self.selectionIndicatorBoxLayer atIndex:0];

          [self setSelectedIndex:index animated:NO notify:YES];
          return;
        }
      }

      if (notify)
        [self notifyForSegmentChangeToIndex:index];

      self.selectionIndicatorArrowLayer.actions = nil;
      self.selectionIndicatorStripLayer.actions = nil;
      self.selectionIndicatorBoxLayer.actions = nil;

      [CATransaction begin];
      [CATransaction setAnimationDuration:0.15f];
      [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
      [self setArrowFrame];
      self.selectionIndicatorBoxLayer.frame = [self frameForSelectionIndicator];
      self.selectionIndicatorStripLayer.frame = [self frameForSelectionIndicator];
      self.selectionIndicatorBoxLayer.frame = [self frameForFillerSelectionIndicator];
      [CATransaction commit];
    } else {
      NSMutableDictionary *newActions =
        [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNull null], @"position", [NSNull null], @"bounds", nil];
      self.selectionIndicatorArrowLayer.actions = newActions;
      [self setArrowFrame];

      self.selectionIndicatorStripLayer.actions = newActions;
      self.selectionIndicatorStripLayer.frame = [self frameForSelectionIndicator];

      self.selectionIndicatorBoxLayer.actions = newActions;
      self.selectionIndicatorBoxLayer.frame = [self frameForFillerSelectionIndicator];

      if (notify)
        [self notifyForSegmentChangeToIndex:index];
    }
  }
}

- (void)notifyForSegmentChangeToIndex:(NSInteger)index {
  if (self.superview)
    [self sendActionsForControlEvents:UIControlEventValueChanged];

  if (self.selectionChanged)
    self.selectionChanged(index);
}

#pragma mark - Styling Support

- (NSDictionary *)resultingTitleTextAttributes {
  NSDictionary *defaults = @{
    NSFontAttributeName: [UIFont fontWithName:@"STHeitiSC-Light" size:18.0f],
    NSForegroundColorAttributeName: [UIColor blackColor],
  };

  NSMutableDictionary *resultingAttrs = [NSMutableDictionary dictionaryWithDictionary:defaults];

  if (self.titleTextAttributes) {
    //    UIColor *foregroundColor = [resultingAttrs valueForKey:NSForegroundColorAttributeName];
    //    if (foregroundColor) {
    //      [resultingAttrs removeObjectForKey:NSForegroundColorAttributeName];
    //      [resultingAttrs setValue:(__bridge id)foregroundColor.CGColor forKey:(NSString
    //      *)kCTForegroundColorAttributeName];
    //    }
    [resultingAttrs addEntriesFromDictionary:self.titleTextAttributes];
  }

  return [resultingAttrs copy];
}

- (NSDictionary *)resultingSelectedTitleTextAttributes {
  NSMutableDictionary *resultingAttrs =
    [NSMutableDictionary dictionaryWithDictionary:[self resultingTitleTextAttributes]];

  if (self.selectedTitleTextAttributes) {
    //    UIColor *foregroundColor = [resultingAttrs valueForKey:NSForegroundColorAttributeName];
    //    if (foregroundColor) {
    //      [resultingAttrs removeObjectForKey:NSForegroundColorAttributeName];
    //      [resultingAttrs setValue:(__bridge id)foregroundColor.CGColor forKey:(NSString
    //      *)kCTForegroundColorAttributeName];
    //    }
    [resultingAttrs addEntriesFromDictionary:self.selectedTitleTextAttributes];
  }

  return [resultingAttrs copy];
}

@end
