//
//  LPDViewModelDidLoadViewProtocol.h
//  Pods
//
//  Created by foxsofter on 17/2/6.
//
//

#import <Foundation/Foundation.h>

@protocol LPDViewModelDidLoadViewProtocol <NSObject>

/**
 *  @brief YES when viewDidLoad, NO when viewDidUnload
 */
@property (nonatomic, assign, getter = isDidLoadView) BOOL didLoadView;

/**
 *  @brief Triggers when didLoadView equals YES.
 */
@property (nonatomic, strong, readonly) RACSignal *didLoadViewSignal;

/**
 *  @brief Triggers when didLoadView equals NO.
 */
@property (nonatomic, strong, readonly) RACSignal *didUnloadViewSignal;

@end
