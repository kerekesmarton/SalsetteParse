//
//  UIViewController+CoverImage.m
//  Salsette
//
//  Created by Kerekes, Marton on 25/03/15.
//
//

#import "UIViewController+CoverImage.h"
#import <objc/runtime.h>
#import <Parse/Parse.h>

static void *imgViewKey;
static void *imgViewOffset;

@implementation UIViewController (CoverImage)

@dynamic imageView,initialSize;

-(UIImageView *)imageView {
    UIImageView *imgv = objc_getAssociatedObject(self, &imgViewKey);
    if (!imgv) {
        return nil;
    }
    return imgv;
}

-(void)setImageView:(UIImageView *)imgView {
    objc_setAssociatedObject(self, &imgViewKey, imgView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(CGSize)initialSize {
    NSString *size = objc_getAssociatedObject(self, &imgViewOffset);
    if (!size) {
        return CGSizeMake(0, 0);
    }
    return CGSizeFromString(size);

}

-(void)setInitialSize:(CGSize)initialSize {
    objc_setAssociatedObject(self, &imgViewOffset, NSStringFromCGSize(initialSize), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < 0) {
        self.imageView.frameY = MIN(0, scrollView.contentOffset.y);
        self.imageView.frameHeight = self.initialSize.height - scrollView.contentOffset.y;        
        self.imageView.superview.frame = self.imageView.frame;
    }
}

-(void)scaleImageView:(UIScrollView *)scrollView {
    
//    self.imageView.contentScaleFactor = 
//    CGRect frame = self.imageView.frame;
//    frame.size.height =  MAX((frame.size.height-scrollView.contentOffset.y),self.initialSize.height);
//    self.imageView.frame = frame;
//    NSLog(@"%@",NSStringFromCGRect(frame));
//
//
//
//    self.imageView.. = 1 + (abs(MIN(scrollView.contentOffsetY,0))/self.view.frameWidth);
}
@end
