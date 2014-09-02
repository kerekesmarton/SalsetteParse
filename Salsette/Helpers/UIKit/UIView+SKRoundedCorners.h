//
//  UIView+SKRoundedCorners.h
//  ForeverMapNGX
//
//  Created by Voicu Simu on 22/05/14.
//  Copyright (c) 2014 Skobbler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SKRoundedCorners)

+ (void)roundCornersOnView:(UIView *)view onTopLeft:(BOOL)tl topRight:(BOOL)tr bottomLeft:(BOOL)bl bottomRight:(BOOL)br radius:(float)radius;

@end
