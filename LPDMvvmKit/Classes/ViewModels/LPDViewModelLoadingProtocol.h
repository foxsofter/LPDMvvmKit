
//
//  LPDViewModelLoadingProtocol.h
//  Pods
//
//  Created by foxsofter on 17/2/6.
//
//

#import <Foundation/Foundation.h>

@protocol LPDViewModelLoadingProtocol <NSObject>

/**
 *  @brief  If YES, shows the loading view and triggers loading signal, default is NO.
 */
@property (nonatomic, assign, getter = isLoading) BOOL loading;

/**
 *  @brief  The signal of loading current view.
 *
 *  @return  loading RACSignal
 */
@property (nullable, nonatomic, strong) RACSignal *loadingSignal;

/**
 *  @brief Shows the retry view or not, default is NO,
 */
@property (nonatomic, assign) BOOL needRetryLoading;

@end
