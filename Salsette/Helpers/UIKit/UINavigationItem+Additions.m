//
//  UINavigationItem+Additions.m
//  ForeverMapNGX
//
//  Created by Cristian Chertes on 1/27/14.
//  Copyright (c) 2014 Skobbler. All rights reserved.
//

#import "UINavigationItem+Additions.h"

@implementation UINavigationItem (Additions)

- (void)setOSDependentLeftCustomView:(UIView *)view {
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    
    if ([UIDevice majorSystemVersion] < 7) {
        self.leftBarButtonItem = buttonItem;
    } else { // os 7 or later
        UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceButtonItem.width = -11.0;
        [self setLeftBarButtonItems:@[spaceButtonItem, buttonItem]];
    }
}

- (void)setOSDependentLeftBarButtonItems:(NSArray *)items {
    if ([UIDevice majorSystemVersion] < 7) {
        [self setLeftBarButtonItems:items];
    } else { // os 7 or later
        UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceButtonItem.width = -11.0;
        [self setLeftBarButtonItems:[@[spaceButtonItem] arrayByAddingObjectsFromArray:items]];
    }
}

- (void)setOSDependentRightCustomView:(UIView *)view {
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    
    if ([UIDevice majorSystemVersion] < 7) {
        self.rightBarButtonItem = buttonItem;
    } else { // os 7 or later
        UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceButtonItem.width = -11.0;
        [self setRightBarButtonItems:@[spaceButtonItem, buttonItem]];
    }
}

- (void)setOSDependentRightBarButtonItems:(NSArray *)items {
    if ([UIDevice majorSystemVersion] < 7) {
        [self setRightBarButtonItems:items];
    } else { // os 7 or later
        UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceButtonItem.width = -11.0;
        [self setRightBarButtonItems:[@[spaceButtonItem] arrayByAddingObjectsFromArray:items]];
    }
}

@end
