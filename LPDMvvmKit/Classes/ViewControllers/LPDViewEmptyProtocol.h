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
- (void)setCustomEmptyView:(UIView *_Nullable)customEmptyView;

- (void)hideEmptyView;

- (void)showEmptyViewWithDescription:(NSString *_Nullable)description;

@end
