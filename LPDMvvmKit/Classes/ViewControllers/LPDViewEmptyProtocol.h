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

- (void)showEmptyViewWithImage:(UIImage *_Nullable)image title:(NSString *_Nullable)title subTitle:(NSString *_Nullable)subtitle button:(UIButton *_Nullable)button actionBlock:(void(^_Nullable)())actionBlock;
@end
