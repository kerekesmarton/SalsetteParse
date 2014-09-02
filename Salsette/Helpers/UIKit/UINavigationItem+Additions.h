//
//  UINavigationItem+Additions.h
//  ForeverMapNGX
//
//  Created by Cristian Chertes on 1/27/14.
//  Copyright (c) 2014 Skobbler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationItem (Additions)

- (void)setOSDependentLeftCustomView:(UIView *)view;
- (void)setOSDependentLeftBarButtonItems:(NSArray *)items;
- (void)setOSDependentRightCustomView:(UIView *)view;
- (void)setOSDependentRightBarButtonItems:(NSArray *)items;

@end
