//
//  LPDViewEmptyProtocol.h
//  Pods
//
//  Created by foxsofter on 17/2/6.
//
//

#import <Foundation/Foundation.h>

@protocol LPDViewEmptyProtocol <NSObject>

@optional

+ (void)hideEmptyView:(UIView *)view;

+ (void)showEmptyView:(UIView *)view withDescription:(NSString *_Nullable)description;

@end
