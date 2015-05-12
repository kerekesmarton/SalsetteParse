//
//  UIImageView+Additions.m
//  Salsette
//
//  Created by Kerekes, Marton on 28/04/15.
//
//

#import "UIImageView+Additions.h"

@implementation UIImageView (Additions)

- (CGFloat)modifyImageHeightByAspectRatio
{
    if (self.image == nil)
    {
        return 0;
    }
    
    CGFloat imageWidth = self.image.size.width;
    CGFloat imageHeight = self.image.size.height;
    
    CGFloat frameWidth = self.frame.size.width;
    CGFloat frameHeight = self.frame.size.height;
    
    CGFloat aspectRatio = imageWidth/imageHeight;
    
    CGFloat newHeight = frameWidth / aspectRatio;
    CGFloat difference = frameHeight - newHeight;
    
    CGRect frame = self.frame;
    frame.size.height = newHeight;
    self.frame = frame;
    
    return difference;
}

@end
