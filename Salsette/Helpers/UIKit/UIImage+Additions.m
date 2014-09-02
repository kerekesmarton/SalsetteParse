//
//  UIImage+Additions.m
//  ForeverMapNGX
//
//  Created by Bogdan Sala on 1/6/14.
//  Copyright (c) 2014 Skobbler. All rights reserved.
//

#import "UIImage+Additions.h"

@implementation UIImage (Additions)

+ (CGRect)rectForUIImage:(UIImage *)value inRect:(CGRect)rect {
    CGFloat wfactor = value.size.width / rect.size.width;
    CGFloat hfactor = value.size.height / rect.size.height;
    
    CGFloat factor = fmax(fmax(wfactor, hfactor), 1.0);
    
    // Divide the size by the greater of the vertical or horizontal shrinkage factor
    CGFloat newWidth = floorf(value.size.width / factor);
    CGFloat newHeight = floorf(value.size.height / factor);
    
    // Then figure out if you need to offset it to center vertically or horizontally
    CGFloat leftOffset = floorf((rect.size.width - newWidth) / 2.0);
    CGFloat topOffset = floorf((rect.size.height - newHeight) / 2.0);
    
    return CGRectMake(rect.origin.x + leftOffset, rect.origin.y + topOffset, newWidth, newHeight);
}

@end
