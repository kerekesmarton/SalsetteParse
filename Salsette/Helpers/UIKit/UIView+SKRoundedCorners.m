//
//  UIView+SKRoundedCorners.m
//  ForeverMapNGX
//
//  Created by Voicu Simu on 22/05/14.
//  Copyright (c) 2014 Skobbler. All rights reserved.
//

#import "UIView+SKRoundedCorners.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (SKRoundedCorners)

+ (void)roundCornersOnView:(UIView *)view onTopLeft:(BOOL)tl topRight:(BOOL)tr bottomLeft:(BOOL)bl bottomRight:(BOOL)br radius:(float)radius {
    
    if (tl || tr || bl || br) {
        
        UIRectCorner corner; //holds the corner
        //Determine which corner(s) should be changed
        if (tl) {
            corner = UIRectCornerTopLeft;
        }
        if (tr) {
            UIRectCorner add = corner | UIRectCornerTopRight;
            corner = add;
        }
        if (bl) {
            UIRectCorner add = corner | UIRectCornerBottomLeft;
            corner = add;
        }
        if (br) {
            UIRectCorner add = corner | UIRectCornerBottomRight;
            corner = add;
        }
        
        UIView *roundedView = view;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:roundedView.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = roundedView.bounds;
        maskLayer.path = maskPath.CGPath;
        roundedView.layer.mask = maskLayer;
    } else {
        UIView *roundedView = view;
        roundedView.layer.mask = nil;
    }
}
@end
