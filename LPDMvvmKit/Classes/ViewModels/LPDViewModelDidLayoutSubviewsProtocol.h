//
//  LPDViewModelDidLayoutSubviewsProtocol.h
//  Pods
//
//  Created by foxsofter on 17/2/6.
//
//

#import <Foundation/Foundation.h>

@protocol LPDViewModelDidLayoutSubviewsProtocol <NSObject>

/**
 *  @brief YES when viewDidLayoutSubviews.
 */
@property (nonatomic, assign, getter=isDidLayoutSubviews) BOOL didLayoutSubviews;

/**
 *  @brief Triggers when viewDidLayoutSubviews equals YES.
 */
@property (nonatomic, strong, readonly) RACSignal *didLayoutSubviewsSignal;

@end
