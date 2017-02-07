//
//  MJRefreshLPDHeader.h
//  Pods
//
//  Created by 李博 on 16/6/16.
//
//

#import "MJRefreshHeader.h"

@interface MJRefreshLPDHeader : MJRefreshHeader

/** 显示标题的label */
@property (strong, nonatomic, readonly) UILabel *titleLabel;

/** 显示刷新状态的label */
@property (strong, nonatomic, readonly) UILabel *stateLabel;

/** 显示刷新动画的imageView */
@property (strong, nonatomic, readonly) UIImageView *gifView;

/** 设置state状态下的文字 */
- (void)setStateTitle:(NSString *)stateTitle forState:(MJRefreshState)state;

/** 设置state状态下的动画图片images 动画持续时间duration*/
- (void)setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(MJRefreshState)state;

- (void)setImages:(NSArray *)images forState:(MJRefreshState)state;

@end
