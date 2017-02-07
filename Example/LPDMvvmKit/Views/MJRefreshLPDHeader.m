//
//  MJRefreshLPDHeader.m
//  Pods
//
//  Created by 李博 on 16/6/16.
//
//

#import "MJRefreshLPDHeader.h"

@interface MJRefreshLPDHeader () {
  __strong UILabel *_titleLabel;
  __strong UILabel *_stateLabel;
  __strong UIImageView *_gifView;
}
/** 所有标题的文字 */
@property (strong, nonatomic) NSMutableArray *titles;
/** 所有状态对应的文字 */
@property (strong, nonatomic) NSMutableDictionary *stateTitles;
/** 所有状态对应的动画图片 */
@property (strong, nonatomic) NSMutableDictionary *stateImages;
/** 所有状态对应的动画时间 */
@property (strong, nonatomic) NSMutableDictionary *stateDurations;

@end

@implementation MJRefreshLPDHeader
#pragma mark - 懒加载

- (NSMutableArray *)titles {
  if (!_titles) {
    _titles = [NSMutableArray arrayWithObjects:@"留意备注 核对餐品",@"多带餐具 避免遗漏",@"固定餐品 避免洒汤",@"遵守法规 注意安全",@"停放车辆 记得上锁",@"热情主动 面带微笑",@"轻按门铃 礼貌电话",@"如有倾洒 主动道歉", nil];
  }
  return _titles;
}

- (NSMutableDictionary *)stateTitles {
  if (!_stateTitles) {
    _stateTitles = [NSMutableDictionary dictionary];
  }
  return _stateTitles;
}

- (NSMutableDictionary *)stateImages {
  if (!_stateImages) {
    _stateImages = [NSMutableDictionary dictionary];
  }
  return _stateImages;
}

- (NSMutableDictionary *)stateDurations {
  if (!_stateDurations) {
    _stateDurations = [NSMutableDictionary dictionary];
  }
  return _stateDurations;
}

- (UILabel *)titleLabel {
  if (!_titleLabel) {
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0];
    // 设置标题文字
    NSInteger i = arc4random() % self.titles.count;
    self.titleLabel.text = self.titles[i];
    [self addSubview:_titleLabel];
  }
  return _titleLabel;
}

- (UILabel *)stateLabel {
  if (!_stateLabel) {
    _stateLabel = [[UILabel alloc] init];
    _stateLabel.font = [UIFont systemFontOfSize:10];
    _stateLabel.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0];
    [self addSubview:_stateLabel];
  }
  return _stateLabel;
}

- (UIImageView *)gifView {
  if (!_gifView) {
    _gifView = [[UIImageView alloc] init];
    [self addSubview:_gifView];
  }
  return _gifView;
}

#pragma mark - 公共方法
- (void)setStateTitle:(NSString *)stateTitle forState:(MJRefreshState)state {
  if (stateTitle == nil)
    return;
  self.stateTitles[@(state)] = stateTitle;
  self.stateLabel.text = self.stateTitles[@(self.state)];
}

- (void)setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(MJRefreshState)state {
  if (images == nil)
    return;

  self.stateImages[@(state)] = images;
  self.stateDurations[@(state)] = @(duration);

  /* 根据图片设置控件的高度 */
  UIImage *image = [images firstObject];
  if (image.size.height > self.mj_h) {
    self.mj_h = image.size.height;
  }
}

- (void)setImages:(NSArray *)images forState:(MJRefreshState)state {
  [self setImages:images duration:images.count * 0.1 forState:state];
}

#pragma mark - 覆盖父类的方法

- (void)setPullingPercent:(CGFloat)pullingPercent {
  [super setPullingPercent:pullingPercent];
  NSArray *images = self.stateImages[@(MJRefreshStateIdle)];
  if (self.state != MJRefreshStateIdle || images.count == 0)
    return;
  // 停止动画
  [self.gifView stopAnimating];
  // 设置当前需要显示的图片
  NSUInteger index = images.count * pullingPercent;
  if (index >= images.count)
    index = images.count - 1;
  self.gifView.image = images[index];
}

- (void)prepare {
  [super prepare];

  // 初始化文字
  [self setStateTitle:@"下拉刷新" forState:MJRefreshStateIdle];
  [self setStateTitle:@"松手更新" forState:MJRefreshStatePulling];
  [self setStateTitle:@"更新中..." forState:MJRefreshStateRefreshing];
}

- (void)placeSubviews {
  [super placeSubviews];

  if (self.stateLabel.hidden)
    return;

  BOOL noConstrainsOnStatusLabel = self.stateLabel.constraints.count == 0;

  if (self.titleLabel.hidden) {
    // 状态
    if (noConstrainsOnStatusLabel)
      self.stateLabel.frame = self.bounds;
  } else {

    // 状态
    if (noConstrainsOnStatusLabel) {
      self.stateLabel.mj_x = self.center.x - 25;
      self.stateLabel.mj_y = self.mj_h - 15;
      self.stateLabel.mj_w = self.mj_w * 0.5 + 25;
      self.stateLabel.mj_h = 14;
    }

    // 标题
    if (self.titleLabel.constraints.count == 0) {
      self.titleLabel.mj_x = self.center.x - 25;
      self.titleLabel.mj_y = self.mj_h - 37;
      self.titleLabel.mj_w = self.mj_w * 0.5 + 25;
      self.titleLabel.mj_h = 21;
    }
  }

  if (self.gifView.constraints.count)
    return;

  self.gifView.frame = self.bounds;
  if (self.stateLabel.hidden && self.titleLabel.hidden) {
    self.gifView.contentMode = UIViewContentModeCenter;
  } else {
    self.gifView.contentMode = UIViewContentModeRight;
    self.gifView.mj_w = self.mj_w * 0.5 - 25;
  }
}

- (void)setState:(MJRefreshState)state {
  MJRefreshCheckState

    if (state == MJRefreshStateIdle) {
    // 设置标题文字
    NSInteger i = arc4random() % self.titles.count;
    self.titleLabel.text = self.titles[i];
  }

  // 设置状态文字
  self.stateLabel.text = self.stateTitles[@(state)];

  // 根据状态做事情
  if (state == MJRefreshStatePulling || state == MJRefreshStateRefreshing) {
    NSArray *images = self.stateImages[@(state)];
    if (images.count == 0)
      return;

    [self.gifView stopAnimating];
    if (images.count == 1) { // 单张图片
      self.gifView.image = [images lastObject];
    } else { // 多张图片
      self.gifView.animationImages = images;
      self.gifView.animationDuration = [self.stateDurations[@(state)] doubleValue];
      [self.gifView startAnimating];
    }
  } else if (state == MJRefreshStateIdle) {
    [self.gifView stopAnimating];
  }
}

@end
