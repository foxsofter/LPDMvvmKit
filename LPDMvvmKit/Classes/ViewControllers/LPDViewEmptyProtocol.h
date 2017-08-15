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

- (void)hideEmptyView;

- (void)showEmptyViewWithImage:(UIImage *_Nullable)image title:(NSString *_Nullable)title subTitle:(NSString *_Nullable)subTitle;

@end
