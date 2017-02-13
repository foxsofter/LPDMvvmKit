//
//  LPDScrollViewController+LPDExam.m
//  LPDMvvmKit
//
//  Created by foxsofter on 17/2/6.
//  Copyright © 2017年 foxsofter. All rights reserved.
//

#import "LPDScrollViewController+LPDExam.h"
#import "MJRefreshLPDHeader.h"

@implementation LPDScrollViewController (LPDExam)

#pragma mark - LPDScrollViewControllerProtocol

- (MJRefreshHeader *)customLoadingHeader:(MJRefreshComponentRefreshingBlock)refreshingBlock {
  MJRefreshLPDHeader *header = [MJRefreshLPDHeader headerWithRefreshingBlock:refreshingBlock];
  NSMutableArray<UIImage *> *images = [NSMutableArray array];
  for (NSInteger i = 1; i <= 10; i++) {
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refreshing-%ld", (long)i]];
    [images addObject:image];
  }
  [header setImages:images duration:1.0f forState:MJRefreshStateRefreshing];
  [header setImages:@[[UIImage imageNamed:@"静态"]] forState:MJRefreshStatePulling];
  [header setImages:@[[UIImage imageNamed:@"静态"]] forState:MJRefreshStateIdle];
  
  return header;
}

- (MJRefreshFooter *)customLoadingFooter:(MJRefreshComponentRefreshingBlock)refreshingBlock {
  MJRefreshAutoFooter *footer = [MJRefreshAutoFooter footerWithRefreshingBlock:refreshingBlock];
  footer.triggerAutomaticallyRefreshPercent = 0.1f;
  
  return footer;
}

@end
