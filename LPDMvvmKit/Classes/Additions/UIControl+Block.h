//
//  UIControl+Block.h
//  LPDAdditions
//
//  Created by foxsofter on 15/2/23.
//  Copyright (c) 2015年 foxsofter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (Block)

- (void)touchDown:(void (^)(void))eventBlock;

- (void)touchDownRepeat:(void (^)(void))eventBlock;

- (void)touchDragInside:(void (^)(void))eventBlock;

- (void)touchDragOutside:(void (^)(void))eventBlock;

- (void)touchDragEnter:(void (^)(void))eventBlock;

- (void)touchDragExit:(void (^)(void))eventBlock;

- (void)touchUpInside:(void (^)(void))eventBlock;

- (void)touchUpOutside:(void (^)(void))eventBlock;

- (void)touchCancel:(void (^)(void))eventBlock;

- (void)valueChanged:(void (^)(void))eventBlock;

- (void)editingDidBegin:(void (^)(void))eventBlock;

- (void)editingChanged:(void (^)(void))eventBlock;

- (void)editingDidEnd:(void (^)(void))eventBlock;

- (void)editingDidEndOnExit:(void (^)(void))eventBlock;

@end