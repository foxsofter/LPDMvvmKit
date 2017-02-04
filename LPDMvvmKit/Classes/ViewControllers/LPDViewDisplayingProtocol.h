//
//  LPDViewDisplayingProtocol.h
//  Pods
//
//  Created by foxsofter on 17/2/4.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LPDViewDisplayingProtocol <NSObject>

@optional

+ (void)displayNormalView:(UIView *)view;

+ (void)displayNoDataView:(UIView *)view withDescription:(NSString *_Nullable)description;

+ (void)displayRetryView:(UIView *)view withDescription:(NSString *_Nullable)description;

@end

NS_ASSUME_NONNULL_END
