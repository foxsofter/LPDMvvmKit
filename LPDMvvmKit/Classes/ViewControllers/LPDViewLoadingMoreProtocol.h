//
//  LPDViewLoadingMoreProtocol.h
//  Pods
//
//  Created by foxsofter on 17/2/6.
//
//

#import <Foundation/Foundation.h>
#import <MJRefresh/MJRefresh.h>

@protocol LPDViewLoadingMoreProtocol <NSObject>

@optional

/**
 *  @brief 初始化上拉加载Footer
 */
+ (MJRefreshFooter *)initLoadingFooter:(MJRefreshComponentRefreshingBlock)refreshingBlock;

@end
